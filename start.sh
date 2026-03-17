#!/bin/bash

# Инициализация сабмодулей
apt-get install -y git 2>/dev/null || true
git init
git remote add origin https://github.com/TopedGames/MultiProjects.git 2>/dev/null || true
git submodule update --init --recursive 2>/dev/null || true

CONFIG="config.txt"

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
  exit 1
fi

echo "Запускаю проект: $PROJECT"

cd "$PROJECT" || { echo "Папка $PROJECT не найдена"; exit 1; }

if [ -f "package.json" ]; then
  npm install
  npm start
elif [ -f "index.js" ]; then
  node index.js
else
  echo "Не знаю как запустить $PROJECT"
  exit 1
fi
