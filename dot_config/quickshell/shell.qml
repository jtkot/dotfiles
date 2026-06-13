// qmllint disable uncreatable-type
// see issue #78

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Background
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "#000000"
        Image {
            id: wallpaper
            anchors.fill: parent
            source: "wallpapers/tahoe.jpg"
            fillMode: Image.PreserveAspectCrop
        }
    }

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 32
        color: "#000000"

        SystemClock {
            id: _clock
            precision: SystemClock.Seconds
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            padding: 12
            spacing: 10
            Text {
                id: current_ws
                color: "#FFFFFF"
                font.pointSize: 10
                text: Hyprland.focusedWorkspace?.id ?? "-"
            }

            Text {
                id: current_win
                color: "#AAAAAA"
                font.pointSize: 10
                text: ToplevelManager.activeToplevel?.title ?? ""
            }
        }

        Text {
            id: clock
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            padding: 12
            color: "#FFFFFF"
            font.pointSize: 10
            text: Qt.formatDateTime(_clock.date, "ddd dd MMM hh:mm:ss")
        }
    }

    Scope {
        id: volume_osd

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }

        Connections {
            target: Pipewire.defaultAudioSink?.audio

            function onVolumeChanged() {
                volume_osd.shouldShowOsd = true;
                hideTimer.restart();
            }
        }

        property bool shouldShowOsd: false

        Timer {
            id: hideTimer
            interval: 1000
            onTriggered: volume_osd.shouldShowOsd = false
        }

        LazyLoader {
            active: volume_osd.shouldShowOsd

            PanelWindow {
                anchors.bottom: true
                margins.bottom: screen.height / 10
                exclusiveZone: 0
                implicitWidth: 400
                implicitHeight: 50
                color: "transparent"
                mask: Region {}

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: "#80000000"

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 10
                            rightMargin: 15
                        }
						spacing: 8
                        Item {
							Layout.leftMargin: 4
							Layout.rightMargin: 4
                            implicitHeight: 24
                            implicitWidth: 24
                            IconImage {
                                id: volume_icon
                                anchors.fill: parent
                                source: Quickshell.iconPath("audio-volume-high-symbolic")
                                visible: false
                            }
                            MultiEffect {
                                anchors.fill: volume_icon
                                source: volume_icon
                                brightness: 1
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 10
                            radius: 20
                            color: "#50ffffff"

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }

                                implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                                radius: parent.radius
                            }
                        }
                    }
                }
            }
        }
    }
}
