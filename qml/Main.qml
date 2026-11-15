import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 1280
    height: 820
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: "Message"
    color: "#0d1119"

    property string activeSection: "chats"
    property string searchText: ""
    property bool compactMode: false

    function sectionTitle(key) {
        if (key === "chats") return "Сообщения"
        if (key === "contacts") return "Контакты"
        if (key === "calls") return "Звонки"
        return "Настройки"
    }

    Component.onCompleted: {
        x = Math.max(0, (Screen.width - width) / 2)
        y = Math.max(0, (Screen.height - height) / 2)
        updateService.checkForUpdates()
    }

    Drawer {
        id: navigationDrawer
        width: 286
        height: window.height
        edge: Qt.LeftEdge
        modal: true
        background: Rectangle { color: "#171e2b" }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Rectangle {
                    width: 42; height: 42; radius: 14
                    color: "#6578f6"
                    Text { anchors.centerIn: parent; text: "M"; color: "white"; font.pixelSize: 23; font.bold: true }
                }
                ColumnLayout {
                    spacing: 1
                    Text { text: "Message"; color: "#f3f5fb"; font.pixelSize: 18; font.bold: true }
                    Text { text: "Навигация"; color: "#8490a5"; font.pixelSize: 11 }
                }
                Item { Layout.fillWidth: true }
                ToolButton { text: "✕"; onClicked: navigationDrawer.close() }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#293244" }

            Repeater {
                model: [
                    { key: "chats", glyph: "▤", label: "Чаты" },
                    { key: "contacts", glyph: "♙", label: "Контакты" },
                    { key: "calls", glyph: "⌕", label: "Звонки" },
                    { key: "settings", glyph: "⚙", label: "Настройки" }
                ]
                delegate: Button {
                    Layout.fillWidth: true
                    implicitHeight: 52
                    text: modelData.glyph + "    " + modelData.label
                    highlighted: window.activeSection === modelData.key
                    onClicked: {
                        window.activeSection = modelData.key
                        navigationDrawer.close()
                    }
                    background: Rectangle {
                        radius: 12
                        color: parent.highlighted ? "#293653" : (parent.hovered ? "#222c3d" : "transparent")
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    contentItem: Text {
                        text: parent.text
                        color: parent.highlighted ? "#dce3ff" : "#b4bfd1"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 14
                    }
                }
            }

            Item { Layout.fillHeight: true }
            Text {
                Layout.fillWidth: true
                text: "Message Desktop • ранняя версия"
                color: "#68758a"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    ProfileView { id: profilePopup }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 72
            Layout.fillHeight: true
            color: "#121925"

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 18
                anchors.bottomMargin: 16
                spacing: 12

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 44; height: 44; radius: 14
                    color: "#6578f6"
                    Text { anchors.centerIn: parent; text: "M"; color: "white"; font.pixelSize: 24; font.bold: true }
                }

                ToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    width: 48; height: 48
                    text: "☰"
                    font.pixelSize: 22
                    onClicked: navigationDrawer.open()
                    ToolTip.visible: hovered
                    ToolTip.text: "Открыть разделы"
                }

                Item { Layout.fillHeight: true }

                ToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    width: 48; height: 48
                    text: "●"
                    font.pixelSize: 23
                    onClicked: profilePopup.open()
                    ToolTip.visible: hovered
                    ToolTip.text: "Профиль"
                    background: Rectangle { radius: 24; color: parent.hovered ? "#293653" : "#202b3d" }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 340
            Layout.fillHeight: true
            color: "#171e2b"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: window.compactMode ? 14 : 20
                spacing: window.compactMode ? 12 : 18

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: window.sectionTitle(window.activeSection); color: "#f1f3f9"; font.pixelSize: 23; font.bold: true }
                    Item { Layout.fillWidth: true }
                    ToolButton {
                        text: "＋"
                        font.pixelSize: 24
                        onClicked: {
                            if (window.activeSection === "chats") navigationDrawer.open()
                            else if (window.activeSection === "settings") profilePopup.open()
                            else navigationDrawer.open()
                        }
                        ToolTip.visible: hovered
                        ToolTip.text: "Действия раздела"
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: 12
                    color: "#222c3d"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 10
                        spacing: 8
                        Text { text: "⌕"; color: "#8996ab"; font.pixelSize: 21 }
                        TextField {
                            id: searchField
                            Layout.fillWidth: true
                            placeholderText: "Поиск"
                            color: "#eef1f8"
                            placeholderTextColor: "#7f8ba0"
                            background: null
                            onTextChanged: window.searchText = text
                        }
                        ToolButton { text: "✕"; visible: searchField.text.length > 0; onClicked: searchField.clear() }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: window.activeSection !== "settings"

                    Column {
                        anchors.centerIn: parent
                        width: parent.width - 20
                        spacing: 10
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: window.searchText.length > 0 ? "Ничего не найдено" :
                                  window.activeSection === "chats" ? "Пока нет чатов" :
                                  window.activeSection === "contacts" ? "Контактов пока нет" : "История звонков пуста"
                            color: "#d2d9e6"
                            font.pixelSize: 15
                            font.bold: true
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            text: window.searchText.length > 0 ? "Поиск заработает после подключения аккаунта." :
                                  "Здесь появятся данные вашего аккаунта после подключения к серверу."
                            color: "#7f8ba0"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: window.activeSection === "settings"
                    contentHeight: settingsColumn.implicitHeight
                    clip: true
                    ColumnLayout {
                        id: settingsColumn
                        width: parent.width
                        spacing: 12

                        Label { text: "Внешний вид"; color: "#9ba8bc"; font.pixelSize: 12 }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 66
                            radius: 12
                            color: "#222c3d"
                            RowLayout {
                                anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 12
                                ColumnLayout {
                                    spacing: 3
                                    Label { text: "Компактный режим"; color: "#e1e6ef" }
                                    Label { text: "Уменьшенные отступы интерфейса"; color: "#8491a6"; font.pixelSize: 10 }
                                }
                                Item { Layout.fillWidth: true }
                                Switch { checked: window.compactMode; onToggled: window.compactMode = checked }
                            }
                        }
                        Label { text: "Аккаунт"; color: "#9ba8bc"; font.pixelSize: 12; topPadding: 8 }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 74
                            radius: 12
                            color: "#222c3d"
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 14
                                spacing: 5
                                Label { text: "Подключение не настроено"; color: "#e1e6ef" }
                                Label { text: "Авторизация появится после интеграции backend"; color: "#8491a6"; font.pixelSize: 10 }
                            }
                        }
                        Label { text: "Приложение"; color: "#9ba8bc"; font.pixelSize: 12; topPadding: 8 }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 60
                            radius: 12
                            color: "#222c3d"
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 14
                                spacing: 4
                                Label { text: "Message Desktop"; color: "#e1e6ef" }
                                Label { text: "Версия 0.3.0 • Native Qt"; color: "#8491a6"; font.pixelSize: 10 }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            radius: 12
                            color: "#222c3d"
                            implicitHeight: updateColumn.implicitHeight + 24
                            ColumnLayout {
                                id: updateColumn
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8
                                Label { text: "Обновления"; color: "#e1e6ef"; font.bold: true }
                                Label {
                                    Layout.fillWidth: true
                                    text: updateService.status
                                    color: "#8491a6"
                                    font.pixelSize: 10
                                    wrapMode: Text.WordWrap
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Button {
                                        text: "Проверить"
                                        onClicked: updateService.checkForUpdates()
                                    }
                                    Button {
                                        visible: updateService.updateAvailable
                                        text: "Установить"
                                        onClicked: updateService.downloadAndInstall()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { width: 1; anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom; color: "#293244" }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0d1119"

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width - 60, 440)
                spacing: 14

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 82; height: 82; radius: 26
                    color: "#202b45"
                    Text { anchors.centerIn: parent; text: "M"; color: "#b6c3ff"; font.pixelSize: 43; font.bold: true }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Message Desktop"
                    color: "#f0f3fa"
                    font.pixelSize: 25
                    font.bold: true
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    text: window.activeSection === "chats" ? "Выберите чат, чтобы начать общение" :
                          window.activeSection === "contacts" ? "Ваши контакты будут отображаться здесь" :
                          window.activeSection === "calls" ? "Здесь появится история звонков" :
                          "Настройте внешний вид приложения"
                    color: "#8e9aaf"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    text: "Это нативная основа приложения. Реальные сообщения, авторизация и звонки требуют подключения серверной части."
                    color: "#657187"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
