#!/bin/bash

# Проверка на передачу директории
if [ -z "$1" ]; then
    echo "Ошибка: Не указан путь к верхней папке. Использование: $0 <путь к верхней папке>" >&2
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

# Функция для безопасного перемещения файла
move_file() {
    local file_path="$1"
    local dest_dir="$2"
    local filename=$(basename "$file_path")
    local base_name="${filename%.*}"
    local extension="${filename##*.}"
    local counter=1

    # Проверяем, существует ли файл с таким именем в целевой директории
    while [ -e "$dest_dir/$filename" ]; do
        # Добавляем номер к имени файла
        filename="${base_name}_${counter}.${extension}"
        counter=$((counter + 1))
    done

    # Перемещаем файл
    mv "$file_path" "$dest_dir/$filename" 2>> "$LOG_FILE"
}

# Перемещение всех изображений из поддиректорий в верхнюю директорию
echo "Начинается перемещение изображений из поддиректорий в: $TOP_DIR"
find "$TOP_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | while read -r file; do
    move_file "$file" "$TOP_DIR"
done

# Проверка, были ли ошибки
if [ $? -eq 0 ]; then
    echo "Все изображения успешно перемещены в верхнюю папку: $TOP_DIR"
else
    echo "Произошли ошибки при перемещении изображений. Подробности в файле $LOG_FILE" >&2
fi
