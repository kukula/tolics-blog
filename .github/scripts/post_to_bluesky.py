#!/usr/bin/env python3
"""Post new RSS entries to Bluesky."""

import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

import feedparser
import requests

BSKY_HANDLE = os.environ["BSKY_HANDLE"]
BSKY_APP_PASSWORD = os.environ["BSKY_APP_PASSWORD"]
RSS_URL = os.environ.get("RSS_URL", "https://freerangetolic.com/index.xml")
LAST_RUN_FILE = Path(".github/last_bsky_post.json")


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


def get_last_run():
    """Get the last run timestamp."""
    if LAST_RUN_FILE.exists():
        data = json.loads(LAST_RUN_FILE.read_text())
        return datetime.fromisoformat(data["last_run"])
    return None


def save_last_run():
    """Save current timestamp."""
    LAST_RUN_FILE.parent.mkdir(parents=True, exist_ok=True)
    LAST_RUN_FILE.write_text(
        json.dumps({"last_run": datetime.now(timezone.utc).isoformat()})
    )


def main():
    feed = feedparser.parse(RSS_URL)
    last_run = get_last_run()

    new_entries = []
    for entry in feed.entries:
        published = datetime(*entry.published_parsed[:6], tzinfo=timezone.utc)
        if last_run is None or published > last_run:
            new_entries.append(entry)

    if not new_entries:
        print("No new posts to share.")
        save_last_run()
        return

    session = bsky_login()

    for entry in new_entries[:3]:  # Limit to 3 posts per run
        title = entry.title
        url = entry.link
        text = f"New blog post: {title}\n\n{url}"

        # Truncate if needed (300 char limit)
        if len(text) > 300:
            max_title = 300 - len(url) - len("New: \n\n")
            text = f"New: {title[:max_title]}...\n\n{url}"

        print(f"Posting: {title}")
        result = create_post(session, text)
        print(f"  -> {result['uri']}")

    save_last_run()
    print("Done!")


if __name__ == "__main__":
    main()
