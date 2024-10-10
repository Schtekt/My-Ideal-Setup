project "googletest"
    kind "Makefile"
    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")

    googletestDirectory = path.getdirectory(_SCRIPT) .. "/googletest"
    googletestBuildFolder = "%{prj.objdir}"

    buildcommands {
        "{MKDIR} " .. googletestBuildFolder,
        "cmake -S " .. googletestDirectory .. " -B " .. googletestBuildFolder,
        "cmake --build " .. googletestBuildFolder .. " --config %{cfg.buildcfg}",
        "{MKDIR} %{prj.targetdir}",
        "{COPY} " .. googletestBuildFolder .. "/lib/libgtest.a %{prj.targetdir}/libgtest.a"
    }