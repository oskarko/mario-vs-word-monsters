#!/bin/sh
# Regenerates Assets.xcassets/AppIcon.appiconset/AppIcon.png from MonsterView.
set -e
cd "$(dirname "$0")/.."
OUT=$(mktemp -d)
swiftc -o "$OUT/icon" \
  Scripts/main.swift \
  MarioMonsters/Views/Components/MonsterView.swift \
  MarioMonsters/Model/Content.swift \
  MarioMonsters/Views/Components/Theme.swift
"$OUT/icon" MarioMonsters/Assets.xcassets/AppIcon.appiconset/AppIcon.png
