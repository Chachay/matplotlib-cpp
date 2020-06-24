# contrib/

This folder contains contributions that may be useful to users of this library, but
have a too specialized audience to become part of the main tree.

In particular, things in here will have a higher rate of bit-rot, since
contributors are not required to and may be unable to check whether their
changes break any of them.

## Windows support
Tested on the following environment
* Windows 10 - 64bit
* Anaconda 4.3 (64 bit)
* Python 3.6.0
* CMake 3.9.4
* Visual Studio 2017, 2015, 2013

### Configuring and Building Samples
1. Edit WinBuild.cmd for your environment(Line:5-7)
    if NOT DEFINED MSVC_VERSION set MSVC_VERSION=[Your Visual Studio Version(12, 14, 15)]
    if NOT DEFINED CMAKE_CONFIG set CMAKE_CONFIG=Release
    if NOT DEFINED PYTHONHOME   set PYTHONHOME=[Your Python Path]

2. Run WinBuild.cmd to build
```cmd
> cd contrib
> WinBuild.cmd
```
The `WinBuild.cmd` will set up temporal ENV variables and build binaries in (matplotlib root)/examples with the Release configuration.

3. Find exe files in examples/build/Release
Note: platforms folder is necessary to make qt works.


### Check before run examples
If you use Anaconda on Windows, you might need to set PYTHONHOME to Anaconda home directory and QT_QPA_PLATFORM_PLUGIN_PATH to %PYTHONHOME%Library/plugins/platforms. The latter is for especially when you get the error which says 'This application failed to start because it could not find or load the Qt platform plugin "windows"
in "".'
