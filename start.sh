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

echo "=== Содержимое папки ==="
ls -la

# Node.js проект
if [ -f "package.json" ]; then
  echo "Тип: Node.js"
  npm install
  npm start

# Python проект
elif [ -f "requirements.txt" ]; then
  echo "Тип: Python"
  pip install -r requirements.txt
  # Ищем главный файл
  if [ -f "daxcs.py" ]; then
    python daxcs.py
  elif [ -f "main.py" ]; then
    python main.py
  elif [ -f "index.py" ]; then
    python index.py
  else
    echo "Не найден главный .py файл"
    sleep infinity
  fi

else
  echo "Не знаю как запустить $PROJECT — нет package.json и requirements.txt"
  sleep infinity
fi
