import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: root
    visible: true
    width: 520
    height: 360
    minimumWidth: 420
    minimumHeight: 320
    title: "手写日记 OCR"
    flags: Qt.FramelessWindowHint | Qt.Window

    // 渐变背景
    Rectangle {
        anchors.fill: parent
        radius: 10

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a2e" }
            GradientStop { position: 1.0; color: "#16213e" }
        }

        // 自定义标题栏
        Rectangle {
            id: titleBar
            width: parent.width
            height: 40
            color: "#12122a"
            radius: 10

            // 补掉下半圆角（只有顶部是圆角）
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.radius
                color: parent.color
            }

            // 拖动窗口
            MouseArea {
                anchors.fill: parent
                property point clickPos
                onPressed: clickPos = Qt.point(mouse.x, mouse.y)
                onPositionChanged: {
                    root.x += mouse.x - clickPos.x
                    root.y += mouse.y - clickPos.y
                }
            }

            // 标题文字
            Text {
                anchors.centerIn: parent
                text: "手写日记 OCR"
                color: "#8090a8"
                font.pixelSize: 13
            }

            // 窗口控制按钮（最小化 / 最大化 / 关闭）
            Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // 最小化（黄色，－）
                Rectangle {
                    width: 14; height: 14; radius: 7
                    color: minBtn.containsMouse ? "#f0c040" : "#a08030"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    Text {
                        anchors.centerIn: parent
                        text: "－"
                        color: minBtn.containsMouse ? "#5a3a00" : "transparent"
                        font.pixelSize: 9
                        font.bold: true
                    }
                    MouseArea {
                        id: minBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.showMinimized()
                    }
                }

                // 最大化/还原（绿色，＋ / ⤡）
                Rectangle {
                    width: 14; height: 14; radius: 7
                    color: maxBtn.containsMouse ? "#40c060" : "#207040"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    Text {
                        anchors.centerIn: parent
                        text: root.visibility === Window.Maximized ? "⤡" : "＋"
                        color: maxBtn.containsMouse ? "#003a10" : "transparent"
                        font.pixelSize: root.visibility === Window.Maximized ? 8 : 9
                        font.bold: true
                    }
                    MouseArea {
                        id: maxBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (root.visibility === Window.Maximized)
                                root.showNormal()
                            else
                                root.showMaximized()
                        }
                    }
                }

                // 关闭（红色，×）
                Rectangle {
                    width: 14; height: 14; radius: 7
                    color: closeBtn.containsMouse ? "#ff6060" : "#a03030"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: closeBtn.containsMouse ? "#5a0000" : "transparent"
                        font.pixelSize: 11
                        font.bold: true
                    }
                    MouseArea {
                        id: closeBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.quit()
                    }
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 40   // 标题栏高度
            anchors.leftMargin: 28
            anchors.rightMargin: 28
            anchors.bottomMargin: 28
            spacing: 20

            // 标题区域
            ColumnLayout {
                spacing: 4

                Text {
                    text: "手写日记 OCR"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#e0e0e0"
                }

                Text {
                    text: "选择包含日记图片的文件夹，一键识别手写内容"
                    font.pixelSize: 12
                    color: "#7f8c9a"
                }
            }

            // 分隔线
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#2a3a5a"
            }

            // 路径输入 + 选择按钮
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 42
                    radius: 8
                    color: "#0f3460"
                    border.color: filePathInput.activeFocus ? "#4a90d9" : "#2a3a5a"
                    border.width: 1

                    TextInput {
                        id: filePathInput
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#c0cfe0"
                        font.pixelSize: 13
                        clip: true
                        text: backend.file_path

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            text: "请选择文件夹..."
                            color: "#4a5a6a"
                            font.pixelSize: 13
                            visible: !filePathInput.text
                        }

                        Connections {
                            target: backend
                            onFile_path_changed: {
                                filePathInput.text = backend.file_path
                            }
                        }
                    }
                }

                // 选择文件夹按钮
                Rectangle {
                    width: 110
                    height: 42
                    radius: 8
                    color: openBtn.pressed ? "#2a6fad" : (openBtn.containsMouse ? "#3a85c7" : "#2a75b8")

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "选择文件夹"
                        color: "white"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    MouseArea {
                        id: openBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: backend.open_file_dialog()
                    }
                }
            }

            // 开始识别按钮
            Rectangle {
                Layout.fillWidth: true
                height: 46
                radius: 8

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: transferBtn.pressed ? "#1a6e55" : (transferBtn.containsMouse ? "#1e8a6a" : "#1a7a5e") }
                    GradientStop { position: 1.0; color: transferBtn.pressed ? "#1a5e7a" : (transferBtn.containsMouse ? "#1e7a9a" : "#1a6e8a") }
                }

                Behavior on gradient { ColorAnimation { duration: 120 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "▶"
                        color: "white"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "开始识别"
                        color: "white"
                        font.pixelSize: 15
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: transferBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: backend.transfer_data()
                }
            }

            Item { Layout.fillHeight: true }

            // 底部提示
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "支持 JPG / PNG / BMP 格式图片  ·  由百度 OCR 提供识别服务"
                color: "#3a4a5a"
                font.pixelSize: 11
            }
        }
    }

    // 错误对话框
    Dialog {
        id: dialog
        title: "配置缺失"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Ok

        background: Rectangle {
            color: "#1a2a3a"
            radius: 10
            border.color: "#2a4a6a"
            border.width: 1
        }

        header: Rectangle {
            color: "transparent"
            height: 48

            Text {
                anchors.centerIn: parent
                text: "⚠  配置缺失"
                color: "#e0c060"
                font.pixelSize: 15
                font.bold: true
            }
        }

        contentItem: Text {
            text: "请先在 config/BaiduOCRKey.txt 中\n正确填写百度 OCR 的 API Key 和 Secret Key"
            color: "#a0b0c0"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            topPadding: 8
            bottomPadding: 8
        }

        Connections {
            target: backend
            onShowDialog: dialog.open()
        }
    }
}
