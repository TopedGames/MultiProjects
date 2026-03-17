#!/bin/bash

CONFIG="config.txt"

declare -A REPOS
REPOS["Errogram"]="https://github.com/TopedGames/Errogram.git"
REPOS["MineflayerBots"]="https://github.com/TopedGames/MineflayerBots.git"
REPOS["TGB.Deputy_Administrator_XChara"]="https://github.com/TopedGames/TGB.Deputy_Administrator_XChara.git"

PROJECT=""
while IFS='=' read -r name value; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  value=$(echo "$value" | tr -d '[:space:]')
  if [ "$value" = "true" ]; then
    PROJECT="$name"
    break
  fi
done < "$CONFIG"

if [ -z "$PROJECT" ]; then
  echo "Ошибка: ни один проект не выбран в config.txt"
  sleep infinity
fi

echo "Запускаю проект: $PROJECT"

if [ ! -f "$PROJECT/package.json" ]; then
  echo "Клонирую $PROJECT..."
  rm -rf "$PROJECT"
  git clone "${REPOS[$PROJECT]}" "$PROJECT"
fi

cd "$PROJECT" || { echo "Папка не найдена"; sleep infinity; }

npm install
npm start
