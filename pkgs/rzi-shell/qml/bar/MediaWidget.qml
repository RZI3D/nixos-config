import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    visible:        MprisController.currentPlayer !== null
    implicitWidth:  visible ? mediaRow.implicitWidth + 16 : 0
    implicitHeight: Theme.Catppuccin.barHeight

    Behavior on implicitWidth { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        radius:       Theme.Catppuccin.radiusSm
        color:        Theme.Catppuccin.surface0
        visible:      parent.visible

        RowLayout {
            id: mediaRow
            anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
            spacing: 6

            Text {
                text: MprisController.currentPlayer?.playbackState === MprisPlaybackState.Playing
                    ? "󰏤" : "󰐊"
                color:          Theme.Catppuccin.accent
                font.family:    Theme.Catppuccin.font
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: MprisController.currentPlayer?.togglePlaying()
                }
            }

            Item {
                Layout.fillWidth: true
                implicitHeight:   trackText.implicitHeight
                clip: true

                Text {
                    id: trackText
                    text: {
                        const p = MprisController.currentPlayer
                        if (!p) return ""
                        const t = p.trackTitle   || ""
                        const a = p.trackArtists?.join(", ") || ""
                        return a ? `${a} — ${t}` : t
                    }
                    color:          Theme.Catppuccin.fg
                    font.family:    Theme.Catppuccin.font
                    font.pixelSize: Theme.Catppuccin.fontSm
                    anchors.verticalCenter: parent.verticalCenter

                    property bool shouldScroll: implicitWidth > 160
                    x: 0
                    NumberAnimation on x {
                        running:  trackText.shouldScroll
                        loops:    Animation.Infinite
                        from:     0
                        to:       -(trackText.implicitWidth - 160)
                        duration: (trackText.implicitWidth - 160) * 30
                    }
                }
            }

            Text {
                text: "󰒮"
                color: Theme.Catppuccin.fgMuted; font.family: Theme.Catppuccin.font; font.pixelSize: 13
                MouseArea { anchors.fill: parent; onClicked: MprisController.currentPlayer?.previous() }
            }
            Text {
                text: "󰒭"
                color: Theme.Catppuccin.fgMuted; font.family: Theme.Catppuccin.font; font.pixelSize: 13
                MouseArea { anchors.fill: parent; onClicked: MprisController.currentPlayer?.next() }
            }
        }
    }
}
