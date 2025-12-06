import QtQuick 2.15
import QtQuick.Window 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property int minutes: 35
    property int seconds: 1
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
                    // Показываем окно отдыха
                    showBreakWindow()
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

    // Компонент окна для отдыха
    Component {
        id: breakWindowComponent

        Window {
            id: breakWindow

            property int breakMinutes: 5
            property int breakSeconds: 0

            title: "Time to Relax!"
            visibility: Window.FullScreen
            width: 800
            height: 600
            color: PlasmaCore.Theme.backgroundColor
            flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

            Timer {
                id: breakTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    if (breakSeconds === 0) {
                        if (breakMinutes === 0) {
                            breakWindow.close()
                            return
                        }
                        breakMinutes--
                        breakSeconds = 59
                    } else {
                        breakSeconds--
                    }
                    timeText.text = "🕓" + formatTime(breakMinutes, breakSeconds)
                }
            }

            function formatTime(mins, secs) {
                return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(235, 145, 10, 0.8)

                Column {
                    anchors.centerIn: parent
                    spacing: 50

                    Text {
                        text: "Go to RelaX!"
                        font.pixelSize: 80
                        font.bold: true
                        color: "#e6e2daff"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: timeText
                        text: "🕓" + formatTime(breakMinutes, breakSeconds)
                        font.pixelSize: 120
                        font.bold: true
                        color: PlasmaCore.Theme.textColor
                        anchors.horizontalCenter: parent.horizontalCenter

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            onClicked: {
                                breakTimer.running = !breakTimer.running
                            }
                            onWheel: {
                                wheel.accepted = true
                                breakSeconds = 0
                                if (wheel.angleDelta.y > 0) {
                                    if (breakMinutes < 99) breakMinutes++
                                } else {
                                    if (breakMinutes > 0) breakMinutes--
                                }
                                timeText.text = "🕓" + formatTime(breakMinutes, breakSeconds)
                            }
                        }
                    }

                    Text {
                        text: breakTimer.running ? "Пауза (клик)" : "Продолжить (клик)"
                        font.pixelSize: 30
                        color: PlasmaCore.Theme.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Колёсико мыши для изменения времени"
                        font.pixelSize: 20
                        color: PlasmaCore.Theme.disabledTextColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Text {
                    text: "✕"
                    font.pixelSize: 30
                    color: PlasmaCore.Theme.textColor
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 20

                    MouseArea {
                        anchors.fill: parent
                        onClicked: breakWindow.close()
                    }
                }
            }

            onClosing: {
                root.minutes = 25
                root.seconds = 0
                root.running = false
                root.countdownTimer.running = false
                root.updateTimeDisplay()
            }
        }
    }

    property var breakWindow: null

    function showBreakWindow() {
        if (!breakWindow) {
            breakWindow = breakWindowComponent.createObject(root)
        }
        breakWindow.show()
    }
}