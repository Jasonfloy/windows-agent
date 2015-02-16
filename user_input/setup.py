#encoding=utf-8

from distutils.core import setup
import py2exe
import os
from glob import glob


mfcfiles = [os.path.join('D:\Program Files\python273\Lib\site-packages\pythonwin', i) for i in ["mfc90.dll", "mfc90u.dll", "mfcm90.dll", "mfcm90u.dll", "Microsoft.VC90.MFC.manifest"]]
data_files = [("Microsoft.VC90.MFC", mfcfiles),("Microsoft.VC90.CRT", glob(r'C:\WINDOWS\WinSxS\x86_Microsoft.VC90.CRT_1fc8b3b9a1e18e3b_9.0.21022.8_x-ww_d08d0375\*.*'))]
setup(
	windows = ["input.py"],
    data_files = data_files,
	zipfile = None
)