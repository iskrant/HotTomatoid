#!/bin/bash

# Скрипт для упаковки плагина HotTomatoid в .plasmoid файл

PLUGIN_NAME="HotTomatoid"
PACKAGE_NAME="hottomatoid"
OUTPUT_FILE="${PLUGIN_NAME}.plasmoid"

echo "Создание пакета для ${PLUGIN_NAME}..."

# Проверяем, существует ли директория с плагином
if [ ! -d "${PACKAGE_NAME}/package" ]; then
    echo "Ошибка: Директория ${PACKAGE_NAME}/package не найдена!"
    exit 1
fi

# Удаляем старый пакет, если он существует
if [ -f "$OUTPUT_FILE" ]; then
    echo "Удаление старого пакета..."
    rm "$OUTPUT_FILE"
fi

# Переходим в директорию с плагином
cd "${PACKAGE_NAME}/package"

# Создаем zip-архив с плагином
echo "Упаковка файлов..."
zip -r "../../$OUTPUT_FILE" .

# Возвращаемся в исходную директорию
cd ../..

# Проверяем, был ли создан пакет
if [ -f "$OUTPUT_FILE" ]; then
    echo ""
    echo "✅ Успешно! Пакет создан: $OUTPUT_FILE"
    echo ""
    echo "Для установки плагина выполните:"
    echo "plasmapkg2 -i $OUTPUT_FILE"
    echo " или:"
    echo ""
    echo "./install.sh"
    echo "Или двойной щелчок по файлу в файловом менеджере"
    echo ""
    echo "После установки:"
    echo "1. Нажмите правой кнопкой мыши на панели задач"
    echo "2. Выберите 'Добавить виджеты...'"
    echo "3. Найдите HotTomatoid в списке"
    echo "4. Перетащите на панель задач"
    echo "5. Для отладки: kquitapp5 plasmashell && plasmashell &"
else
    echo "❌ Ошибка: Не удалось создать пакет"
    exit 1
fi