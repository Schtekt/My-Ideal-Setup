project "gTest"
    kind "StaticLib"
    targetdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin/%{prj.name}"
    objdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin-int/%{prj.name}"
    files { "googletest/googletest/src/gtest-all.cc" }
    includedirs { "googletest/googletest/include", "googletest/googletest" }