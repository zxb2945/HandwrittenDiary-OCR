import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "OCR App"

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#3498db" // 设置背景颜色为浅蓝色

        GridLayout {
            rows: 10
            columns: 3
            anchors.fill: parent

            TextField {
                id: filePathInput
                Layout.fillWidth: true
                Layout.row: 0
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.leftMargin: 10
                Layout.topMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                placeholderText: "File Path"
                // 绑定 TextField 的 text 属性到 backend.file_path
                text: backend.file_path

                //3.接收后端发送过来的path变化信号
                Connections {
                    target: backend
                    onFile_path_changed: {
                        //QML中打印debug信息
                        console.log("Received file path:", backend.file_path)
                        //不知道为什么windows.qml中取不到backend.file_path，却可以调用backend.open_file_dialog()？？
                        //原因：因为file_path没有被设置为@pyqtProperty(str)！！！既要被QML引用必须是专用的属性
                        filePathInput.text = backend.file_path;
                    }
                }                                                      
            }

            Button {
                text: "Open File Dialog"
                Layout.fillWidth: true
                Layout.row: 0
                Layout.column: 2
                Layout.leftMargin: 10
                Layout.topMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                onClicked: backend.open_file_dialog()
            }

            Button {
                text: "Transfer"
                Layout.fillWidth: true
                Layout.row: 1
                Layout.column: 2
                Layout.leftMargin: 10
                Layout.topMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                onClicked: backend.transfer_data()
            }

            Repeater {
                model: 8 // 创建8个长方形占位
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#3498db" // 设置颜色为与背景色相同的浅蓝色
                }
            }

            // Add other elements as needed
        }
    }

    Dialog {
        id: dialog
        title: "Message"
        standardButtons: Dialog.Ok

        Column {
            Text {
                text: "请正确配置百度OCR的Key"
                horizontalAlignment: Text.AlignHCenter
            }
        }

        //建立信号和槽之间的连接,Connections
        Connections {
            // 目标是发射信号的对象，即Backend实例
            target: backend
            // 当showDialog信号触发时，打开对话框
            onShowDialog: dialog.open()
        }     
    }


}
