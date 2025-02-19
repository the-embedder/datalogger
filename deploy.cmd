@ECHO OFF
@REM === Cross-compile and copy library files

SETLOCAL

IF [%1] EQU [] (
    ECHO.Missing device specifier, e.g. COM1
    GOTO :EOF
) ELSE SET _MPY_DEVICE=%1

mpremote connect %_MPY_DEVICE% mkdir :/lib :/lib/microdot :/lib/threadsafe :/lib/utemplate :/static :/templates :/uploads

mpy-cross updater.py
mpy-cross datalogger.py

mpremote connect %_MPY_DEVICE% resume cp main.py updater.mpy datalogger.mpy :/

PUSHD lib\microdot\src\microdot

mpy-cross __init__.py
mpy-cross helpers.py
mpy-cross microdot.py
mpy-cross utemplate.py
mpy-cross websocket.py

mpremote connect %_MPY_DEVICE% resume cp __init__.mpy helpers.mpy microdot.mpy utemplate.mpy websocket.mpy :/lib/microdot/

POPD

PUSHD lib\micropython-async\v3\threadsafe

mpy-cross __init__.py
mpy-cross context.py
mpy-cross message.py
mpy-cross threadsafe_event.py
mpy-cross threadsafe_queue.py

mpremote connect %_MPY_DEVICE% resume cp __init__.mpy context.mpy message.mpy threadsafe_event.mpy threadsafe_queue.mpy :/lib/threadsafe/

POPD

PUSHD lib\utemplate\utemplate

mpy-cross compiled.py
mpy-cross recompile.py
mpy-cross source.py

mpremote connect %_MPY_DEVICE% resume cp compiled.mpy recompile.mpy source.mpy :/lib/utemplate/

POPD

PUSHD static

mpremote connect %_MPY_DEVICE% resume cp index.css index.js :/static/

POPD

PUSHD templates

mpremote connect %_MPY_DEVICE% resume cp index.html update.html :/templates/

POPD
