import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import "../theme" as Theme

Item {
    implicitWidth:  trayRow.implicitWidth
    implicitHeight: Theme.Catppuccin.barHeight

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: SystemTray.items

            Item {
                required property SystemTrayItem modelData
                width: 22; height: 22

                Image {
                    anchors.centerIn: parent
                    source:   modelData.icon
                    width:    16; height: 16
                    smooth:   true
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton)
                            modelData.activate()
                        else
                            modelData.sendContextMenuRequest(mapToGlobal(0, 0))
                    }
                }
            }
        }
    }
}
