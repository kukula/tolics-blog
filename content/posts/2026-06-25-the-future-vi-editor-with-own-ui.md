---
title: "What if vi, but the whole UI was yours?"
date: 2026-06-25
lastmod: 2026-06-25
draft: false
author: "Tolic Kukul"
description: "Neovim is a maze, Helix flipped the grammar, Zed left the terminal. So here's the editor I want: a tiny vi-like core with a UI you script entirely in Lua."
tags: ["vim", "rust", "ai", "software-development", "software-architecture"]
categories: ["Software Development"]
illustration: "a lone builder assembles a compact control console from modular levers and gears handed over by a robot, a small fast engine humming at the core."
---

I keep wanting an editor that doesn't exist. Here's the dream, out loud.

## The itch

I love Neovim. But its Lua API is a maze — thirty years of Vim internals, faithfully exposed. The mess *is* the backward compatibility.

Helix is gorgeous — Rust, rope-based, tree-sitter native, fast. But it flipped the grammar to select-then-act. Not a remap. A relearn.

Zed nailed the Rust core. But it's a GUI, and I live in the terminal.

An empty slot. Nobody's in it.

## The vision

Something tiny. Fast. Bare bones. Like vi.

But the terminal UI — windows, splits, layout — is exposed to Lua through ratatui. You don't get a fixed editor. You get primitives, and build the editor on top.

The heavy lifting stays in Rust:

- [**ropey**](https://github.com/cessen/ropey) for the text buffer — fast edits on huge files.
- [**tree-sitter**](https://tree-sitter.github.io/tree-sitter/) for parsing and syntax.
- [**ratatui**](https://ratatui.rs/) for rendering and layout.

A small, honest Lua API sits over it. No cruft. Just the primitives, done well.

The split is basically frontend / backend. Lua owns state and intent. Rust owns the render loop and the buffer. One clean handoff per frame.

And this isn't a research project — the parts are already on the shelf. [**mlua**](https://github.com/mlua-rs/mlua) binds Rust to Lua, safely and fast. ratatui, ropey, and tree-sitter are all production-grade. **ratatui-py** already drives ratatui from Python over FFI — proof the approach works across a scripting boundary. Swap Python for Lua and that's the skeleton. Glue, not invention.

## Why now

A small, honest API isn't just nice for humans — it's what makes AI useful here.

An LLM can read and write your *entire* editor. The surface is tiny, with one obvious way to do things. And it doesn't matter that no model ever trained on this API — the whole surface fits in a prompt, so the model reads the docs and writes against them live. Neovim's API is as hard for a model as it is for you: too much cruft, too many paths to the same outcome. "Small clean API" and "AI-native" are the same feature.

This is what makes the timing right. Every new editor hits the same cold start: an empty plugin ecosystem. Nobody switches without their plugins. Nobody writes plugins until people switch. That deadlock stalls most new editors. Not this one. Agentic assistants write the plugins you need, against a cleaner API than most ecosystems ever had. Useful from day one.

What that unlocks:

- Describe a workflow in plain words. The model emits Lua. The editor hot-reloads it, live.
- Want a new panel layout? Ask. The model writes the ratatui code and it appears.
- Your UI becomes a conversation, not a config file you wrestle for hours.

Sharing still matters, so plugins exist. Just Lua, in a git repo, lazy-loaded. You build your own setup; when a friend makes something good, you pull it in. The fresh plugin ecosystem is opt-in, not load-bearing.

## The pitch in one line

A tiny vi-like core, where the entire UI is scriptable in Lua, riding on Rust primitives that are already fast.

Small enough to understand in an afternoon. Hackable to the bone.

Perhaps it already exists and I missed it. If not, I'll keep wanting it until someone builds it — or until I do. Either way, it's yours.
