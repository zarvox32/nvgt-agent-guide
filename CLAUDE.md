# Working on NVGT projects

This file teaches AI agents (Claude Code, Cursor, etc.) how to write NVGT code
well. NVGT is the NonVisual Gaming Toolkit — an audio game engine that runs
AngelScript-based `.nvgt` files.

Official site: https://nvgt.dev

## Reference material in this guide

The `ref/` folder is your source of truth. **Prefer it over your prior
knowledge** — if a memory and `ref/` disagree, `ref/` wins. NVGT evolves; your
training data may be stale.

- **`ref/nvgt.txt`** — full language and stdlib reference, generated from
  NVGT source (~1 MB). Read sections relevant to your task; do not dump the
  whole file into context unprompted.
- **`ref/api-export/classes.txt`** — every NVGT class with full method and
  property signatures, in AngelScript declaration syntax. Look up the exact
  signature of any method here before calling it.
- **`ref/api-export/classes/<Name>.txt`** — one file per class (same content
  as `classes.txt`). Read this when you only need a single class and don't
  want to grep the full bundle.
- **`ref/api-export/functions.txt`** — every top-level function and `funcdef`
  (callback type) signature. Same pattern: look up before calling.
- **`ref/api-export/enums.txt`** — enum constants flattened, without
  per-enum headers. To find which enum a constant belongs to, look at
  `enums/<EnumName>.txt` instead.
- **`ref/api-export/enums/<Name>.txt`** — one file per enum, with the enum
  name in the filename.
- **`ref/api-export/globals.txt`** — global constants.
- **`ref/examples/`** — small, idiomatic NVGT scripts curated from the NVGT
  test suite. Prefer patterns you see here over patterns you invent.
- **`docs/pitfalls.md` and `docs/idioms.md`** — distilled lessons from prior
  sessions. Short and high-signal; read these.

**When you need an API: grep `ref/api-export/*.txt` for the name.** The
signature there is authoritative. Match argument types and `const`/`&in`/
`&out`/`@` modifiers exactly.

## NVGT vs BGT

NVGT is mostly compatible with BGT (Blastbay Gaming Toolkit) scripts but is
not identical. If you are porting BGT code, do not assume BGT idioms still
work — verify each API against `ref/api-export/` and `ref/nvgt.txt`.

**Two upstream docs are vendored locally and worth reading before any port:**

- **`ref/bgt/upgrading.md`** — NVGT's official "Upgrading From BGT" manual
  chapter. Lists missing features, renamed functions, behavioral
  differences, and renamed key constants. Read this first when starting a
  port.
- **`ref/bgt/compat-layer.md`** — reference for the `bgt_compat.nvgt`
  include (see below). Lists every alias the shim provides.

**The `#include "bgt_compat.nvgt"` shim** is a compatibility include — *not*
a translator. Adding it to old BGT code remaps function names and key
constants (`KEY_PRIOR` → `KEY_PAGEUP`, `string_len` → `string.length`,
etc.) so a lot of code compiles unchanged. It does **not** fix:

- Method-vs-property changes (`array.length` is now `array.length()`).
- Signature changes (`tts_voice.set_voice(...)` parameters differ).
- Behavioral differences (encrypted data isn't compatible, screen reader
  APIs ignore the reader argument, etc.).
- Reserved-word collisions (`var` is now a type — BGT code using `var` as
  a variable name will break).
- Pack file `#include` (use `#pragma embed packname.dat` instead).

Treat the shim as a stop-gap for a quick first compile, then rewrite onto
native NVGT APIs incrementally. See `docs/pitfalls.md` for the specific
gotchas worth memorizing.

## The compile loop is your correctness check

NVGT scripts are compiled by the `nvgt` CLI. **After any change to a `.nvgt`
file, run:**

    nvgt -c <path-to-script>.nvgt

This compiles without running and surfaces errors. Treat compile failures the
way you would type errors in TypeScript: fix them before moving on. Do not
declare work complete on a `.nvgt` file you have not compiled.

### Finding the `nvgt` binary

Check these in order before giving up:

1. **PATH:** `command -v nvgt` (or `which nvgt` / `where nvgt`).
2. **macOS standard install:** `/Applications/nvgt.app/Contents/MacOS/nvgt`.
   NVGT ships as a regular `.app` bundle; the CLI is the binary inside.
3. **Windows standard install:** `C:\nvgt\nvgt.exe` (the installer's
   default location).
4. **Linux:** PATH usually; otherwise ask.

Only ask the user once you've checked the standard locations for the
current OS. Do not assume "not on PATH" means "not installed."

## When porting from BGT

The workflow recommended by NVGT's author:

1. Original BGT source lives in `old/`. Read it carefully *in full* before
   writing anything.
2. Rewrite into `src/` one logical unit at a time.
3. Compile each new file with `nvgt -c src/<file>.nvgt` and fix errors
   immediately. Do not move on with red on the screen.
4. Do not bulk-translate. Port a piece, compile it, sanity-check behavior,
   then proceed.

## Style and scope

- Port faithfully. Don't add features, abstractions, or "improvements" beyond
  what the user asked for. Refactor only when explicitly requested.
- Prefer NVGT idioms (as seen in `ref/examples/`) over BGT idioms when they
  differ.
- Don't invent stdlib functions or method signatures. If you can't find an
  API in `ref/api-export/*.txt`, ask — don't guess.

## When you learn something new

If you discover a pitfall, a non-obvious API behavior, or an idiom that
worked well, update `docs/pitfalls.md` or `docs/idioms.md` *locally* in
this guide, then open a pull request against the upstream repo so the
whole community benefits:

  https://github.com/zarvox32/nvgt-agent-guide

Keep entries short and high-signal: one clear rule, one short rationale,
one minimal example if useful. The goal is a doc worth re-reading, not an
exhaustive log.
