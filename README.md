# My Ideal Setup

This repo shows off an example of the setup I would use for a C++ project. The project is supported for Linux and Windows. However, as this is mainly developed on windows, Linux support is not 100% guranteed.

## Windows

### Prerequisites
To be able to build the dummy program, three things are necessary.

* **Visual studio code** (Can be found here https://visualstudio.microsoft.com/downloads/)

* **CMake** (Can be found here https://cmake.org/download/)

* **MSBuild**, this can be obtained with ["Build tools for visual studio"](https://aka.ms/vs/17/release/vs_BuildTools.exe). Make sure to add MSBuild to PATH.

* **Premake5**, can be downloaded from the premake [website](https://premake.github.io/). Make sure to add it to PATH.

For Premake5 and MSBuild, you may use the setup script (SetupWin.bat). This will download these dependencies, additionally, MSBuild will be installed on your machine. These dependencies must still be added to your path though.

## Linux

### Prerequisites
* **Visual studio code** (Can be found here https://visualstudio.microsoft.com/downloads/)

* **CMake** Simply install it from distro (`sudo apt install cmake` on ubuntu)

* **Premake5**, can be downloaded from the premake [website](https://premake.github.io/). Make sure to export it to PATH.

There are additional dependencies such as installing C++, and GDB. These are however normally installed by default, as such I will not go into detail on how to install them here.

## Build solution and compile program
Once the prerequisites are down, you may generate the solution and project files through premake
```
-- windows
premake5 vs2022

-- linux
premake5 gmake2
```

This will generate a settings for a solution. For Windows, it will specifically generate a solution for visual studio IDE 2022 edition, for this setup, the IDE itself will not be used, however it should be perfectly fine to use if the user whishes to do so.

Next, run the following command to generate json build commands for visual studio code

    premake5 vscode

You should now be able to build the project from vscode. Open the project from the root of this repo, press `ctrl+shift+b` and select the appropriate options.

Once the application has been built, you should be able to run it from vscode with **f5**. You may also select which project to run from the "Run and debug" menu (`ctrl + shift + d` to open it)

If you for some reason would like to get rid of all the files generated through premake and the compiler, you may use this command:

    premake5 clean