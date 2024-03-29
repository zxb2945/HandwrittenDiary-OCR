import sys
from PyQt5.QtWidgets import QApplication, QFileDialog
from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSlot

# 继承自 QObject，这使得它能够作为 PyQt 的信号槽对象。
class Backend(QObject):
    def __init__(self):
        super().__init__()
        self._file_path = ""

    @property
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, value):
        self._file_path = value

    #使用了 @pyqtSlot() 装饰器，因而可以在 QML 中作为槽函数连接到相应的信号。
    @pyqtSlot()
    def open_file_dialog(self):
        # 实现打开文件对话框的逻辑
        options = QFileDialog.Options()
        options |= QFileDialog.ReadOnly
        self.file_path, _ = QFileDialog.getOpenFileName(None, "Choose File", "", "All Files (*);;Text Files (*.txt)", options=options)
        print("Selected File:", self.file_path)

    @pyqtSlot()
    def transfer_data(self):
        # 在这里添加百度OCR接口的逻辑
        print("Transfer Button Clicked")

    # 打开文件，如果文件不存在则创建它，使用写入模式（'w'）
    file_path = R'C:\Users\zxb29\Desktop\OCR Photo\output.md'
    with open(file_path, 'w') as f:
        # 写入文本到文件
        f.write('Hello, world!\n')
        f.write('This is a text file.\n')
        f.write('You can write anything you want here.\n')


if __name__ == "__main__":
    app = QApplication(sys.argv)

    backend = Backend()

    engine = QQmlApplicationEngine()

    # 将 Python 对象注册为 QML 上下文中的对象
    context = engine.rootContext()
    context.setContextProperty("backend", backend)

    # 加载 QML 文件
    engine.load(QUrl.fromLocalFile("src/test.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())