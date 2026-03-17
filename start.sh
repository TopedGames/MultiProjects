#!/bin/bash

CONFIG="config.txt"

declare -A REPOS
REPOS["Errogram"]="https://${GITHUB_TOKEN}@github.com/TopedGames/Errogram.git"
REPOS["MineflayerBots"]="https://${GITHUB_TOKEN}@github.com/TopedGames/MineflayerBots.git"
REPOS["TGB.Deputy_Administrator_XChara"]="https://${GITHUB_TOKEN}@github.com/TopedGames/TGB.Deputy_Administrator_XChara.git"

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

if [ ! -d "$PROJECT/.git" ]; then
  echo "Клонирую $PROJECT..."
  rm -rf "$PROJECT"
  git clone "${REPOS[$PROJECT]}" "$PROJECT"
fi

cd "$PROJECT" || { echo "Папка не найдена"; sleep infinity; }

# Node.js проект
if [ -f "package.json" ]; then
  echo "Тип: Node.js"
  npm install
  npm start

# Python проект
elif [ -f "requirements.txt" ] || [ -f "daxcs.py" ] || [ -f "main.py" ]; then
  echo "Тип: Python"
  # Установка Python если нет
  if ! command -v python3 &>/dev/null; then
    echo "Устанавливаю Python..."
    apt-get update -qq && apt-get install -y python3 python3-pip
  fi
  pip3 install -r requirements.txt --break-system-packages
  if [ -f "daxcs.py" ]; then
    python3 daxcs.py
  elif [ -f "main.py" ]; then
    python3 main.py
  elif [ -f "index.py" ]; then
    python3 index.py
  fi

else
  echo "Не знаю как запустить $PROJECT"
  sleep infinity
fi
