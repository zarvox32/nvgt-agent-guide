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
