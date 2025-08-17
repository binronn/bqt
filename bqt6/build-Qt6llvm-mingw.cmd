@chcp 65001
@cd /d %~dp0

:: ==========================
:: Qt 和工具链配置
:: ==========================
SET QT_VERSION=6.9.1
SET LLVM_MINGW_PATH=D:\a\bqt\llvm-mingw-20250528-ucrt-x86_64\bin
SET NINJA_PATH=D:\a\bqt\ninja
SET PATH=%LLVM_MINGW_PATH%;%NINJA_PATH%;%PATH%

SET QT_PATH=D:\a\bqt\Qt
SET SRC_QT=%QT_PATH%\%QT_VERSION%\qt-everywhere-src-%QT_VERSION%

:: 通用配置参数
SET COMMON_CFG=-opensource -confirm-license -nomake tests -nomake examples -skip qtwebengine -qt-libpng -qt-libjpeg -qt-zlib -qt-pcre -qt-freetype -schannel

:: ==========================
:: 3. 32位 Debug 共享库
:: ==========================
SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-x86-Debug-shared
SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%\install-x86-Debug-shared
rmdir /s /q "%BUILD_DIR%" 2>nul
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

call %SRC_QT%\configure.bat %COMMON_CFG% -debug -shared -prefix %INSTALL_DIR% -- -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32
cmake --build . --parallel
cmake --install .
copy %~dp0\qt.conf %INSTALL_DIR%\bin

:: ==========================
:: 4. 32位 Release 静态库
:: ==========================
SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-x86-Release-static
SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%\install-x86-Release-static
rmdir /s /q "%BUILD_DIR%" 2>nul
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

call %SRC_QT%\configure.bat %COMMON_CFG% -release -static -prefix %INSTALL_DIR% -- -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32
cmake --build . --parallel
cmake --install .
copy %~dp0\qt.conf %INSTALL_DIR%\bin


REM :: ==========================
REM :: 1. 64位 Debug 共享库
REM :: ==========================
REM SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-x64-Debug-shared
REM SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%\install-x64-Debug-shared
REM rmdir /s /q "%BUILD_DIR%" 2>nul
REM mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

REM call %SRC_QT%\configure.bat %COMMON_CFG% -debug -shared -prefix %INSTALL_DIR% -- -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64
REM cmake --build . --parallel
REM cmake --install .
REM copy %~dp0\qt.conf %INSTALL_DIR%\bin

REM :: ==========================
REM :: 2. 64位 Release 静态库
REM :: ==========================
REM SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-x64-Release-static
REM SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%\install-x64-Release-static
REM rmdir /s /q "%BUILD_DIR%" 2>nul
REM mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

REM call %SRC_QT%\configure.bat %COMMON_CFG% -release -static -prefix %INSTALL_DIR% -- -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64
REM cmake --build . --parallel
REM cmake --install .
REM copy %~dp0\qt.conf %INSTALL_DIR%\bin

:: ==========================
:: 结束
:: ==========================
@echo.
@echo Qt %QT_VERSION% 四个版本全部编译完成！
@cmd /k

