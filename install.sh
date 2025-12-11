#!/bin/zsh
set -e

REPO_URL="https://github.com/andifilhohub/orion-cli.git"
ORION_HOME="$HOME/orion-cli"
LOCAL_BIN="$HOME/.local/bin"

echo ""
echo "Instalando Orion CLI..."
echo ""

rm -rf "$ORION_HOME"
git clone "$REPO_URL" "$ORION_HOME"

mkdir -p "$LOCAL_BIN"
ln -sf "$ORION_HOME/bin/orion" "$LOCAL_BIN/orion"

chmod +x "$ORION_HOME/bin/orion"
chmod -R +x "$ORION_HOME/commands"

if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
    echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >> ~/.zshrc
    export PATH="$LOCAL_BIN:$PATH"
    echo ""
    echo "⚠️ Adicionado ~/.local/bin ao PATH. Abra um novo terminal para aplicar."
    echo ""
fi

echo "✔ Orion CLI instalado com sucesso!"
echo "Execute: orion langflow run main"
echo ""
