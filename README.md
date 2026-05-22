# nvgt-agent-guide

A reusable, drop-in template that teaches AI coding agents (Claude Code, Cursor,
and similar) how to work well with [NVGT](https://nvgt.dev) — the NonVisual
Gaming Toolkit, an audio game engine scripted in AngelScript.

If you're tired of explaining NVGT basics to every new agent session, this
guide does that work for you.

## What's inside

- **`CLAUDE.md`** — the agent-facing instructions. The entry point.
- **`ref/`** — authoritative reference material:
  - `nvgt.txt`: full language + stdlib reference, pulled from `nvgt.dev/docs`.
  - `api-export/`: signature dumps for every class, function, enum, and global
    in NVGT, in AngelScript declaration syntax.
  - `examples/`: ~110 small example scripts from NVGT's own test suite.
- **`docs/idioms.md` and `docs/pitfalls.md`** — distilled lessons that grow
  over time. Empty at first; the whole point is for the community to fill them.
- **`scripts/refresh-ref.sh`** — re-pulls `nvgt.txt` and the examples from
  upstream. Run periodically to stay current.

## How to use it in your NVGT project

1. Clone this repo somewhere stable on your machine:

       git clone https://github.com/zarvox32/nvgt-agent-guide ~/code/nvgt/agent-guide

2. In your NVGT project's root, create or edit `CLAUDE.md` and add a single
   line that imports this guide:

       @~/code/nvgt/agent-guide/CLAUDE.md

   Claude Code will automatically load the guide into context whenever an
   agent opens your project. Other agents that don't honor `@` imports can
   point at the file directly or symlink it.

3. Start coding. The agent will know to consult `ref/`, run the compile loop,
   and follow NVGT idioms.

## Two usage modes

**Fresh NVGT project.** Just import `CLAUDE.md` as above and start writing
`.nvgt` files. The compile-loop rule and reference grep habit apply
unchanged.

**Porting from BGT.** Use the layout NVGT's author recommends:

    your-project/
    ├── CLAUDE.md          # one line: @path/to/nvgt-agent-guide/CLAUDE.md
    ├── old/               # the original BGT source
    └── src/               # rewrite target

Then ask the agent to read `old/`, rewrite into `src/`, and compile each
file as it goes.

## Cross-device setup (Mac + Windows)

Clone the repo on each machine, e.g. `~/code/nvgt/agent-guide` on macOS/Linux
and `%USERPROFILE%\code\nvgt\agent-guide` on Windows. The `@` import in your
project's `CLAUDE.md` resolves on each OS.

## Refreshing the reference material

NVGT evolves. Run:

    ./scripts/refresh-ref.sh

This re-downloads `nvgt.txt` and pulls fresh examples from the NVGT repo.
The `ref/api-export/` files are produced by NVGT itself (the export command)
and should be regenerated periodically against a current NVGT install — see
`SOURCES.md` for details.

## Contributing

Found a pitfall, a non-obvious behavior, or an idiom that just works? Update
`docs/pitfalls.md` or `docs/idioms.md` locally and open a PR against this
repo. The template gets better every time someone teaches it something.

Keep entries short:

- One clear rule.
- One short rationale (why it's true / where it bit you).
- One minimal example if useful.

## License and attribution

The structure, prose, and scripts in this repo are MIT-licensed (see
`LICENSE`). The contents of `ref/` are derived from NVGT and remain under
NVGT's [zlib license](https://github.com/samtupy/nvgt/blob/main/license.md) —
see `NOTICE` for the full attribution.

NVGT is © 2022–2025 Sam Tupy.
