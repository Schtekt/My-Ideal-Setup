project "RuntimeApp"
    kind "ConsoleApp"
    language "C++"
    targetdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin/%{prj.name}"
    objdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin-int/%{prj.name}"
    files { "src/**.h", "src/**.cpp" }
    includedirs{"lib/"}
    links{"lib"}

project "Lib"
    kind "StaticLib"
    language "C++"
    targetdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin/%{prj.name}"
    objdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin-int/%{prj.name}"
    files { "lib/**.h", "lib/**.cpp" }

project "UnitTests"
    kind "ConsoleApp"
    language "C++"
    targetdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin/%{prj.name}"
    objdir "../Build/%{cfg.buildcfg}_%{cfg.platform}/bin-int/%{prj.name}"
    files {"unitTests/**.cpp", "unitTests/**.h"}
    includedirs{"lib/", "../external/googletest/googletest/include"}
    links{"lib", "gTest"}