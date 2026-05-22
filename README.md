# nvgt-agent-guide

A reusable, drop-in template that teaches AI coding agents (Claude Code, Cursor,
and similar) how to work well with [NVGT](https://nvgt.dev) — the NonVisual
Gaming Toolkit, an audio game engine scripted in AngelScript.

If you're tired of explaining NVGT basics to every new agent session, this
guide does that work for you.

## Is this worth setting up?

An honest read, based on what the guide actually changes in agent behavior:

**Worth it if you're:**

- Doing nontrivial NVGT work across multiple sessions. The agent picks up
  momentum instead of re-deriving the same facts each time.
- Porting from BGT. The vendored `ref/bgt/` docs and the BGT-specific
  pitfalls catch tripwires an agent will otherwise hit (`array.length` vs
  `array.length()`, `var` as a reserved type, pack files needing
  `#pragma embed`, etc.).
- Working with current NVGT and want the agent grepping a real API dump
  for your installed version, not guessing from training data.

**Probably overkill if you're:**

- Writing one-off scripts and asking an agent about them ad hoc — pasting
  your own engine dump into the chat is faster than cloning a repo.
- An experienced NVGT developer reviewing the agent's code closely anyway.
  Most of the value here goes to the agent, not the human.

**Maintenance cost:** `ref/api-export/` only matches the NVGT version it
was generated against (see `VERSION.txt`). If NVGT updates significantly
and the guide isn't re-run, the agent will confidently write against a
stale API. Run `./scripts/refresh-ref.sh` periodically.

## What's inside

- **`CLAUDE.md`** — the agent-facing instructions. The entry point.
- **`ref/`** — authoritative reference material:
  - `nvgt.txt`: full language + stdlib reference, pulled from `nvgt.dev/docs`.
  - `api-export/`: signature dumps for every class, function, enum, and global
    in NVGT, in AngelScript declaration syntax (one flat file per kind, plus
    per-class and per-enum subdirectories for targeted reads).
  - `examples/`: ~110 small example scripts from NVGT's own test suite.
- **`docs/idioms.md` and `docs/pitfalls.md`** — distilled lessons that grow
  over time. Empty at first; the whole point is for the community to fill them.
- **`VERSION.txt`** — records the NVGT version (and commit hash, and
  AngelScript version) the current `ref/api-export/` was generated against.
  Check this to see if the guide is stale relative to your NVGT install.
- **`scripts/refresh-ref.sh`** — re-pulls `nvgt.txt`, examples, and the
  api-export from a local NVGT install. Run periodically to stay current.

## How to use it in your NVGT project

1. Clone this repo to a stable location of your choice — anywhere
   persistent works (`~/dev/`, `~/src/`, `~/Documents/`, etc.). Just
   remember the path for the next step:

       git clone https://github.com/zarvox32/nvgt-agent-guide

2. In your NVGT project's root, create or edit `CLAUDE.md` and add a single
   line that imports this guide. Substitute the actual path where you
   cloned it:

       @/absolute/path/to/nvgt-agent-guide/CLAUDE.md

   `~` and `$HOME` are honored by Claude Code, so
   `@~/dev/nvgt-agent-guide/CLAUDE.md` works too. The guide will be loaded
   into the agent's context whenever it opens your project. Agents that
   don't honor `@` imports can point at `CLAUDE.md` directly or symlink it.

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

Clone the repo on each machine at a path that works there. If you sync
your project's `CLAUDE.md` across machines (e.g., via git), pick a path
shape you can use on both — for instance, `~/dev/nvgt-agent-guide` works
on macOS/Linux and as `%USERPROFILE%\dev\nvgt-agent-guide` on Windows, and
the `@~/dev/nvgt-agent-guide/CLAUDE.md` import will resolve on each OS.
If you'd rather not commit to a shared convention, keep the import line in
a local-only `CLAUDE.local.md` and gitignore it.

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
