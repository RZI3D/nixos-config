import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    implicitWidth:  wsRow.implicitWidth
    implicitHeight: Theme.Catppuccin.barHeight

    HyprlandConnection { id: hypr }

    Row {
        id: wsRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: hypr.workspaces

            Rectangle {
                required property var modelData

                width:  modelData.id === hypr.focusedWorkspace?.id ? 28 : 18
                height: 18
                radius: 9

                color: modelData.id === hypr.focusedWorkspace?.id
                    ? Theme.Catppuccin.accent
                    : modelData.windows > 0
                        ? Theme.Catppuccin.surface1
                        : Theme.Catppuccin.surface0

                Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation  { duration: 120 } }

                MouseArea {
                    anchors.fill: parent
                    onClicked: hypr.dispatch("workspace " + modelData.id)
                }
            }
        }
    }
}
