@echo off
echo Download premake5
curl -sLO https://github.com/premake/premake-core/releases/download/v5.0.0-beta1/premake-5.0.0-beta1-windows.zip
tar -xf premake-5.0.0-beta1-windows.zip
del premake-5.0.0-beta1-windows.zip

where premake5>NUL
IF %ERRORLEVEL% NEQ 0 (echo Error, make sure to add premake5 to your path environment variable!& echo.While it has been downloaded to the repo, you might want to place it elsewhere and then add it to your path variable) ELSE (echo Success!)

echo Download and install vs_buildtools
curl -sLO https://aka.ms/vs/17/release/vs_buildtools.exe
vs_buildtools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --Wait
IF %ERRORLEVEL% NEQ 0 (echo Error, could not install msbuild)
del vs_buildtools.exe

echo. & echo Check if msbuild can be called & echo.
WHERE msbuild>NUL
IF %ERRORLEVEL% NEQ 0 (echo Error, make sure to add msbuild to your path environment variable!& echo.It should exist here: "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin") ELSE (echo Success!)