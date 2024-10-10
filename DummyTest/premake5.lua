project "DummyTest"
    kind "ConsoleApp"
    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")
    files {"src/**.h", "src/**.cpp"}
    includedirs{"../DummyLib/include", "../External/googletest/googletest/", "../External/googletest/googletest/include"}

    libdirs{targetBuildPath .. "/googletest"}
    links{"DummyLib", "gtest"}