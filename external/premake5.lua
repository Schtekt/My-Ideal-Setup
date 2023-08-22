project "gTest"
    kind "StaticLib"
    targetdir "../Build/bin/%{prj.name}"
    objdir "../Build/bin-int/%{prj.name}"
    files { "googletest/googletest/src/gtest-all.cc" }
    includedirs { "googletest/googletest/include", "googletest/googletest" }