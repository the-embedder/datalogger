@ECHO OFF
@REM === Cross-compile and copy library files

SETLOCAL

IF [%1] EQU [] (
    ECHO.Missing device specifier, e.g. COM1
    GOTO :EOF
) ELSE SET _MPY_DEVICE=%1

mpremote connect %_MPY_DEVICE% mkdir :/lib
mpremote connect %_MPY_DEVICE% mkdir :/uploads

mpremote connect %_MPY_DEVICE% fs cp main.py :/

mpy-cross updater.py
mpremote connect %_MPY_DEVICE% fs cp updater.mpy :/

PUSHD lib\microdot\src\microdot
mpremote connect %_MPY_DEVICE% mkdir :/lib/microdot

mpy-cross __init__.py
mpremote connect %_MPY_DEVICE% fs cp __init__.mpy :/lib/microdot/

mpy-cross helpers.py
mpremote connect %_MPY_DEVICE% fs cp helpers.mpy :/lib/microdot/

mpy-cross microdot.py
mpremote connect %_MPY_DEVICE% fs cp microdot.mpy :/lib/microdot/

mpy-cross utemplate.py
mpremote connect %_MPY_DEVICE% fs cp utemplate.mpy :/lib/microdot/

mpy-cross websocket.py
mpremote connect %_MPY_DEVICE% fs cp websocket.mpy :/lib/microdot/

POPD

PUSHD lib\micropython-async\v3\threadsafe
mpremote connect %_MPY_DEVICE% mkdir :/lib/threadsafe

mpy-cross __init__.py
mpremote connect %_MPY_DEVICE% fs cp __init__.mpy :/lib/threadsafe/

mpy-cross context.py
mpremote connect %_MPY_DEVICE% fs cp context.mpy :/lib/threadsafe/

mpy-cross message.py
mpremote connect %_MPY_DEVICE% fs cp message.mpy :/lib/threadsafe/

mpy-cross threadsafe_event.py
mpremote connect %_MPY_DEVICE% fs cp threadsafe_event.mpy :/lib/threadsafe/

mpy-cross threadsafe_queue.py
mpremote connect %_MPY_DEVICE% fs cp threadsafe_queue.mpy :/lib/threadsafe/

POPD

PUSHD lib\utemplate\utemplate
mpremote connect %_MPY_DEVICE% mkdir :/lib/utemplate

mpy-cross compiled.py
mpremote connect %_MPY_DEVICE% fs cp compiled.mpy :/lib/utemplate/

mpy-cross recompile.py
mpremote connect %_MPY_DEVICE% fs cp recompile.mpy :/lib/utemplate/

mpy-cross source.py
mpremote connect %_MPY_DEVICE% fs cp source.mpy :/lib/utemplate/

POPD
