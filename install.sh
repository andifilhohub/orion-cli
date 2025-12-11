#!/bin/bash
set -e

REPO_URL="https://github.com/andifilhohub/orion-cli.git"
ORION_HOME="$HOME/orion-cli"

echo ""
echo "Instalando Orion CLI..."
echo ""

# -----------------------------------------------------------------------------
# 1. Instala dependências mínimas antes de qualquer coisa
# -----------------------------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  echo "→ git não encontrado. Instalando..."
  apt update && apt install -y git
fi

# -----------------------------------------------------------------------------
# 2. Clona o repositório
# -----------------------------------------------------------------------------
rm -rf "$ORION_HOME"
git clone "$REPO_URL" "$ORION_HOME"

# -----------------------------------------------------------------------------
# 3. Cria o binário global em /usr/local/bin
# -----------------------------------------------------------------------------
ln -sf "$ORION_HOME/bin/orion" /usr/local/bin/orion

chmod +x "$ORION_HOME/bin/orion"
chmod -R +x "$ORION_HOME/commands"

echo ""
echo "✔ Orion CLI instalado com sucesso!"
echo ""
echo "Execute: orion langflow run main"
echo ""
