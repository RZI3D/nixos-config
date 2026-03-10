import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            screen:        modelData
            anchors { top: true; left: true; right: true }
            exclusionMode: ExclusionMode.Exclusive
            height:        Theme.Catppuccin.barHeight
            color:         "transparent"

            WlrLayershell.namespace: "quickshell:bar"

            Rectangle {
                anchors.fill: parent
                color:        Theme.Catppuccin.bgFloat

                RowLayout {
                    anchors { fill: parent; margins: Theme.Catppuccin.spacing }
                    spacing: Theme.Catppuccin.spacing

                    Workspaces  { Layout.alignment: Qt.AlignVCenter }

                    Item        { Layout.fillWidth: true }
                    MediaWidget { Layout.alignment: Qt.AlignVCenter }
                    Item        { Layout.fillWidth: true }

                    SysTray     { Layout.alignment: Qt.AlignVCenter }
                    Clock       { Layout.alignment: Qt.AlignVCenter }
                }
            }
        }
    }
}
