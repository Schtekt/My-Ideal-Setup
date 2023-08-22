# My Ideal Setup

This repo shows off an exampple of the setup I would use for a C++ project. This may be extended in the future to support Linux environments as well, but for now it only covers Windows.

## Prerequisites
To be able to build the dummy program, three things are necessary.

* **Visual studio code** (Can be found here https://visualstudio.microsoft.com/downloads/)

* **MSBuild**, this can be obtained with ["Build tools for visual studio"](https://aka.ms/vs/17/release/vs_BuildTools.exe). Make sure to add MSBuild to PATH.

* **Premake5**, can be downloaded from the premake [website](https://premake.github.io/). Make sure to add it to PATH.

For Premake5 and MSBuild, you may use the setup script (Setup.bat). This will download these dependencies, additionally, MSBuild will be installed on your machine. These dependencies must still be added to your path though.

## Build solution and compile program
Once the prerequisites are down, you may generate the solution and project files through premake
    
    premake5 vs2022

This will generate a solution for visual studio IDE 2022 edition, we will however not be using that IDE in this setup.

Next, run the following command to generate json build commands for visual studio code

    premake5 vscode

You should now be able to build the project from vscode. Open the project from the root of this repo, press **ctrl+shift+b** and select the appropriate options.

Once the application has been built, you should be able to run it from vscode with **f5**.

If you for some reason would like to get rid of all the files generated through premake and the compiler, you may use this command:

    premake5 clean