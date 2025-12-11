#!/bin/zsh
set -e
BRANCH=$1
BASE_DIR="$HOME/orion"
PROJECT_DIR="$BASE_DIR/langflow"

mkdir -p "$BASE_DIR"
[ ! -d "$PROJECT_DIR" ] && git clone https://github.com/langflow-ai/langflow.git "$PROJECT_DIR"

cd "$PROJECT_DIR"
git fetch --all
git checkout "$BRANCH"
git pull origin "$BRANCH"

[ ! -d ".venv" ] && uv venv
source .venv/bin/activate

uv pip install -U -e .

cd src/frontend
npm ci
npm run build
cd ../..

BUILD_DIR=""
[ -d src/frontend/dist ] && BUILD_DIR=src/frontend/dist
[ -d src/frontend/build ] && BUILD_DIR=src/frontend/build

TARGET=src/backend/base/langflow/frontend
mkdir -p "$TARGET"
find "$TARGET" -mindepth 1 -delete
cp -r "$BUILD_DIR"/* "$TARGET"/

uv run langflow run --host 0.0.0.0 --port 7860

