import Quickshell
import QtQuick
import "../theme" as Theme

Item {
    implicitWidth:  timeLabel.implicitWidth + dateLabel.implicitWidth + 8
    implicitHeight: Theme.Catppuccin.barHeight

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            id:             dateLabel
            text:           Qt.formatDate(new Date(), "ddd dd MMM")
            color:          Theme.Catppuccin.fgMuted
            font.family:    Theme.Catppuccin.font
            font.pixelSize: Theme.Catppuccin.fontSm
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id:             timeLabel
            text:           clock.hours.toString().padStart(2, '0') + ":" + clock.minutes.toString().padStart(2, '0')
            color:          Theme.Catppuccin.fg
            font.family:    Theme.Catppuccin.font
            font.pixelSize: Theme.Catppuccin.fontMd
            font.bold:      true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
