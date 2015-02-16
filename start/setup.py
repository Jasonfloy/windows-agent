#encoding=utf-8

from distutils.core import setup
import py2exe
import sys

sys.argv.append("py2exe")

setup(
    #version = "5.0.1",
    #description = "Monitor",
    #name = "Monitor",
	#options = {'py2exe': {'bundle_files': 1, 'compressed': True}},
    windows=["windows-start.py"],
	zipfile = None
)
