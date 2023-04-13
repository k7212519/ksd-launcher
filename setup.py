import sys
import os
from cx_Freeze import setup, Executable

# ADD FILES
files = ['icon.ico','themes/']

# TARGET
target = Executable(
    script="main.py",
    base="Win32GUI",
    icon="icon.ico"
)

# SETUP 
setup(
    name = "KSD Launcher",
    version = "1.0",
    description = "Launcher for AMD stable-diffusion-webui",
    author = "k7212519",
    options = {'build_exe' : {'include_files' : files}},
    executables = [target]
    
)
