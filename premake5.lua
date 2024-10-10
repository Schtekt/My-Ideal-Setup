require "clean"
require "vscode"

workspace "DummyWorkspace"
    location "Generated"
    cppdialect "C++17"
    configurations
    {
        "debug",
        "release"
    }

    architecture "x86_64"

    filter "configurations:debug"
        defines { "DEBUG" }
        symbols "On"
    filter "configurations:release"
        defines { "NDEBUG" }
        optimize "On"

    targetBuildPath = path.getdirectory(_SCRIPT) .. "/Build/target"
    objBuildPath = path.getdirectory(_SCRIPT) .. "/Build/obj"

include "External"
include "DummyLib"
include "DummyApp"
include "DummyTest"