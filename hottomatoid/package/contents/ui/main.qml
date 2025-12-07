import QtQuick 2.15
import QtQuick.Window 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property int minutes: 35
    property int seconds: 0
    property bool running: false
    property string displayTime: formatTime(minutes, seconds)

    Plasmoid.title: "HotTomatoid"

    // Устанавливаем текст напрямую в заголовок плазмоида
    Plasmoid.toolTipMainText: "🕓" + displayTime
    Plasmoid.toolTipSubText: "Click to start/stop • A wheel to change the time"

    // Делаем так, чтобы плазмоид показывал текст на панели
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    // Разрешаем изменять размер
    Plasmoid.backgroundHints: PlasmaCore.Types.ConfigurableBackground

    
    function formatTime(mins, secs) {
        return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0')
    }

    // Инициализация при создании
    Component.onCompleted: {
        updateTimeDisplay()
        console.log("HotTomatoid initialized with time:", displayTime)
    }

    function resetMainTimer() {
        minutes = 25
        seconds = 0
        updateTimeDisplay()
    }

    function updateTimeDisplay() {
        displayTime = formatTime(minutes, seconds)
        Plasmoid.toolTipMainText = "🕓" + displayTime

        // Проверяем существование элементов перед обновлением
        try {
            // Обновляем текст в компактном представлении
            if (compactText && typeof compactText.text !== "undefined") {
                compactText.text = "🕓" + displayTime
            }
        } catch (e) {
            // Игнорируем ошибки если компонент еще не создан
        }

        try {
            // Обновляем текст в полном представлении
            if (fullText && typeof fullText.text !== "undefined") {
                fullText.text = "🕓" + displayTime
            }
        } catch (e) {
            // Игнорируем ошибки если компонент еще не создан
        }
    }

    // Обновляем отображение при изменении времени
    onMinutesChanged: updateTimeDisplay()
    onSecondsChanged: updateTimeDisplay()
    onRunningChanged: {
        if (running && minutes === 0 && seconds === 0) {
            // Если запускаем с нулевого времени, устанавливаем значения по умолчанию
            minutes = 35
            seconds = 0
        }
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
    Plasmoid.compactRepresentation: Item {
        id: compactItem
        //implicitHeight: 16
        //implicitWidth: 14

        Text {
            id: compactText
            text: "🕓" + displayTime
            font.pixelSize: 16
            font.bold: true
            color: PlasmaCore.Theme.textColor

            // Подстраиваем размер под доступное пространство
            fontSizeMode: Text.Fit
            minimumPixelSize: 2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // Занимаем почти всё доступное пространство с минимальными отступами
            anchors.fill: parent
            anchors.margins: 1
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    running = !running
                    if (running) {
                        // Если запускаем таймер, проверяем что время не нулевое
                        if (minutes === 0 && seconds === 0) {
                            minutes = 35
                            seconds = 0
                        }
                    }
                    countdownTimer.running = running
                    console.log("Compact timer clicked, running:", running, "time:", displayTime)
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
                font.pixelSize: 14
                font.bold: true
                color: PlasmaCore.Theme.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            //Text {
            //   text: running ? "🛑" : "✅"
            //    font.pixelSize: 14
            //    color: PlasmaCore.Theme.textColor
            //    anchors.horizontalCenter: parent.horizontalCenter
            //}
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    running = !running
                    if (running) {
                        // Если запускаем таймер, проверяем что время не нулевое
                        if (minutes === 0 && seconds === 0) {
                            minutes = 35
                            seconds = 0
                        }
                    }
                    countdownTimer.running = running
                    console.log("Full timer clicked, running:", running, "time:", displayTime)
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
                running: false
                repeat: true
                onTriggered: {
                    if (breakSeconds === 0) {
                        if (breakMinutes === 0) {
                            // DEBUG console.log("Break timer finished, closing window")
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

            function resetBreakTimer() {
                breakMinutes = 5
                breakSeconds = 0
                timeText.text = "🕓" + formatTime(breakMinutes, breakSeconds)
            }

            Rectangle {
                anchors.fill: parent
                //color: Qt.rgba(14, 111, 238, 0.73)
                color: "#3a455a"

                Column {
                    anchors.centerIn: parent
                    spacing: 50

                    Text {
                        text: "Go to RelaX!"
                        font.pixelSize: 80
                        font.bold: true
                        color: "#c26d29"
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
                        text: breakTimer.running ? "Pause (click)" : "Continue (click)"
                        font.pixelSize: 30
                        color: PlasmaCore.Theme.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Mouse wheel to change the time"
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

            onVisibleChanged: {
                if (visible) {
                    console.log("BreakWindow shown")
                    resetBreakTimer()
                    breakTimer.running = true
                    // Сбрасываем флаг при показе окна
                    if (root) root.breakWindowClosing = false
                }
            }

            onClosing: {
                console.log("BreakWindow closing")
                // Запускаем основной таймер только при закрытии
                if (root) {
                    root.startAfterBreak()
                }
            }
        }
    }

    property var breakWindow: null
    property bool breakWindowClosing: false

    function showBreakWindow() {
        if (!breakWindow) {
            breakWindow = breakWindowComponent.createObject(root)
        }
        breakWindowClosing = false
        breakWindow.show()
    }

    function startAfterBreak() {
        // Защита от множественных вызовов
        if (breakWindowClosing) {
            console.log("startAfterBreak already called, skipping")
            return
        }
        breakWindowClosing = true

        console.log("startAfterBreak called")
        minutes = 35
        seconds = 0

        // Небольшая задержка перед обновлением UI
        Qt.callLater(() => {
            updateTimeDisplay()
            // Запускаем таймер
            running = true
            countdownTimer.running = true
            console.log("Main timer started after break, time:", displayTime)
        })
    }
}