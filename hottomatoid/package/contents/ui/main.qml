import QtQuick 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property int minutes: 45
    property int seconds: 0
    property bool running: false

    Plasmoid.title: "HotTomatoid"

    // Устанавливаем текст напрямую в заголовок плазмоида
    Plasmoid.toolTipMainText: "🕓" + formatTime(minutes, seconds)
    Plasmoid.toolTipSubText: "Клик для запуска/остановки таймера"

    // Делаем так, чтобы плазмоид показывал текст на панели
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    function formatTime(mins, secs) {
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
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
            // Обновляем подсказку при каждом тике
            Plasmoid.toolTipMainText = "🕓" + formatTime(minutes, seconds)
        }
    }

    // Простое компактное представление
    Plasmoid.compactRepresentation: Text {
        text: "🕓" + formatTime(minutes, seconds)
        font.pixelSize: 14
        font.bold: true
        color: PlasmaCore.Theme.textColor

        MouseArea {
            anchors.fill: parent
            onClicked: {
                running = !running
                countdownTimer.running = running
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
                text: "🕓" + formatTime(minutes, seconds)
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
            onClicked: {
                running = !running
                countdownTimer.running = running
            }
        }
    }
}