import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../theme" as Theme

Item {
    implicitWidth:  wsRow.implicitWidth
    implicitHeight: Theme.Catppuccin.barHeight
    Rectangle {
        // For the box around the actual thing
        anchors.centerIn: parent
        height: Theme.Catppuccin.barHeight -10
        width: parent.width + 10
        color: Theme.Catppuccin.surface1
        radius: 9

        Row {
            id: wsRow
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    required property var modelData
                    anchors.verticalCenter: parent.verticalCenter
                    width:  modelData.id === Hyprland.focusedWorkspace?.id ? 24 : 20
                    height:  modelData.id === Hyprland.focusedWorkspace?.id ? 18 : 16
                    radius:  modelData.id === Hyprland.focusedWorkspace?.id ? 4 : 6

                    color: modelData.id === Hyprland.focusedWorkspace?.id
                        ? Theme.Catppuccin.accent
                        : modelData.windows > 0
                            ? Theme.Catppuccin.surface2
                            : Theme.Catppuccin.surface2

                    Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation  { duration: 220; easing.type: Easing.OutCubic } }
                    Behavior on radius { ColorAnimation  { duration: 220; easing.type: Easing.OutCubic } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }
                }
            }
        }
    }
}
