# -*- mode: python ; coding: utf-8 -*-

# Find sdl2dll location
import os
import sdl2dll
sdl_dll_dir = os.path.dirname(sdl2dll.__file__)


block_cipher = None


a = Analysis(['../../src/main.py'],
             pathex=[],
             binaries=[],
             datas=[
                 (sdl_dll_dir, "sdl2dll")
             ],
             hiddenimports=[],
             hookspath=[],
             hooksconfig={},
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
          disable_windowed_traceback=False,
          target_arch='x86_64',
          codesign_identity=None,
          entitlements_file=None,
          icon='../res/icon.icns')
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas, 
               strip=False,
               upx=True,
               upx_exclude=[],
               name='ExampleApp')
app = BUNDLE(coll,
             name='ExampleApp.app',
             icon='../../res/icon.icns',
             bundle_identifier='com.example.app')
