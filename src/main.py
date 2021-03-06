
import sys

import sdl2

from PySide6.QtWidgets import QApplication
from PySide6.QtCore import Qt
from mainwindow import MainWindow

QApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
QApplication.setAttribute(Qt.AA_UseHighDpiPixmaps)
QApplication.setAttribute(Qt.AA_DontUseNativeMenuBar)

sdl2.SDL_Init(sdl2.SDL_INIT_JOYSTICK)

try:
    import ctypes
    ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID("com.example.app")
except AttributeError:
    pass

app = QApplication(sys.argv)
win = MainWindow()

win.show()
app.exec()
