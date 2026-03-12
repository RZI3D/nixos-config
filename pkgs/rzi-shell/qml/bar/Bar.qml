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
            implicitHeight: Theme.Catppuccin.barHeight
            color:         "transparent"
            margins { top: 6; left: 6; right: 6 }
            
            WlrLayershell.namespace: "quickshell:bar"

            Rectangle {
                anchors.fill: parent
                color:        Theme.Catppuccin.bgFloat
                radius:       Theme.Catppuccin.radius
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
