import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

Popup {
    id: root
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(560, window.width - 48)
    height: Math.min(740, window.height - 48)
    modal: true
    focus: true
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    property bool editing: false
    property string draftName: store.profileName
    property string draftUsername: store.username
    property string draftBio: store.bio
    property string draftStatus: store.statusEmoji
    property string draftAvatar: store.avatarSource
    property string draftCover: store.coverSource
    property int draftGradient: store.gradientIndex
    property int draftCoverColor: store.coverColorIndex
    readonly property var gradients: [["#6578f6","#8b5cf6"],["#0ea5e9","#2563eb"],["#ec4899","#8b5cf6"],["#f97316","#ef4444"],["#10b981","#0d9488"],["#64748b","#334155"]]
    readonly property var covers: [["#243b75","#6578f6"],["#7c2d65","#ec4899"],["#075985","#0ea5e9"],["#14532d","#10b981"],["#7c2d12","#f97316"],["#334155","#64748b"]]
    Settings {
        id: store
        category: "profile"
        property string profileName: "Ваше имя"
        property string username: "username"
        property string bio: ""
        property string statusEmoji: ""
        property string avatarSource: ""
        property string coverSource: ""
        property int gradientIndex: 0
        property int coverColorIndex: 0
    }
    function beginEdit() {
        draftName=store.profileName; draftUsername=store.username; draftBio=store.bio
        draftStatus=store.statusEmoji; draftAvatar=store.avatarSource; draftCover=store.coverSource
        draftGradient=store.gradientIndex; draftCoverColor=store.coverColorIndex; editing=true
    }
    function saveProfile() {
        if (!draftName.trim().length || draftUsername.trim().replace("@","").length < 3) return
        store.profileName=draftName.trim(); store.username=draftUsername.trim().replace("@","")
        store.bio=draftBio.trim(); store.statusEmoji=draftStatus.trim()
        store.avatarSource=draftAvatar; store.coverSource=draftCover
        store.gradientIndex=draftGradient; store.coverColorIndex=draftCoverColor
        editing=false
    }
    background: Rectangle { radius: 24; color: "#111a28"; border.color: "#2a3850" }
    enter: Transition {
        NumberAnimation { property:"opacity"; from:0; to:1; duration:200 }
        NumberAnimation { property:"scale"; from:0.94; to:1; duration:220; easing.type:Easing.OutCubic }
    }
    exit: Transition { NumberAnimation { property:"opacity"; from:1; to:0; duration:140 } }
    FileDialog {
        id: avatarPicker
        title: "Выберите фото профиля"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.webp)"]
        onAccepted: root.draftAvatar=selectedFile.toString()
    }
    FileDialog {
        id: coverPicker
        title: "Выберите обложку профиля"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.webp *.gif)"]
        onAccepted: root.draftCover=selectedFile.toString()
    }
    ColumnLayout {
        anchors.fill: parent; spacing:0
        RowLayout {
            Layout.fillWidth:true; Layout.margins:18
            Text { text:root.editing?"Редактирование профиля":"Профиль"; color:"#f3f5fb"; font.pixelSize:21; font.bold:true }
            Item { Layout.fillWidth:true }
            Button {
                text:"✕"; onClicked:root.close()
                background:Rectangle { radius:18; color:"#202b3d" }
                contentItem:Text { text:parent.text; color:"#b4bfd1"; font.pixelSize:17; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter }
            }
        }
        Flickable {
            Layout.fillWidth:true; Layout.fillHeight:true; clip:true
            contentWidth:width; contentHeight:content.implicitHeight+24
            ColumnLayout {
                id:content; width:parent.width; spacing:14
                Item {
                    Layout.fillWidth:true; Layout.preferredHeight:250
                    Rectangle {
                        anchors.left:parent.left; anchors.right:parent.right; anchors.top:parent.top
                        height:174; radius:20
                        gradient:Gradient {
                            GradientStop { position:0; color:root.covers[root.draftCoverColor][0] }
                            GradientStop { position:1; color:root.covers[root.draftCoverColor][1] }
                        }
                        Image { anchors.fill:parent; source:root.draftCover; fillMode:Image.PreserveAspectCrop; visible:source.toString().length>0 }
                        Rectangle { anchors.fill:parent; radius:20; color:"#18071320" }
                        Button {
                            visible:root.editing; anchors.right:parent.right; anchors.top:parent.top; anchors.margins:12
                            text:"Обложка"; onClicked:coverPicker.open()
                            background:Rectangle { radius:16; color:"#aa1a2230"; border.color:"#ffffff55" }
                            contentItem:Text { text:parent.text; color:"white"; font.pixelSize:12; leftPadding:10; rightPadding:10; verticalAlignment:Text.AlignVCenter }
                        }
                    }
                    Rectangle {
                        x:(parent.width-112)/2; y:122; width:112; height:112; radius:56
                        color:"#111a28"; border.color:"#111a28"; border.width:5
                        Rectangle {
                            anchors.fill:parent; anchors.margins:5; radius:48
                            gradient:Gradient {
                                GradientStop { position:0; color:root.gradients[root.draftGradient][0] }
                                GradientStop { position:1; color:root.gradients[root.draftGradient][1] }
                            }
                            Image { anchors.fill:parent; source:root.draftAvatar; fillMode:Image.PreserveAspectCrop; visible:source.toString().length>0 }
                            Text {
                                anchors.centerIn:parent; visible:root.draftAvatar.length===0
                                text:root.draftName.length?root.draftName.trim().charAt(0).toUpperCase():"?"
                                color:"white"; font.pixelSize:42; font.bold:true
                            }
                        }
                        Button {
                            visible:root.editing; anchors.right:parent.right; anchors.bottom:parent.bottom
                            width:34; height:34; text:"✎"; onClicked:avatarPicker.open()
                            background:Rectangle { radius:17; color:"#4b83f5"; border.color:"#111a28"; border.width:3 }
                            contentItem:Text { text:parent.text; color:"white"; font.pixelSize:16; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter }
                        }
                    }
                    Column {
                        anchors.bottom:parent.bottom; anchors.horizontalCenter:parent.horizontalCenter; spacing:3
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:root.editing?root.draftName:store.profileName; color:"#f3f5fb"; font.pixelSize:22; font.bold:true }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"@"+(root.editing?root.draftUsername.replace("@",""):store.username); color:"#8f9db3"; font.pixelSize:13 }
                    }
                }
                Rectangle {
                    Layout.fillWidth:true; Layout.leftMargin:18; Layout.rightMargin:18
                    radius:17; color:"#1a2638"; border.color:"#2a3850"
                    implicitHeight:about.implicitHeight+28
                    ColumnLayout {
                        id:about; anchors.fill:parent; anchors.margins:14; spacing:10
                        Text { text:"ИНФОРМАЦИЯ"; color:"#8492aa"; font.pixelSize:11; font.bold:true; font.letterSpacing:1 }
                        Text { Layout.fillWidth:true; text:(root.editing?root.draftBio:store.bio)||"Расскажите немного о себе"; color:(root.editing?root.draftBio:store.bio).length?"#dce4f2":"#738198"; font.pixelSize:13; wrapMode:Text.WordWrap }
                        Text { text:"Статус  ·  "+((root.editing?root.draftStatus:store.statusEmoji)||"Не указан"); color:"#aebbd0"; font.pixelSize:12 }
                    }
                }
                ColumnLayout {
                    visible:root.editing; Layout.fillWidth:true; Layout.leftMargin:18; Layout.rightMargin:18; spacing:9
                    Text { text:"РЕДАКТИРОВАНИЕ"; color:"#8492aa"; font.pixelSize:11; font.bold:true; font.letterSpacing:1 }
                    TextField { Layout.fillWidth:true; text:root.draftName; placeholderText:"Имя"; onTextChanged:root.draftName=text; selectByMouse:true }
                    TextField { Layout.fillWidth:true; text:root.draftUsername; placeholderText:"Имя пользователя"; onTextChanged:root.draftUsername=text; selectByMouse:true }
                    TextArea { Layout.fillWidth:true; Layout.preferredHeight:82; text:root.draftBio; placeholderText:"О себе"; wrapMode:TextEdit.Wrap; onTextChanged:root.draftBio=text }
                    TextField { Layout.fillWidth:true; text:root.draftStatus; placeholderText:"Эмодзи-статус"; onTextChanged:root.draftStatus=text }
                    Text { text:"ГРАДИЕНТ АВАТАРА"; color:"#8492aa"; font.pixelSize:11; font.bold:true }
                    RowLayout {
                        spacing:10
                        Repeater {
                            model:root.gradients.length
                            delegate:Rectangle {
                                width:34; height:34; radius:17
                                gradient:Gradient { GradientStop { position:0; color:root.gradients[index][0] } GradientStop { position:1; color:root.gradients[index][1] } }
                                border.color:root.draftGradient===index?"white":"transparent"; border.width:3
                                MouseArea { anchors.fill:parent; onClicked:root.draftGradient=index }
                            }
                        }
                    }
                    Text { text:"ЦВЕТ ОБЛОЖКИ"; color:"#8492aa"; font.pixelSize:11; font.bold:true }
                    RowLayout {
                        spacing:10
                        Repeater {
                            model:root.covers.length
                            delegate:Rectangle {
                                width:34; height:34; radius:10
                                gradient:Gradient { GradientStop { position:0; color:root.covers[index][0] } GradientStop { position:1; color:root.covers[index][1] } }
                                border.color:root.draftCoverColor===index?"white":"transparent"; border.width:3
                                MouseArea { anchors.fill:parent; onClicked:root.draftCoverColor=index }
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth:true; Layout.leftMargin:18; Layout.rightMargin:18
                    radius:17; color:"#1a2638"; border.color:"#2a3850"
                    implicitHeight:account.implicitHeight+28
                    ColumnLayout {
                        id:account; anchors.fill:parent; anchors.margins:14; spacing:8
                        Text { text:"АККАУНТ"; color:"#8492aa"; font.pixelSize:11; font.bold:true; font.letterSpacing:1 }
                        RowLayout {
                            Layout.fillWidth:true
                            Text { text:"Статус"; color:"#8f9db3"; font.pixelSize:13 }
                            Item { Layout.fillWidth:true }
                            Text { text:"Локальный профиль"; color:"#dce4f2"; font.pixelSize:13 }
                        }
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth:true; Layout.margins:18; spacing:10
            Button {
                Layout.fillWidth:true; text:root.editing?"Сохранить изменения":"Редактировать профиль"
                onClicked:root.editing?root.saveProfile():root.beginEdit()
                background:Rectangle { radius:14; color:"#4b83f5" }
                contentItem:Text { text:parent.text; color:"white"; font.pixelSize:13; font.bold:true; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter }
            }
            Button {
                visible:root.editing; text:"Отмена"; onClicked:root.editing=false
                background:Rectangle { radius:14; color:"#263349" }
                contentItem:Text { text:parent.text; color:"#dce4f2"; font.pixelSize:13; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter; leftPadding:14; rightPadding:14 }
            }
        }
    }
}