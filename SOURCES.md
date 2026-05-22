# Sources

Provenance for the material in `ref/`. Update this file whenever you refresh
the contents.

## `ref/nvgt.txt`

- **Source:** https://nvgt.dev/docs/nvgt.txt
- **Last fetched:** 2026-05-22
- **Upstream `Last-Modified`:** 2026-03-25 (per server `Last-Modified` header)
- **Refresh:** `./scripts/refresh-ref.sh`

## `ref/examples/`

- **Source:** https://github.com/samtupy/nvgt — `test/quick/*.nvgt`
- **Commit:** `71bc0d5b096d3a3a38ebdd4484691175287cac5a` (main, 2026-05-01)
- **Last fetched:** 2026-05-22
- **Refresh:** `./scripts/refresh-ref.sh`

## `ref/api-export/`

Two layers of artifact here.

### Raw dump: `engine_dump.txt`

- **Source:** Produced by the NVGT stdlib function
  `script_dump_engine_configuration(datastream@)`, which writes
  AngelScript's `WriteConfigToStream` wire format — every registered type,
  method, property, enum, global, and behavior.
- **Generator:** `scripts/dump_engine.nvgt`.
- **Run:** `nvgt scripts/dump_engine.nvgt -- ../ref/api-export/engine_dump.txt`
  — NVGT sets CWD to the script's directory, so the output path is
  resolved from `scripts/`. Use `../…` or an absolute path.
- **Last regenerated:** 2026-05-22 against NVGT installed at
  `/Applications/nvgt.app` (AngelScript 2.39.0 WIP per the dump header).
- **Format:** raw config records (`objtype "x" 17`,
  `objmthd "x" "..."`, `enumval ENUM VAL 8`, ...). Grep it like any
  other text file.

### Pretty per-kind files: `classes.txt`, `functions.txt`, `enums.txt`, `globals.txt`

- **Source:** Unknown. These are in AngelScript declaration syntax
  (`class file { ... bool open(...); ... }`) grouped per kind. They are
  NOT the direct output of `script_dump_engine_configuration` — they're a
  post-processed view of the same data.
- **Last regenerated:** 2026-05-22 (origin unclear — carried over from
  initial scaffold).
- **Open question:** how were these generated? Is there a public tool
  that converts the raw dump into this declaration format? Asked
  upstream 2026-05-22:
  <https://github.com/samtupy/nvgt/discussions/394>. Once that's
  resolved, wire the regeneration into `scripts/refresh-ref.sh`.
