# NVGT pitfalls

Mistakes that agents (or humans) make repeatedly when writing NVGT code, and
how to avoid them. Add entries as you discover them.

Format for each entry:

    ## Short description of the mistake

    **What goes wrong:** the symptom (compile error, runtime crash, silent
    misbehavior).

    **Why:** the underlying reason — usually a difference between NVGT and
    AngelScript/BGT/another language the agent might be pattern-matching
    against.

    **Fix:** the correct approach, ideally with a minimal example.

Keep entries terse. Prefer specifics ("this exact compiler message means
that exact thing") over vague guidance.

---

<!-- Add entries below this line. -->

## Finding `nvgt` on macOS when it's not on PATH

**What goes wrong:** `which nvgt` / `command -v nvgt` returns nothing, agent
concludes NVGT isn't installed and asks the user (or gives up). User is
mildly annoyed — it was installed all along.

**Why:** NVGT ships on macOS as a regular `.app` bundle that the user drags
into `/Applications`. The bundle doesn't symlink its CLI binary onto PATH,
so `which` won't find it even on a perfectly normal install.

**Fix:** On macOS, before asking, try
`/Applications/nvgt.app/Contents/MacOS/nvgt`. That's the CLI entry point
inside the bundle. The same `-c`/`-h`/script-runner interface as on Windows
or Linux applies.

## BGT: `array.length` is now `array.length()`

**What goes wrong:** code ported from BGT does `for (uint i = 0; i < a.length; i++)`
and the compiler rejects it.

**Why:** in BGT, `length` was a property; in NVGT (current AngelScript) it
is a method call.

**Fix:** use parentheses everywhere: `a.length()`. This applies to all
array types.

## BGT: `var` is a reserved type name

**What goes wrong:** a BGT script with variables named `var` (e.g.
`int var = 5;`) fails to compile in NVGT.

**Why:** NVGT registers a `var` type in its standard library.

**Fix:** rename the variable. Search the project for `\bvar\b` used as an
identifier and replace.

## BGT: pack files cannot be `#include`d

**What goes wrong:** `#include "mypack.dat"` from BGT either fails or
includes the binary as code, breaking compilation.

**Why:** in NVGT `#include` is for source files only. Pack embedding moved
to a separate directive.

**Fix:** use `#pragma embed mypack.dat` instead. Extension is arbitrary —
the distinction between code and pack is the directive, not the suffix.

## BGT: `sound.stream()` exists but is just an alias for `sound.load()`

**What goes wrong:** code keeps calling `stream()` and you assume it
streams the way BGT did.

**Why:** NVGT's `load()` already does a streaming+preloading hybrid by
default. `stream()` was kept only so old code compiles.

**Fix:** prefer `sound.load(path, pack)` in new code. The optional second
argument takes a pack handle (replaces BGT's `set_sound_storage`).

## BGT: encrypted data is not interchangeable with NVGT

**What goes wrong:** an NVGT port of a BGT game cannot read save files,
sound assets, or settings that the BGT version encrypted (and vice versa).

**Why:** NVGT uses different encryption primitives (`string_aes_*`,
`asset_encryptor`/`asset_decryptor`, `sound_default_decryption_key`); BGT's
`file_encrypt`/`file_decrypt`/`file_hash` don't exist at all.

**Fix:** if you must read BGT-encrypted data, decrypt it in BGT first and
re-encrypt with NVGT primitives. Otherwise plan a one-time migration.

## BGT: `bgt_compat.nvgt` is a shim, not a translator

**What goes wrong:** agent adds `#include "bgt_compat.nvgt"` to a BGT
script, sees it compile, declares the port done. Later: subtle runtime
differences in screen reader behavior, signature mismatches in
`tts_voice`, performance worse than native NVGT.

**Why:** the include only aliases names. Behavioral, signature, and
performance differences are unchanged.

**Fix:** use the shim as a fast first compile, then rewrite incrementally
against `ref/api-export/` and the per-difference notes in
`ref/bgt/upgrading.md`. Treat a clean compile with the shim as "ready to
start porting," not "done."

## BGT: renamed key constants

**What goes wrong:** code references `KEY_PRIOR`, `KEY_LCONTROL`,
`KEY_LBRACKET`, `KEY_NUMPADENTER`, etc., which don't exist in NVGT.

**Why:** NVGT's key constants follow SDL naming.

**Fix:** the full rename table is in `ref/bgt/upgrading.md`. Common ones:
`KEY_PRIOR`→`KEY_PAGEUP`, `KEY_NEXT`→`KEY_PAGEDOWN`,
`KEY_LCONTROL`→`KEY_LCTRL`, `KEY_LBRACKET`→`KEY_LEFTBRACKET`,
`KEY_NUMPADENTER`→`KEY_NUMPAD_ENTER`, `KEY_DASH`→`KEY_MINUS`. The
`bgt_compat.nvgt` include defines all the old names as aliases if you
prefer not to rename in-place.
