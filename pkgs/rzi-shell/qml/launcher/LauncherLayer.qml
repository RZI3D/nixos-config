import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Applications
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Scope {
    property bool open: false

    IpcHandler {
        target: "launcher"
        function toggleLauncher() { open = !open }
    }

    PanelWindow {
        visible: open
        anchors { top: true; bottom: true; left: true; right: true }
        color:   "transparent"

        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        MouseArea {
            anchors.fill: parent
            onClicked: open = false
        }

        Rectangle {
            width: 500; height: 540
            anchors.centerIn: parent
            radius: Theme.Catppuccin.radius
            color:  Theme.Catppuccin.bg
            border.color: Theme.Catppuccin.accent; border.width: 1

            MouseArea { anchors.fill: parent } // swallow clicks

            scale:   open ? 1.0 : 0.92
            opacity: open ? 1.0 : 0.0
            Behavior on scale   { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 180 } }

            ColumnLayout {
                anchors { fill: parent; margins: 12 }
                spacing: 8

                // Search bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 40; radius: Theme.Catppuccin.radiusSm
                    color:  Theme.Catppuccin.surface0

                    Row {
                        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                        spacing: 8

                        Text {
                            text: "󰍉"; color: Theme.Catppuccin.fgMuted
                            font.family: Theme.Catppuccin.font; font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        TextInput {
                            id: searchBox
                            width: parent.width - 30
                            color: Theme.Catppuccin.fg
                            font.family: Theme.Catppuccin.font; font.pixelSize: Theme.Catppuccin.fontMd
                            anchors.verticalCenter: parent.verticalCenter
                            onVisibleChanged: if (visible) { forceActiveFocus(); text = "" }
                            Keys.onEscapePressed: open = false
                            Keys.onReturnPressed: {
                                if (appList.count > 0) {
                                    appList.itemAtIndex(0)?.launch()
                                    open = false
                                }
                            }
                        }
                    }
                }

                // App list
                ListView {
                    id: appList
                    Layout.fillWidth: true; Layout.fillHeight: true
                    clip: true; spacing: 2

                    model: Applications.applications.filter(
                        app => app.name.toLowerCase().includes(searchBox.text.toLowerCase())
                    )

                    delegate: Rectangle {
                        id: appItem
                        required property var modelData
                        width: ListView.view.width; height: 46
                        radius: Theme.Catppuccin.radiusSm
                        color:  hov ? Theme.Catppuccin.surface0 : "transparent"
                        property bool hov: false
                        Behavior on color { ColorAnimation { duration: 80 } }

                        function launch() { modelData.launch(); open = false }

                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onEntered: appItem.hov = true
                            onExited:  appItem.hov = false
                            onClicked: appItem.launch()
                        }

                        RowLayout {
                            anchors { fill: parent; margins: 8 }
                            spacing: 10

                            Image {
                                source:   "image://icon/" + (modelData.iconName || "application-x-executable")
                                width: 28; height: 28; smooth: true; fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Column {
                                Layout.fillWidth: true; spacing: 1
                                Text {
                                    text: modelData.name; color: Theme.Catppuccin.fg
                                    font.family: Theme.Catppuccin.font; font.pixelSize: Theme.Catppuccin.fontMd
                                }
                                Text {
                                    visible: modelData.description !== ""
                                    text:    modelData.description || ""
                                    color:   Theme.Catppuccin.fgMuted
                                    font.family: Theme.Catppuccin.font; font.pixelSize: Theme.Catppuccin.fontSm
                                    elide: Text.ElideRight; width: parent.width
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
