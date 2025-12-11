#!/bin/zsh
set -e

echo "Instalando Orion CLI…"

ORION_HOME="$HOME/orion-cli"

# Copia o projeto para a HOME do usuário
rm -rf "$ORION_HOME"
cp -r "$(pwd)" "$ORION_HOME"

# Garante que o binário esteja no PATH global do usuário
mkdir -p "$HOME/.local/bin"
ln -sf "$ORION_HOME/bin/orion" "$HOME/.local/bin/orion"

# Permissões
chmod +x "$ORION_HOME/bin/orion"
chmod -R +x "$ORION_HOME/commands"

echo ""
echo "✔ Orion CLI instalado com sucesso!"
echo "Execute: orion langflow run main"
echo ""

