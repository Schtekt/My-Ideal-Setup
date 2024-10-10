project "googletest"
    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")

    googletestDirectory = "\"" .. path.getdirectory(_SCRIPT) .. "\"" .. "/googletest"
    googletestBuildFolder = "%{prj.objdir}"

    filter "system:windows"
        kind "Utility"
        filter "configurations:debug"
            prebuildcommands{
                "{MKDIR} " .. googletestBuildFolder,
                "cmake -S " .. googletestDirectory .. " -B " .. googletestBuildFolder,
                "cmake --build " .. googletestBuildFolder .. " --config %{cfg.buildcfg}",
            }
            postbuildcommands {
                "{COPY} " .. googletestBuildFolder .. "/lib/Debug/gtest.pdb" .. " %{prj.targetdir}",
                "{COPY} " .. googletestBuildFolder .. "/lib/Debug/gtest.lib" .. " %{prj.targetdir}"
            }
        filter "configurations:release"
            prebuildcommands{
                "{MKDIR} " .. googletestBuildFolder,
                "cmake -S " .. googletestDirectory .. " -B " .. googletestBuildFolder,
                "cmake --build " .. googletestBuildFolder .. " --config %{cfg.buildcfg}",
            }
            postbuildcommands{
                "{COPY} " .. googletestBuildFolder .. "/lib/Release/gtest.lib" .. " %{prj.targetdir}"
            }

    filter "system:linux"
        kind "Makefile"
        buildcommands{
            "{MKDIR} " .. googletestBuildFolder,
            "cmake -S " .. googletestDirectory .. " -B " .. googletestBuildFolder,
            "cmake --build " .. googletestBuildFolder .. " --config %{cfg.buildcfg}",
            "{MKDIR} %{prj.targetdir}",
            "{COPY} " .. googletestBuildFolder .. "/lib/libgtest.a" .. " %{prj.targetdir}/libgtest.a"
        }