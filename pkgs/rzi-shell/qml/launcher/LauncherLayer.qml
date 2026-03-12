import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
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
        color: "transparent"

        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        // Click outside to dismiss
        MouseArea {
            anchors.fill: parent
            onClicked: open = false
        }

        Rectangle {
            id: panel
            width:  500
            height: 540
            anchors.centerIn: parent
            radius: Theme.Catppuccin.radius
            color:  Theme.Catppuccin.bg
            border.color: Theme.Catppuccin.accent
            border.width: 1

            scale:   open ? 1.0 : 0.92
            opacity: open ? 1.0 : 0.0
            Behavior on scale   { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 180 } }

            // Swallow clicks so background MouseArea doesn't catch them
            MouseArea { anchors.fill: parent }

            ColumnLayout {
                anchors { fill: parent; margins: 12 }
                spacing: 8

                // ── Search bar ──────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: Theme.Catppuccin.radiusSm
                    color:  Theme.Catppuccin.surface0

                    Row {
                        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                        spacing: 8

                        Text {
                            text:           "󰍉"
                            color:          Theme.Catppuccin.fgMuted
                            font.family:    Theme.Catppuccin.font
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        TextInput {
                            id: searchBox
                            width:           parent.width - 30
                            color:           Theme.Catppuccin.fg
                            font.family:     Theme.Catppuccin.font
                            font.pixelSize:  Theme.Catppuccin.fontMd
                            anchors.verticalCenter: parent.verticalCenter

                            onVisibleChanged: if (visible) { forceActiveFocus(); text = "" }
                            Keys.onEscapePressed: open = false
                            Keys.onReturnPressed: {
                                // launch first visible item
                                for (let i = 0; i < appList.count; i++) {
                                    const item = appList.itemAtIndex(i)
                                    if (item && item.visible) {
                                        item.triggerLaunch()
                                        break
                                    }
                                }
                            }
                        }
                    }
                }

                // ── App list ────────────────────────────────────────────
                ListView {
                    id: appList
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    clip:    true
                    spacing: 2
                    model:   DesktopEntries.applications

                    delegate: Rectangle {
                        id: appItem
                        required property DesktopEntry modelData
                        required property int index

                        width:   ListView.view.width
                        height:  visible ? 46 : 0
                        visible: modelData.name.toLowerCase().includes(searchBox.text.toLowerCase())
                        radius:  Theme.Catppuccin.radiusSm
                        color:   hov ? Theme.Catppuccin.surface0 : "transparent"

                        property bool hov: false
                        Behavior on color { ColorAnimation { duration: 80 } }

                        function triggerLaunch() {
                            appItem.modelData.execute()
                            open = false
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: appItem.hov = true
                            onExited:  appItem.hov = false
                            onClicked: appItem.triggerLaunch()
                        }

                        RowLayout {
                            anchors { fill: parent; margins: 8 }
                            spacing: 10

                            IconImage {
                                source: appItem.modelData.icon !== "" ? "image://icon/" + appItem.modelData.icon : ""
                                visible: appItem.modelData.icon !== ""
                                width:    28; height: 28
                                smooth:   true
                                
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 1

                                Text {
                                    text:           appItem.modelData.name
                                    color:          Theme.Catppuccin.fg
                                    font.family:    Theme.Catppuccin.font
                                    font.pixelSize: Theme.Catppuccin.fontMd
                                    elide:          Text.ElideRight
                                    width:          parent.width
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
