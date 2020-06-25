@echo off
@setlocal EnableDelayedExpansion

REM ------Set Your Environment------------------------------- 
if NOT DEFINED MSVC_VERSION set MSVC_VERSION=19
if NOT DEFINED CMAKE_CONFIG set CMAKE_CONFIG=Release
if NOT DEFINED PYTHONHOME   set PYTHONHOME=C:/Users/%username%/miniconda3
REM ---------------------------------------------------------

set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7"
set VALUE_NAME=15.0

if "%MSVC_VERSION%"=="14" (
    if "%processor_architecture%" == "AMD64" (
        set CMAKE_GENERATOR=Visual Studio 14 2015 Win64
    ) else (
        set CMAKE_GENERATOR=Visual Studio 14 2015
    )
) else if "%MSVC_VERSION%"=="12" (
    if "%processor_architecture%" == "AMD64" (
        set CMAKE_GENERATOR=Visual Studio 12 2013 Win64
    ) else (
        set CMAKE_GENERATOR=Visual Studio 12 2013
    )
) else if "%MSVC_VERSION%"=="15" (
    if "%processor_architecture%" == "AMD64" (
        set CMAKE_GENERATOR=Visual Studio 15 2017 Win64
    ) else (
        set CMAKE_GENERATOR=Visual Studio 15 2017
    )
) else if "%MSVC_VERSION%"=="19" (
    set CMAKE_GENERATOR=Visual Studio 16 2019
)

if "%MSVC_VERSION%" GEQ "15" (
    REM Find VC · microsoft/vswhere Wiki https://github.com/microsoft/vswhere/wiki/Find-VC
    for /F "usebackq tokens=1,2,*" %%A in (`vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set batch_file=%%CVC\Auxiliary\Build\vcvarsall.bat
    )
) else (
    set batch_file=!VS%MSVC_VERSION%0COMNTOOLS!..\..\VC\vcvarsall.bat
)
call "%batch_file%" %processor_architecture%

pushd ..
pushd examples
if NOT EXIST build mkdir build
pushd build

if "%MSVC_VERSION%" GEQ "19" (
    cmake -G"!CMAKE_GENERATOR!" -A x64^
        -DPYTHONHOME:STRING=%PYTHONHOME%^
        -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG% ^
        %~dp0
) else (
    cmake -G"!CMAKE_GENERATOR!" ^
        -DPYTHONHOME:STRING=%PYTHONHOME%^
        -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG% ^
        %~dp0
)
cmake --build . --config %CMAKE_CONFIG%  
SET BUILD_ERRORLEVEL=!ERRORLEVEL!
IF NOT "!BUILD_ERRORLEVEL!"=="0" (
    EXIT /B !BUILD_ERRORLEVEL!
)

pushd %CMAKE_CONFIG%  
if not EXIST platforms mkdir platforms
if EXIST %PYTHONHOME%\Library\plugins\platforms\qwindows.dll ^
copy %PYTHONHOME%\Library\plugins\platforms\qwindows.dll .\platforms\
popd
REM move ./%CMAKE_CONFIG% ../
popd
popd
popd
@endlocal
