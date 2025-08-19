@chcp 65001
@cd /d %~dp0

:: 设置Qt版本
SET QT_VERSION=6.9.1

:: 设置LLVM-MinGW版本代号
SET LLVM_MinGW_VERSION=llvm-mingw-20250528-ucrt-x86_64

:: 设置编译器和Ninja路径
SET PATH=D:\a\bqt\%LLVM_MinGW_VERSION%\bin;D:\a\bqt\ninja;%PATH%

:: 设置Qt文件夹路径
SET QT_PATH=D:\a\bqt\Qt

:: 公共源代码路径
SET SRC_QT=%QT_PATH%\%QT_VERSION%\qt-everywhere-src-%QT_VERSION%

:: 公共configure参数
SET COMMON_CFG=-opensource -confirm-license -nomake examples -nomake tests -skip qtwebengine -qt-libpng -qt-libjpeg -qt-zlib -qt-pcre -qt-freetype

:: ================================
:: 64位 Debug 共享库
:: ================================
SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-64-debug-shared
SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%-64-debug-shared

rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

call %SRC_QT%\configure.bat %COMMON_CFG% -debug -shared -prefix "%INSTALL_DIR%"

cmake --build . --parallel
cmake --install .

:: 复制OpenSSL DLLs到安装目录（针对共享库构建）
echo "Copying OpenSSL DLLs for shared debug build..."
copy "%OPENSSL_LIBDIR%\..\bin\libcrypto-3-x64.dll" "%INSTALL_DIR%\bin"
copy "%OPENSSL_LIBDIR%\..\bin\libssl-3-x64.dll" "%INSTALL_DIR%\bin"
echo "Copying done."

:: ================================
:: 64位 Release 静态库
:: ================================
SET BUILD_DIR=%QT_PATH%\%QT_VERSION%\build-64-release-static
SET INSTALL_DIR=%QT_PATH%\%QT_VERSION%-64-release-static

rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

call %SRC_QT%\configure.bat %COMMON_CFG% -release -static -static-runtime -prefix "%INSTALL_DIR%"

cmake --build . --parallel
cmake --install .


:: ================================
:: 复制 qt.conf (可选)
:: ================================
echo "Copying qt.conf..."
copy %~dp0\qt.conf "%QT_PATH%\%QT_VERSION%-64-debug-shared\bin"
copy %~dp0\qt.conf "%QT_PATH%\%QT_VERSION%-64-release-static\bin"
echo "All tasks completed."
