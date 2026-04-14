#!/bin/bash
set -e

REPO="https://github.com/asutoshr97/skillcrew.git"
TMP_DIR=$(mktemp -d)

echo "Installing Skillcrew..."

# Clone to temp directory
git clone --quiet "$REPO" "$TMP_DIR"

# Install logpose skills
mkdir -p .claude/commands
cp "$TMP_DIR/skills/logpose/"*.md .claude/commands/
echo "  Installed logpose skills to .claude/commands/"

# Set up knowledge directory
if [ ! -d "knowledge" ]; then
    mkdir -p knowledge
    cp "$TMP_DIR/templates/knowledge-readme.md" knowledge/README.md
    echo "  Created knowledge/ directory"
else
    echo "  knowledge/ directory already exists, skipping"
fi

# Clean up
rm -rf "$TMP_DIR"

echo ""
echo "Done! Start Claude Code and try /logpose-list"
