#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export TZ=America/Sao_Paulo

echo "Instalando Orion CLI..."

# Dependências sem prompts
apt-get update -y
apt-get install -y --no-install-recommends tzdata git curl build-essential

REPO_URL="https://github.com/andifilhohub/orion-cli.git"
ORION_HOME="$HOME/orion-cli"

rm -rf "$ORION_HOME"
git clone "$REPO_URL" "$ORION_HOME"

ln -sf "$ORION_HOME/bin/orion" /usr/local/bin/orion
chmod +x "$ORION_HOME/bin/orion"
chmod -R +x "$ORION_HOME/commands"

echo "✔ Orion CLI instalado com sucesso!"
echo "Execute: orion langflow run main"
