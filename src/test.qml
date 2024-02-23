import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "OCR App"

    Rectangle {
        width: parent.width
        height: parent.height

        Column {
            anchors.centerIn: parent

            TextField {
                id: filePathInput
                width: parent.width - 20
                placeholderText: "File Path"
                
            }
            Button {
                text: "Open File Dialog"              
            }

            Button {
                text: "Transfer"               
            }
        }
    }
}
