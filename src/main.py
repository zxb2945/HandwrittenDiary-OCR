import sys
from PyQt5.QtWidgets import QApplication, QFileDialog
from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from baiduOCR import baidu_ocr_handwriting

# 继承自 QObject，这使得它能够作为 PyQt QML的信号槽对象。
#在Qt框架中，信号槽（Signal-Slot）是其重要的编程机制之一，用于实现事件驱动
class Backend(QObject):
    #定义showDialog信号，与QML中的onShowDialog关联
    showDialog = pyqtSignal()

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

        api_key = None
        secret_key = None

        configfile_path = R'config/BaiduOCRKey.txt'
        try:
            with open(configfile_path, 'r') as file:
                #content = file.read()
                for line in file:
                    if line.startswith('api_key:'):
                        # 获取目标字段后面的内容并去除首尾空格
                        api_key = line[len('api_key:'):].strip()
                        print(f"匹配到api_key，值为: {api_key}")                    
                    if line.startswith('secret_key:'):
                        # 获取目标字段后面的内容并去除首尾空格
                        secret_key = line[len('secret_key:'):].strip()
                        print(f"匹配到secret_key，值为: {secret_key}")                     
                #print(content)
        except FileNotFoundError:
            print(f"文件 '{configfile_path}' 不存在。")
        except IOError:
            print(f"无法读取文件 '{configfile_path}'。")


        if api_key == None or secret_key == None:
            #出发对话框pop
            self.showDialog.emit()
        else:
            print("Call baidu ocr")
            #baidu_ocr_handwriting(api_key, secret_key, self.file_path)


if __name__ == "__main__":
    app = QApplication(sys.argv)

    backend = Backend()

    engine = QQmlApplicationEngine()

    # 将 Python 对象注册为 QML 上下文中的对象
    context = engine.rootContext()
    context.setContextProperty("backend", backend)

    # 加载 QML 文件
    engine.load(QUrl.fromLocalFile("src/windows.qml"))

    if not engine.rootObjects():
        sys.exit(-1) 

    sys.exit(app.exec_())

