project "googletest"
    kind "Utility"
    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")

    googletestDirectory = "\"" .. path.getdirectory(_SCRIPT) .. "\"" .. "/googletest"
    googletestBuildFolder = "%{prj.objdir}"

    filter "system:windows"
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
        prebuildcommands{
            "{MKDIR} " .. googletestBuildFolder,
            "cmake -S " .. googletestDirectory .. " -B " .. googletestBuildFolder,
            "cmake --build " .. googletestBuildFolder .. " --config %{cfg.buildcfg}",
            --"{COPY} " .. googletestBuildFolder .. "/lib/libgtest.a" .. " %{prj.targetdir}/libgtest.a"
        }