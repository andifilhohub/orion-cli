#!/bin/bash
set -e

BRANCH=$1
BASE_DIR="$HOME/orion"
PROJECT_DIR="$BASE_DIR/langflow"

if [[ -z "$BRANCH" ]]; then
  echo "Uso: orion langflow run <branch>"
  exit 1
fi

echo "➡ Preparando ambiente para Langflow ($BRANCH)..."

# -----------------------------------------------------------------------------
# 1. Instalar dependências básicas (git, curl, etc)
# -----------------------------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  echo "→ Instalando git..."
  apt update && apt install -y git
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "→ Instalando curl..."
  apt update && apt install -y curl
fi

# -----------------------------------------------------------------------------
# 2. Instalar uv (se necessário)
# -----------------------------------------------------------------------------
if ! command -v uv >/dev/null 2>&1; then
  echo "→ Instalando UV..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# 3. Instalar Python (se necessário)
# -----------------------------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  echo "→ Instalando Python..."
  apt update && apt install -y python3 python3-venv python3-pip
fi

# -----------------------------------------------------------------------------
# 4. Instalar Node.js + npm (se necessário)
# -----------------------------------------------------------------------------
if ! command -v npm >/dev/null 2>&1; then
  echo "→ Instalando Node.js e npm..."
  apt update && apt install -y nodejs npm
fi

# -----------------------------------------------------------------------------
# 5. Clonar Langflow (se necessário)
# -----------------------------------------------------------------------------
mkdir -p "$BASE_DIR"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "→ Clonando Langflow..."
  git clone https://github.com/langflow-ai/langflow.git "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

echo "→ Atualizando código..."
git fetch --all
git checkout "$BRANCH"
git pull origin "$BRANCH"

# -----------------------------------------------------------------------------
# 6. Criar virtualenv e instalar dependências
# -----------------------------------------------------------------------------
if [[ ! -d ".venv" ]]; then
  echo "→ Criando ambiente Python..."
  uv venv
fi

source .venv/bin/activate

echo "→ Instalando dependências Python..."
uv pip install -U -e ".[all]"

# -----------------------------------------------------------------------------
# 7. Build do frontend
# -----------------------------------------------------------------------------
echo "→ Construindo frontend..."
cd src/frontend
npm ci
npm run build
cd ../..

# -----------------------------------------------------------------------------
# 8. Copiar build para backend
# -----------------------------------------------------------------------------
BUILD_DIR=""
[ -d src/frontend/dist ]  && BUILD_DIR=src/frontend/dist
[ -d src/frontend/build ] && BUILD_DIR=src/frontend/build

TARGET=src/backend/base/langflow/frontend
mkdir -p "$TARGET"
rm -rf "$TARGET"/*
cp -r "$BUILD_DIR"/* "$TARGET"/

# -----------------------------------------------------------------------------
# 9. Rodar Langflow
# -----------------------------------------------------------------------------
echo ""
echo "✔ Ambiente pronto!"
echo "➡ Iniciando Langflow..."
echo ""

uv run langflow run --host 0.0.0.0 --port 7860
