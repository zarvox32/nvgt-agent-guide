#!/usr/bin/env bash
# Refresh the reference material in ref/ against current upstream sources.
#
# What this does:
#   - Re-downloads ref/nvgt.txt from nvgt.dev.
#   - Replaces ref/examples/ with the latest test/quick/*.nvgt files from the
#     NVGT GitHub repo.
#
# What this does NOT do:
#   - Regenerate ref/api-export/. Those files are produced by NVGT itself
#     (the engine's export command) and must be regenerated against a local
#     NVGT install. Once we capture the exact command, this script should
#     run it automatically. For now, the api-export refresh is manual —
#     see SOURCES.md.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF="$HERE/ref"

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

echo
echo "Done. Don't forget to update SOURCES.md with today's date and the"
echo "commit hash above, and to regenerate ref/api-export/ if your local"
echo "NVGT install has been updated."
