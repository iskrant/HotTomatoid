#!/bin/bash

# HotTomatoid Installation Script
# Проверяет наличие плагина и устанавливает/обновляет его

set -e

PLUGIN_ID="org.kde.plasma.hottomatoid"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/hottomatoid/package"

echo "🍅 HotTomatoid Installation Script"
echo "================================="

# Проверяем наличие директории с пакетом
if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Ошибка: Директория с пакетом не найдена: $PACKAGE_DIR"
    exit 1
fi

# Проверяем установлен ли плагин
if plasmapkg2 -t plasmoid -l | grep -q "$PLUGIN_ID"; then
    echo "🔄 Плагин $PLUGIN_ID уже установлен, обновляем..."
    plasmapkg2 -t plasmoid -r "$PLUGIN_ID"
    if [ $? -eq 0 ]; then
        echo "✅ Старая версия удалена"
    else
        echo "⚠️  Не удалось удалить старую версию, продолжаем установку..."
    fi
else
    echo "📦 Плагин не найден, устанавливаем новую версию..."
fi

# Создаем временный пакет для установки
TEMP_PACKAGE="/tmp/hottomatoid.plasmoid"
echo "📁 Создание пакета..."

cp "$PACKAGE_DIR/metadata.json" /tmp/
cp -r "$PACKAGE_DIR/contents" /tmp/
cd /tmp
zip -r "$TEMP_PACKAGE" metadata.json contents/ > /dev/null 2>&1
rm -f metadata.json
rm -rf contents/

# Устанавливаем пакет
echo "🚀 Установка плагина..."
plasmapkg2 -t plasmoid -i "$TEMP_PACKAGE"

if [ $? -eq 0 ]; then
    echo "✅ Плагин успешно установлен!"
    rm -f "$TEMP_PACKAGE"
else
    echo "❌ Ошибка при установке плагина"
    rm -f "$TEMP_PACKAGE"
    exit 1
fi

# Перезапускаем Plasma
echo "🔄 Перезапуск Plasma Shell..."
echo "   Ваша панель и виджеты будут перезапущены"
echo "   Пожалуйста, подождите несколько секунд..."

# Перезапуск с использованием kquitapp5
if command -v kquitapp5 >/dev/null 2>&1; then
    kquitapp5 plasmashell
    sleep 2
    nohup plasmashell >/dev/null 2>&1 &
    echo "✅ Plasma перезапущена!"
else
    echo "⚠️  Команда kquitapp5 не найдена, попробуйте перезапустить вручную:"
    echo "   kquitapp5 plasmashell && plasmashell &"
fi

echo ""
echo "🎉 Готово! HotTomatoid установлен и готов к использованию."
echo "   Добавьте виджет на панель через правый клик → 'Добавить виджеты...'"
echo ""