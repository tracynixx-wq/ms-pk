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
    color: "#0e1118"

    property string activeSection: "chats"

    Component.onCompleted: {
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 76
            Layout.fillHeight: true
            color: "#121722"

            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 22
                spacing: 14

                Rectangle {
                    width: 46
                    height: 46
                    radius: 15
                    color: "#6578f6"
                    Text {
                        anchors.centerIn: parent
                        text: "M"
                        color: "white"
                        font.pixelSize: 25
                        font.bold: true
                    }
                }

                Repeater {
                    model: [
                        { key: "chats", glyph: "◫", label: "Чаты" },
                        { key: "contacts", glyph: "♙", label: "Контакты" },
                        { key: "calls", glyph: "⌕", label: "Звонки" },
                        { key: "settings", glyph: "⚙", label: "Настройки" }
                    ]

                    delegate: Item {
                        width: 50
                        height: 54

                        Rectangle {
                            anchors.fill: parent
                            radius: 14
                            color: window.activeSection === modelData.key ? "#263252" : "transparent"
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.glyph
                                color: window.activeSection === modelData.key ? "#9eafff" : "#8993a7"
                                font.pixelSize: 22
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.label
                                color: window.activeSection === modelData.key ? "#cbd4ff" : "#8993a7"
                                font.pixelSize: 9
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: window.activeSection = modelData.key
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 20
                width: 42
                height: 42
                radius: 21
                color: "#283143"
                Text {
                    anchors.centerIn: parent
                    text: "П"
                    color: "#dce3f2"
                    font.pixelSize: 17
                    font.bold: true
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 330
            Layout.fillHeight: true
            color: "#171d29"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 18

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: window.activeSection === "chats" ? "Сообщения" :
                              window.activeSection === "contacts" ? "Контакты" :
                              window.activeSection === "calls" ? "Звонки" : "Настройки"
                        color: "#f2f4fa"
                        font.pixelSize: 23
                        font.bold: true
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "＋"
                        color: "#aebcff"
                        font.pixelSize: 25
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 42
                    radius: 12
                    color: "#222a39"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        spacing: 8
                        Text { text: "⌕"; color: "#8995aa"; font.pixelSize: 20 }
                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "Поиск"
                            color: "#eef1f8"
                            placeholderTextColor: "#7e899d"
                            background: null
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Column {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: window.activeSection === "chats" ? "Ваши чаты появятся здесь" : "Раздел готовится"
                        color: "#c6cede"
                        font.pixelSize: 15
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Подключение к существующему аккаунту будет добавлено следующим этапом"
                        color: "#7f8a9e"
                        font.pixelSize: 11
                        wrapMode: Text.WordWrap
                        width: parent.width - 12
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Item { Layout.fillHeight: true }
            }

            Rectangle {
                width: 1
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "#252d3b"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0e1118"

            Column {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    width: 76
                    height: 76
                    radius: 25
                    color: "#1d2740"
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        anchors.centerIn: parent
                        text: "M"
                        color: "#aebcff"
                        font.pixelSize: 40
                        font.bold: true
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Message Desktop"
                    color: "#eef1f8"
                    font.pixelSize: 22
                    font.bold: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Выберите чат, чтобы начать общение"
                    color: "#8994a8"
                    font.pixelSize: 14
                }
            }
        }
    }
}
