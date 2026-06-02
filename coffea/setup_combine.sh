#!/bin/bash
# Builds and installs CMS Combine into the active conda/pixi environment.
# Skips the build if `combine` is already on PATH (i.e. already installed).
set -e

if command -v combine > /dev/null 2>&1; then
    echo "Combine already installed at $(command -v combine), skipping build."
    exit 0
fi

echo "=========================================="
echo " Installing CMS Combine v10.6.0"
echo " This runs once and takes a few minutes."
echo "=========================================="

REPO_DIR="HiggsAnalysis/CombinedLimit"

if [ ! -d "$REPO_DIR" ]; then
    git clone --depth 1 --branch v10.6.0 \
        https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit.git \
        "$REPO_DIR"
fi

PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

cmake -S "$REPO_DIR" -B "$REPO_DIR/build" \
    -DCMAKE_INSTALL_PREFIX="$CONDA_PREFIX" \
    -DCMAKE_INSTALL_PYTHONDIR="lib/python${PYVER}/site-packages" \
    -DUSE_VDT=OFF \
    -GNinja

cmake --build "$REPO_DIR/build" --parallel
cmake --install "$REPO_DIR/build"

echo "Combine installed successfully!"
