require "vscode"
require "clean"

workspace "DummyWorkspace"
    cppdialect "C++17"
    configurations
    {
        "debug",
        "release"
    }
    filter "system:windows"
        platforms {"win32", "win64"}
    filter "system:linux"
        platforms {"lin32", "lin64"}
    
    filter "platforms:win32 or lin32"
        architecture "x86"
    
    filter "platforms:win64 or lin64"
        architecture "x86_64"

    filter "configurations:debug"
        defines { "DEBUG" }
        symbols "On"
    filter "configurations:release"
        defines { "NDEBUG" }
        optimize "On"

include "DummyWorkspace"
include "external"