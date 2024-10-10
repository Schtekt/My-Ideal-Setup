project "DummyLib"
    kind "StaticLib"
    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")
    files {"include/**.h", "src/**.cpp"}
    includedirs{"include/"}