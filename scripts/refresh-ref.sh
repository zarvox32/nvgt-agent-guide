#!/usr/bin/env bash
# Refresh the reference material in ref/ against current upstream sources.
#
# What this does:
#   - Re-downloads ref/nvgt.txt from nvgt.dev.
#   - Replaces ref/examples/ with the latest test/quick/*.nvgt files from the
#     NVGT GitHub repo.
#   - Regenerates ref/api-export/ by running scripts/generate_engine_dump.nvgt
#     against the local NVGT install.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF="$HERE/ref"

# Locate nvgt. Prefer PATH; fall back to standard macOS install location.
if command -v nvgt >/dev/null 2>&1; then
	NVGT="$(command -v nvgt)"
elif [[ -x /Applications/nvgt.app/Contents/MacOS/nvgt ]]; then
	NVGT="/Applications/nvgt.app/Contents/MacOS/nvgt"
else
	echo "error: nvgt not on PATH and not at /Applications/nvgt.app/Contents/MacOS/nvgt" >&2
	echo "       install NVGT or add it to PATH, then re-run." >&2
	exit 1
fi

echo "==> Using NVGT at $NVGT"

echo "==> Refreshing $REF/nvgt.txt from nvgt.dev..."
curl -fsSL https://nvgt.dev/docs/nvgt.txt -o "$REF/nvgt.txt"
echo "    $(wc -c < "$REF/nvgt.txt") bytes"

echo "==> Refreshing $REF/examples/ from samtupy/nvgt..."
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
git clone --depth 1 --quiet https://github.com/samtupy/nvgt.git "$TMP/nvgt"

# Clear and repopulate examples.
rm -f "$REF/examples/"*.nvgt
cp "$TMP/nvgt/test/quick/"*.nvgt "$REF/examples/"
COMMIT="$(cd "$TMP/nvgt" && git rev-parse HEAD)"
COUNT="$(ls "$REF/examples/" | wc -l | tr -d ' ')"
echo "    $COUNT example files from NVGT @ $COMMIT"

echo "==> Regenerating $REF/api-export/ from local NVGT install..."
DUMP_OUT="$TMP/api-export"
"$NVGT" "$HERE/scripts/generate_engine_dump.nvgt" "$DUMP_OUT"

# Replace api-export contents. Keep the raw engine_dump.txt name our SOURCES.md
# advertises (the script writes engine_dump.log).
rm -rf "$REF/api-export"
mkdir -p "$REF/api-export"
cp "$DUMP_OUT/classes.txt"   "$REF/api-export/classes.txt"
cp "$DUMP_OUT/enums.txt"     "$REF/api-export/enums.txt"
cp "$DUMP_OUT/functions.txt" "$REF/api-export/functions.txt"
cp "$DUMP_OUT/globals.txt"   "$REF/api-export/globals.txt"
cp "$DUMP_OUT/engine_dump.log" "$REF/api-export/engine_dump.txt"
cp -R "$DUMP_OUT/classes"    "$REF/api-export/classes"
cp -R "$DUMP_OUT/enums"      "$REF/api-export/enums"
echo "    $(ls "$REF/api-export/classes" | wc -l | tr -d ' ') classes, $(ls "$REF/api-export/enums" | wc -l | tr -d ' ') enums"

echo
echo "Done. Don't forget to update SOURCES.md with today's date and the"
echo "examples commit hash above ($COMMIT)."
