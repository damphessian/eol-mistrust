#!/usr/bin/env bash

# Dependencies:
# pip install jupyter future modernize jupytext

set -euo pipefail

TARGET_DIR="${1:-.}"

command -v jupytext >/dev/null 2>&1 || { echo "Missing: jupytext"; exit 1; }
command -v futurize  >/dev/null 2>&1 || { echo "Missing: futurize"; exit 1; }

USE_MODERNIZE=false
if command -v python-modernize >/dev/null 2>&1; then
    USE_MODERNIZE=true
fi

PY_OUT="$TARGET_DIR/py3_converted"
NB_OUT="$TARGET_DIR/py3_notebooks"
mkdir -p "$PY_OUT" "$NB_OUT"

shopt -s nullglob
for nb in "$TARGET_DIR"/*.ipynb; do
    base=$(basename "$nb" .ipynb)
    py_tmp="$PY_OUT/${base}.py"
    nb_out="$NB_OUT/${base}_py3.ipynb"

    echo "---------------------------------------------"
    echo "Converting notebook: $nb"
    echo "→ script:            $py_tmp"
    echo "→ py3 notebook:      $nb_out"
    echo

    # 1. Convert to percent-format Python script
    jupytext --to py:percent --output "$py_tmp" "$nb"

    # 2. Apply futurize
    futurize -w "$py_tmp"

    # 3. Optional: python-modernize
    if [ "$USE_MODERNIZE" = true ]; then
        python-modernize -w "$py_tmp"
    fi

    # 4. Convert back to notebook
    jupytext --to ipynb --output "$nb_out" "$py_tmp"

    echo "Finished: $nb_out"
    echo
done

echo "Done."
echo "Python 3 scripts:    $PY_OUT"
echo "Python 3 notebooks:  $NB_OUT"
