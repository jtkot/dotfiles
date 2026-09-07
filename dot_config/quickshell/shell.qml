// qmllint disable uncreatable-type
// see issue #78

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    SystemClock {
        id: _clock
        precision: SystemClock.Seconds
    }

    Item {
        id: niri
        signal overviewToggled(isOpen: bool)

        Socket {
            connected: true
            path: Quickshell.env("NIRI_SOCKET")
            onConnectedChanged: {
                if (connected) {
                    write('"EventStream"\n');
                    flush();
                }
            }
            parser: SplitParser {
                onRead: message => {
                    var event = JSON.parse(message);
                    for (const key in JSON.parse(message)) {
                        switch (key) {
                        case "OverviewOpenedOrClosed":
                            niri.overviewToggled(event[key]?.is_open ?? false);
                            break;
                        }
                    }
                }
            }
        }
    }

    PanelWindow {
        WlrLayershell.layer: WlrLayer.Background
        exclusionMode: ExclusionMode.Ignore
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        Image {
            id: wallpaper
            anchors.fill: parent
            source: "wallpapers/tahoe.jpg"
            fillMode: Image.PreserveAspectCrop
        }
    }

    PanelWindow {
        anchors.top: true
        anchors.left: true
        anchors.right: true
        color: "transparent"
        implicitHeight: 128
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Bottom

        function toggleLayer(toTop: bool) {
            WlrLayershell.layer = toTop ? WlrLayer.Top : WlrLayer.Bottom;
        }

        Component.onCompleted: {
            niri.overviewToggled.connect(toggleLayer);
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.00
                    color: "#CC000000"
                }
                GradientStop {
                    position: 0.25
                    color: "#77000000"
                }
                GradientStop {
                    position: 0.50
                    color: "#33000000"
                }
                GradientStop {
                    position: 0.75
                    color: "#11000000"
                }
                GradientStop {
                    position: 1.00
                    color: "#00000000"
                }
            }
        }
    }

    PanelWindow {
        anchors.top: true
        anchors.left: true
        anchors.right: true
        color: "transparent"

        implicitHeight: mainLayout.childrenRect.height

        Column {
            id: mainLayout
            anchors.fill: parent

            Item {
                id: panel
                readonly property int verticalPadding: 8
                readonly property int horizontalPadding: 12

                height: childrenRect.height + 2 * verticalPadding
                anchors.left: parent.left
                anchors.right: parent.right
                Item {
                    height: 24

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: parent.horizontalPadding
                    anchors.rightMargin: parent.horizontalPadding
                    anchors.topMargin: parent.verticalPadding
                    anchors.bottomMargin: parent.verticalPadding

                    Row {
                        spacing: 10
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        Loader {
                            active: Quickshell.env("XDG_CURRENT_DESKTOP") == "Hyprland"
                            sourceComponent: Text {
                                id: current_ws
                                color: "#FFFFFF"
                                font.pointSize: 10
                                text: Hyprland.focusedWorkspace.id
                            }
                        }

                        Text {
                            id: panel_cur_win
                            color: "#FFFFFF"
                            font.pointSize: 10.5
                            font.bold: true
                            style: Text.Raised
                            text: {
                                const toplevel = ToplevelManager.activeToplevel;
                                if (!toplevel || !toplevel.appId)
                                    return "";
                                const entry = DesktopEntries.heuristicLookup?.(toplevel.appId);
                                return entry?.name ?? toplevel.appId;
                            }
                        }
                    }

                    Text {
                        id: panel_clock
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#FFFFFF"
                        font.pointSize: 10.5
                        style: Text.Raised
                        text: {
                            const str = _clock.date.toLocaleString(Qt.locale(), "ddd dd MMM hh:mm:ss");
                            return str.charAt(0).toUpperCase() + str.slice(1);
                        }
                    }
                }
            }
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
                WlrLayershell.layer: WlrLayer.Overlay
                exclusionMode: ExclusionMode.Ignore
                anchors.bottom: true
                margins.bottom: screen.height / 10
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
