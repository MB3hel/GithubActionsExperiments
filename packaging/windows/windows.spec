# -*- mode: python ; coding: utf-8 -*-


# PySide6 not automatically supported by pyinstaller
# Manually add missing things
import os
import PySide6
ps6_dir = os.path.dirname(PySide6.__file__)

# Find sdl2dll location
import sdl2dll
sdl_dll_dir = os.path.dirname(sdl2dll.__file__)


block_cipher = None


a = Analysis(['..\\..\\src\\main.py'],
             binaries=[],
             datas=[
                (os.path.join(ps6_dir, "plugins", "platforms"), "PySide6/plugins/platforms"),
                (sdl_dll_dir, "sdl2dll")
             ],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='ExampleApp',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=False,
          icon='..\\..\\res\\icon.ico')
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='ExampleApp')
