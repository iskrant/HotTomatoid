import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property int minutes: 45
    property int seconds: 0
    property bool running: false
    property string displayTime: formatTime(minutes, seconds)

    Plasmoid.title: "HotTomatoid"

    // Устанавливаем текст напрямую в заголовок плазмоида
    Plasmoid.toolTipMainText: "🕓" + displayTime
    Plasmoid.toolTipSubText: "Клик для запуска/остановки • Колесико для изменения времени"

    // Делаем так, чтобы плазмоид показывал текст на панели
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    function formatTime(mins, secs) {
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
    }

    function updateTimeDisplay() {
        displayTime = formatTime(minutes, seconds)
        Plasmoid.toolTipMainText = "🕓" + displayTime
        compactText.text = "🕓" + displayTime
        fullText.text = "🕓" + displayTime
    }

    Timer {
        id: countdownTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            if (seconds === 0) {
                if (minutes === 0) {
                    running = false
                    countdownTimer.running = false
                    return
                }
                minutes--
                seconds = 59
            } else {
                seconds--
            }
            // Обновляем отображение при каждом тике
            updateTimeDisplay()
        }
    }

    // Простое компактное представление
    Plasmoid.compactRepresentation: Text {
        id: compactText
        text: "🕓" + displayTime
        font.pixelSize: 14
        font.bold: true
        color: PlasmaCore.Theme.textColor

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    running = !running
                    countdownTimer.running = running
                }
            }
            onWheel: {
                wheel.accepted = true
                // Сбрасываем секунды при изменении времени
                seconds = 0
                if (wheel.angleDelta.y > 0) {
                    // Вверх - добавляем минуту
                    if (minutes < 99) {
                        minutes++
                    }
                } else {
                    // Вниз - убавляем минуту
                    if (minutes > 0) {
                        minutes--
                    }
                }
                // Обновляем отображение централизованно
                updateTimeDisplay()
                // Убеждаемся, что таймер остаётся в том же состоянии
                if (!running) {
                    countdownTimer.running = false
                }
            }
        }
    }

    // Полное представление (при клике)
    Plasmoid.fullRepresentation: Item {
        width: 200
        height: 100

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: fullText
                text: "🕓" + displayTime
                font.pixelSize: 24
                font.bold: true
                color: PlasmaCore.Theme.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: running ? "Стоп (клик)" : "Старт (клик)"
                font.pixelSize: 14
                color: PlasmaCore.Theme.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    running = !running
                    countdownTimer.running = running
                }
            }
            onWheel: {
                wheel.accepted = true
                // Сбрасываем секунды при изменении времени
                seconds = 0
                if (wheel.angleDelta.y > 0) {
                    // Вверх - добавляем 5 минут
                    if (minutes < 95) {
                        minutes += 5
                    } else {
                        minutes = 99
                    }
                } else {
                    // Вниз - убавляем 5 минут
                    if (minutes > 5) {
                        minutes -= 5
                    } else {
                        minutes = 0
                    }
                }
                // Обновляем отображение централизованно
                updateTimeDisplay()
                // Убеждаемся, что таймер остаётся в том же состоянии
                if (!running) {
                    countdownTimer.running = false
                }
            }
        }
    }
}