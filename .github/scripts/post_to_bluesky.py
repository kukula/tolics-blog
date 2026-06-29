#!/usr/bin/env python3
"""Post new RSS entries to Bluesky.

Dedupe is by entry URL (the RSS <guid>), not by timestamp: Hugo dates posts at
midnight of their day, which is almost always in the past relative to when the
site deploys, so a "published > last_run" check would never fire. We instead
keep a set of already-posted URLs in .github/last_bsky_post.json and share
anything not in it.
"""

import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path

import feedparser
import requests

BSKY_HANDLE = os.environ["BSKY_HANDLE"]
BSKY_APP_PASSWORD = os.environ["BSKY_APP_PASSWORD"]
RSS_URL = os.environ.get("RSS_URL", "https://freerangetolic.com/index.xml")
STATE_FILE = Path(".github/last_bsky_post.json")
MAX_POSTS_PER_RUN = 3


def bsky_login():
    """Authenticate and return session tokens."""
    resp = requests.post(
        "https://bsky.social/xrpc/com.atproto.server.createSession",
        json={"identifier": BSKY_HANDLE, "password": BSKY_APP_PASSWORD},
    )
    resp.raise_for_status()
    return resp.json()


def create_post(session, text):
    """Create a Bluesky post with auto-detected links."""
    now = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")

    # Detect URLs in text for rich text facets
    facets = []
    for match in re.finditer(r"https?://\S+", text):
        start = len(text[: match.start()].encode("utf-8"))
        end = len(text[: match.end()].encode("utf-8"))
        facets.append(
            {
                "index": {"byteStart": start, "byteEnd": end},
                "features": [
                    {
                        "$type": "app.bsky.richtext.facet#link",
                        "uri": match.group(),
                    }
                ],
            }
        )

    record = {
        "$type": "app.bsky.feed.post",
        "text": text,
        "createdAt": now,
        "langs": ["en"],
    }
    if facets:
        record["facets"] = facets

    resp = requests.post(
        "https://bsky.social/xrpc/com.atproto.repo.createRecord",
        headers={"Authorization": f"Bearer {session['accessJwt']}"},
        json={
            "repo": session["did"],
            "collection": "app.bsky.feed.post",
            "record": record,
        },
    )
    resp.raise_for_status()
    return resp.json()


def entry_id(entry):
    """Stable identifier for a feed entry (the <guid>, falling back to link)."""
    return getattr(entry, "id", None) or entry.link


def is_post(entry):
    """Only share blog posts, not standalone pages like /about or /search."""
    return "/posts/" in entry.link


def load_state():
    """Return (set of already-posted ids, whether prior state existed)."""
    if STATE_FILE.exists():
        try:
            data = json.loads(STATE_FILE.read_text())
        except json.JSONDecodeError:
            data = {}
        if "posted" in data:
            return set(data["posted"]), True
    return set(), False


def save_state(posted):
    """Persist the set of posted ids."""
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
    STATE_FILE.write_text(json.dumps({"posted": sorted(posted)}, indent=2) + "\n")


def main():
    feed = feedparser.parse(RSS_URL)
    posted, had_state = load_state()
    post_entries = [e for e in feed.entries if is_post(e)]

    if not had_state:
        # First run on this format with no pre-seeded state: mark the whole
        # current feed as posted so we don't spam the back catalogue. (The
        # migration normally pre-seeds the file, so this is just a safety net.)
        for entry in post_entries:
            posted.add(entry_id(entry))
        save_state(posted)
        print(f"Seeded {len(posted)} existing entries; nothing posted on first run.")
        return

    # Feed is newest-first; reverse so a multi-post run reads chronologically.
    new_entries = [e for e in post_entries if entry_id(e) not in posted]
    new_entries.reverse()

    if not new_entries:
        print("No new posts to share.")
        return

    session = bsky_login()

    for entry in new_entries[:MAX_POSTS_PER_RUN]:
        title = entry.title
        url = entry.link
        text = f"New blog post: {title}\n\n{url}"

        # Truncate if needed (300 char limit)
        if len(text) > 300:
            max_title = 300 - len(url) - len("New: \n\n...")
            text = f"New: {title[:max_title]}...\n\n{url}"

        print(f"Posting: {title}")
        result = create_post(session, text)
        print(f"  -> {result['uri']}")

        # Persist incrementally so a mid-run failure can't repost what went out.
        posted.add(entry_id(entry))
        save_state(posted)

    print("Done!")


if __name__ == "__main__":
    main()
