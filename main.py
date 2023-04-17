# ///////////////////////////////////////////////////////////////
# k721519
# ///////////////////////////////////////////////////////////////

import sys
import os
import subprocess
import time
import webbrowser
import threading
import configparser

# pyside6-rcc resources.qrc -o resources_rc.py

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication, QMessageBox
# IMPORT / GUI AND MODULES AND WIDGETS
# ///////////////////////////////////////////////////////////////
from modules import *
from widgets import *
os.environ["QT_FONT_DPI"] = "96" # FIX Problem for High DPI and Scale above 100%

# SET AS GLOBAL WIDGETS
# ///////////////////////////////////////////////////////////////
widgets = None

config = configparser.ConfigParser()
config.read('data/config.ini')
proxy = config['SERVER']['proxy']
address = config['SERVER']['address']

class MainWindow(QMainWindow):
    def __init__(self):
        QMainWindow.__init__(self)

        # SET AS GLOBAL WIDGETS
        # ///////////////////////////////////////////////////////////////
        
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        global widgets
        widgets = self.ui

        # USE CUSTOM TITLE BAR | USE AS "False" FOR MAC OR LINUX
        # ///////////////////////////////////////////////////////////////
        Settings.ENABLE_CUSTOM_TITLE_BAR = True

        # APP NAME
        # ///////////////////////////////////////////////////////////////
        title = "KSD Launcher"
        description = "KSD Launcher"
        # APPLY TEXTS
        self.setWindowTitle(title)
        widgets.titleRightInfo.setText(description)

        # TOGGLE MENU
        # ///////////////////////////////////////////////////////////////
        widgets.toggleButton.clicked.connect(lambda: UIFunctions.toggleMenu(self, True))

        # SET UI DEFINITIONS
        # ///////////////////////////////////////////////////////////////
        UIFunctions.uiDefinitions(self)

        # QTableWidget PARAMETERS
        # ///////////////////////////////////////////////////////////////
        widgets.tableWidget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        # BUTTONS CLICK
        # ///////////////////////////////////////////////////////////////
        #一键启动
        widgets.btn_start_sd.clicked.connect(self.buttonClick)

        #按键绑定

        #page_home
        widgets.btn_onekey_install.clicked.connect(self.buttonClick)
        widgets.btn_root_file.clicked.connect(self.buttonClick)
        widgets.btn_start_args.clicked.connect(self.buttonClick)
        widgets.btn_output_manage.clicked.connect(self.buttonClick)
        widgets.btn_stop_container.clicked.connect(self.buttonClick)


        #page_manage
        widgets.btn_graphic_install.clicked.connect(self.buttonClick)
        widgets.btn_start_fix.clicked.connect(self.buttonClick)
        widgets.btn_onekey_restore.clicked.connect(self.buttonClick)
        widgets.btn_proxy_set.clicked.connect(self.buttonClick)
        widgets.btn_permission_repair.clicked.connect(self.buttonClick)

        #page update
        widgets.btn_update_sd.clicked.connect(self.buttonClick)
        widgets.btn_update_launch.clicked.connect(self.buttonClick)
        widgets.btn_install_git.clicked.connect(self.buttonClick)
        widgets.btn_old_transfer.clicked.connect(self.buttonClick)


        #other widget
        widgets.c_box_launcher_browser.currentIndexChanged[int].connect(self.start_browser_config)








        # LEFT MENUS
        widgets.btn_home.clicked.connect(self.buttonClick)
        widgets.btn_widgets.clicked.connect(self.buttonClick)
        widgets.btn_manage.clicked.connect(self.buttonClick)
        widgets.btn_exit.clicked.connect(self.buttonClick)



        

        # EXTRA LEFT BOX
        def openCloseLeftBox():
            UIFunctions.toggleLeftBox(self, True)
        widgets.toggleLeftBox.clicked.connect(openCloseLeftBox)
        widgets.extraCloseColumnBtn.clicked.connect(openCloseLeftBox)

        # EXTRA RIGHT BOX
        def openCloseRightBox():
            UIFunctions.toggleRightBox(self, True)
        widgets.settingsTopBtn.clicked.connect(openCloseRightBox)

        # SHOW APP
        # ///////////////////////////////////////////////////////////////
        self.show()

        # SET CUSTOM THEME
        # ///////////////////////////////////////////////////////////////
        #self.useCustomTheme = useCustomTheme
        #self.absPath = absPath
        useCustomTheme = False
        themeFile = ("themes\py_dracula_light.qss")

        # SET THEME AND HACKS
        if useCustomTheme:
            # LOAD AND APPLY STYLE
            UIFunctions.theme(self, themeFile, True)

            # SET HACKS
            AppFunctions.setThemeHack(self)

        # SET HOME PAGE AND SELECT MENU
        # ///////////////////////////////////////////////////////////////
        widgets.stackedWidget.setCurrentWidget(widgets.home)
        widgets.btn_home.setStyleSheet(UIFunctions.selectMenu(widgets.btn_home.styleSheet()))


    # BUTTONS CLICK
    # Post here your functions for clicked buttons
    # ///////////////////////////////////////////////////////////////
    def buttonClick(self):
        # GET BUTTON CLICKED
        btn = self.sender()
        btnName = btn.objectName()

        # SHOW HOME PAGE
        if btnName == "btn_exit":
            exit()

        # SHOW HOME PAGE
        elif btnName == "btn_home":
            widgets.stackedWidget.setCurrentWidget(widgets.home)
            UIFunctions.resetStyle(self, btnName)
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet()))

        # SHOW WIDGETS PAGE
        elif btnName == "btn_widgets":
            widgets.stackedWidget.setCurrentWidget(widgets.page_update)
            UIFunctions.resetStyle(self, btnName)
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet()))

        # SHOW NEW PAGE
        elif btnName == "btn_manage":
            widgets.stackedWidget.setCurrentWidget(widgets.page_manage) # SET PAGE
            UIFunctions.resetStyle(self, btnName) # RESET ANOTHERS BUTTONS SELECTED
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) # SELECT MENU

        elif btnName == "btn_start_sd":
            UIFunctions.resetStyle(self, btnName) # RESET ANOTHERS BUTTONS SELECTED
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) # SELECT MENU
            #os.system('/usr/lib/ksd-launcher/data/sd.sh')
            # 一键启动
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/sd.sh'])
            autoLaunch = config['CONF']['auto_launch']
            if autoLaunch == "true":
                thread = threading.Thread(target=lambda: (time.sleep(8), webbrowser.open('http://127.0.0.1:7860/')))
                thread.start()

        elif btnName == "btn_stop_container":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            # 停止 Docker 容器
            self.stopContainer()

    
        elif btnName == "btn_onekey_install":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            # 一键安装
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH'] # 修改PATH变量
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo chmod -R 777 /usr/lib/ksd-launcher && sudo find /usr/lib/ksd-launcher/data -type f -exec chmod +x {} && read '])
            # 在GNOME终端中启动脚本
            QMessageBox.information(self, "提示", "请在终端输入密码后，再点击Yes继续安装！", QMessageBox.Yes)
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/onekey_setup.sh'])


        elif btnName == "btn_root_file":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH']
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo nautilus ~/dockerx/stable-diffusion-webui/models/Stable-diffusion && exit'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)

        elif btnName == "btn_start_args":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            filename = '/usr/lib/ksd-launcher/data/sd.sh'
            subprocess.run(['gedit', filename])

        elif btnName == "btn_output_manage":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH']
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo nautilus ~/dockerx/stable-diffusion-webui/outputs && exit'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)

        #page_manage
        elif btnName == "btn_graphic_install":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            # 一键安装
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH'] # 修改PATH变量
            # 在GNOME终端中启动脚本
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/graphic_setup.sh'])

        elif btnName == "btn_start_fix":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo chmod -R 777 /usr/lib/ksd-launcher && sudo find /usr/lib/ksd-launcher/data -type f -exec chmod +x {} && read '])
            # 在GNOME终端中启动脚本
            QMessageBox.information(self, "提示", "请在终端输入密码后，再点击Yes继续修复操作！", QMessageBox.Yes)
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/onekey_setup.sh'])

        elif btnName == "btn_onekey_restore":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo chmod -R 777 /usr/lib/ksd-launcher && sudo find /usr/lib/ksd-launcher/data -type f -exec chmod +x {} && read '])
            # 在GNOME终端中启动脚本
            QMessageBox.information(self, "提示", "请在终端输入密码后，再点击Yes继续还原操作！", QMessageBox.Yes)
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/onekey_setup.sh'])


        elif btnName == "btn_proxy_set":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            # 一键安装
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH'] # 修改PATH变量
            # 在GNOME终端中启动脚本
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/proxy_set.sh'])
        
        elif btnName == "btn_permission_repair":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'echo "准备修复权限..." && sudo chmod -R 777  ~/dockerx && echo "已修复" && sudo find /usr/lib/ksd-launcher/data -type f -exec chmod +x {} && read '])

        #########Page Update###########
        elif btnName == "btn_update_sd":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH'] # 修改PATH变量
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/update_sd.sh'])

        elif btnName == "btn_update_launch":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            env = os.environ.copy()
            env['PATH'] = '/usr/local/bin:' + env['PATH'] # 修改PATH变量
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/update_launcher.sh'])

        elif btnName == "btn_install_git":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', 'sudo apt-get update && sudo apt install git && echo "安装完成" && read'])

        elif btnName == "btn_old_transfer":
            UIFunctions.resetStyle(self, btnName) 
            btn.setStyleSheet(UIFunctions.selectMenu(btn.styleSheet())) 
            subprocess.run(['gnome-terminal', '-x', '/bin/bash', '-c', '/usr/lib/ksd-launcher/data/update_old_transfer.sh'])


        # PRINT BTN NAME
        print(f'Button "{btnName}" pressed!')


    # RESIZE EVENTS
    # ///////////////////////////////////////////////////////////////
    def resizeEvent(self, event):
        # Update Size Grips
        UIFunctions.resize_grips(self)

    # MOUSE CLICK EVENTS
    # ///////////////////////////////////////////////////////////////
    def mousePressEvent(self, event):
        # SET DRAG POS WINDOW
        self.dragPos = event.globalPos()

        # PRINT MOUSE EVENTS
        if event.buttons() == Qt.LeftButton:
            print('Mouse click: LEFT CLICK')
        if event.buttons() == Qt.RightButton:
            print('Mouse click: RIGHT CLICK')

    # 停止容器
    def stopContainer(self):
        try:
            # 检查容器是否在运行
            output = subprocess.check_output(['docker', 'inspect', '-f', '{{.State.Running}}', 'stable-diffusion'])
            # 如果容器正在运行
            if output.decode().strip() == 'true':
                # 停止容器
                stop_process = subprocess.Popen('docker stop stable-diffusion', shell=True)
                # 显示提示信息
                msg_box = QMessageBox()
                msg_box.setWindowTitle("提示")
                msg_box.setText("正在关闭 stable-diffusion...")
                msg_box.show()
                # 等待停止命令执行完毕
                stop_process.wait()
                # 判断容器是否成功停止
                if stop_process.returncode == 0:
                    # 显示关闭成功的提示信息
                    msg_box.setText("关闭成功")
                    msg_box.setStandardButtons(QMessageBox.Ok)
                    msg_box.exec()
                else:
                    # 显示关闭失败的提示信息，并执行强制关闭命令
                    msg_box.setText("关闭失败，正在执行强制关闭...")
                    msg_box.setStandardButtons(QMessageBox.Ok)
                    msg_box.exec()
                    force_stop_process = subprocess.Popen('docker stop -f stable-diffusion', shell=True)
                    force_stop_process.wait()
                    # 再次检查容器是否成功停止
                    if force_stop_process.returncode == 0:
                        # 显示关闭成功的提示信息
                        msg_box.setText("关闭成功")
                        msg_box.setStandardButtons(QMessageBox.Ok)
                        msg_box.exec()
                    else:
                        # 显示关闭失败的提示信息
                        msg_box.setText("强制关闭失败，请手动关闭容器")
                        msg_box.setStandardButtons(QMessageBox.Ok)
                        msg_box.exec()
            else:
                # 显示容器已经关闭的提示信息
                msg_box = QMessageBox()
                msg_box.setWindowTitle("提示")
                msg_box.setText("容器已经关闭")
                msg_box.setStandardButtons(QMessageBox.Ok)
                msg_box.exec()
        except subprocess.CalledProcessError:
            # 显示容器未运行的提示信息
            msg_box = QMessageBox()
            msg_box.setWindowTitle("提示")
            msg_box.setText("容器未运行")
            msg_box.setStandardButtons(QMessageBox.Ok)
            msg_box.exec()


    # 修改配置是否自动打开浏览器
    def start_browser_config(self, i):
        if i == 0:
            config.set('CONF', 'auto_launch', 'true')
        elif i == 1:
            config.set('CONF', 'auto_launch', 'false')
        with open('/usr/lib/ksd-launcher/data/config.ini', 'w') as f:
            config.write(f)



#   --------------------------------------------------移动功能-------------------------------------------------
 
def mousePressEvent(self, event):        #鼠标左键按下时获取鼠标坐标
    if event.button() == Qt.LeftButton:
        self._move_drag = True
        self.m_Position = event.globalPos() - self.pos()
        event.accept()
def mouseMoveEvent(self, QMouseEvent):    #鼠标在按下左键的情况下移动时,根据坐标移动界面
        if Qt.LeftButton and self._move_drag:
            self.move(QMouseEvent.globalPos() - self.m_Position)
            QMouseEvent.accept()
    
def mouseReleaseEvent(self, QMouseEvent):    #鼠标按键释放时,取消移动
    self._move_drag = False



if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon("icon.ico"))
    window = MainWindow()
    sys.exit(app.exec())
