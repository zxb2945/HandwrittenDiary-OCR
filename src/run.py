import sys
from PyQt5.QtWidgets import QApplication, QFileDialog
from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine

class Backend:
    def __init__(self):
        self.file_path = ""

    def open_file_dialog(self):
        options = QFileDialog.Options()
        options |= QFileDialog.ReadOnly
        self.file_path, _ = QFileDialog.getOpenFileName(None, "Choose File", "", "All Files (*);;Text Files (*.txt)", options=options)
        print("Selected File:", self.file_path)

    def transfer_data(self):
        # 在这里添加百度OCR接口的逻辑
        print("Transfer Button Clicked")

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
