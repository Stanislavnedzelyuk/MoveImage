#!/bin/bash

# Проверка на передачу директории
if [ -z "$1" ]; then
    echo "Ошибка: Не указан путь к верхней папке. Использование: $0 </Users/stanislav/Downloads/1" >&2
    exit 1
fi

# Определение верхней папки
TOP_DIR="$1"

# Проверка, существует ли директория
if [ ! -d "$TOP_DIR" ]; then
    echo "Ошибка: Директория $TOP_DIR не существует" >&2
    exit 1
fi

# Лог-файл для записи ошибок
LOG_FILE="move_images.log"
echo "Логирование ошибок в файл: $LOG_FILE"

# Перемещение всех изображений из поддиректорий в верхнюю директорию
echo "Начинается перемещение изображений из поддиректорий в: $TOP_DIR"
find "$TOP_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -exec mv {} "$TOP_DIR" \; 2>> "$LOG_FILE"

# Проверка, были ли ошибки
if [ $? -eq 0 ]; then
    echo "Все изображения успешно перемещены в верхнюю папку: $TOP_DIR"
else
    echo "Произошли ошибки при перемещении изображений. Подробности в файле $LOG_FILE" >&2
fi

