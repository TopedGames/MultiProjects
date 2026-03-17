#!/bin/bash

CONFIG="config.txt"

# Найти проект с true
PROJECT=""
while IFS='=' read -r name value; do
  # Пропускаем пустые строки и комментарии
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

# Установка зависимостей если есть package.json
if [ -f "package.json" ]; then
  npm install
  npm start
elif [ -f "index.js" ]; then
  node index.js
else
  echo "Не знаю как запустить $PROJECT — нет package.json"
  exit 1
fi
