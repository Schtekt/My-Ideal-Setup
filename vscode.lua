local workspaceName = ""
local projectNames = {}
local configurations = {}
local operatingSystem = ""

function winLaunch(projectName, outputFile)
    outputFile:write(
        "\t\t{\n" ..
        "\t\t\t\"name\":\"" .. projectName .. "\",\n" ..
        "\t\t\t\"type\":\"cppvsdbg\",\n" ..
        "\t\t\t\"request\":\"launch\",\n" ..
        "\t\t\t\"program\":\"${workspaceFolder}/Build/target/" .. projectName .. "/" .. projectName ..".exe\",\n" ..
        "\t\t\t\"stopAtEntry\":false,\n" ..
        "\t\t\t\"cwd\":\"${workspaceFolder}\",\n" ..
        "\t\t\t\"console\": \"integratedTerminal\"\n" ..
        "\t\t},\n"
    )
end

function linLaunch(projectName, outputFile)
    outputFile:write(
        "\t\t{\n" ..
        "\t\t\t\"name\":\"" .. projectName .. "\",\n" ..
        "\t\t\t\"type\":\"cppdbg\",\n" ..
        "\t\t\t\"request\":\"launch\",\n" ..
        "\t\t\t\"program\":\"${workspaceFolder}/Build/target/" .. projectName .. "/" .. projectName .."\",\n" ..
        "\t\t\t\"stopAtEntry\":false,\n" ..
        "\t\t\t\"externalConsole\":false,\n" ..
        "\t\t\t\"cwd\":\"${workspaceFolder}\",\n" ..
        "\t\t\t\"MIMode\":\"gdb\",\n" ..
        "\t\t\t\"miDebuggerPath\":\"/usr/bin/gdb\",\n" ..
        "\t\t\t\"setupCommands\": [\n" ..
        "\t\t\t\t{\n" ..
        "\t\t\t\t\t\"description\": \"Enable pretty-printing for gdb\",\n" ..
        "\t\t\t\t\t\"text\": \"-enable-pretty-printing\",\n" ..
        "\t\t\t\t\t\"ignoreFailures\": false\n" ..
        "\t\t\t\t}\n" ..
        "\t\t\t]\n" ..
        "\t\t},\n"
    )
end

newaction {
    trigger = "vscode",
    description = "Generate vscode tasks",

    onWorkspace = function(wrk)
        workspaceName = wrk.name
        operatingSystem = wrk.system
        for index, c in ipairs(wrk.configurations) do
            table.insert(configurations, c)
        end
    end,

    onProject = function(prj)
        if prj.kind == 'ConsoleApp' or prj.kind == 'WindowedApp' then
            table.insert(projectNames, prj.name)
        end
    end,

    execute = function()
        tasksFile = io.open(".vscode/tasks.json", "w")
        tasksFile:write(
            "{\n" ..
            "\t\"version\": \"2.0.0\"," ..
            "\t\"tasks\": [\n" ..
            "\t\t{\n" ..
            "\t\t\t\"label\": \"Generate build files\",\n" ..
            "\t\t\t\"type\": \"shell\",\n" ..
            "\t\t\t\"group\": \"none\",\n" ..
            "\t\t\t\"command\": \"premake5\",\n" ..
            "\t\t\t\"linux\": {\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"gmake2\"\n" ..
            "\t\t\t\t]\n" ..
            "\t\t\t},\n" ..
            "\t\t\t\"windows\": {\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"vs2022\"\n" ..
            "\t\t\t\t]\n" ..
            "\t\t\t},\n" ..
            "\t\t},\n" ..
            "\t\t{\n" ..
            "\t\t\t\"label\": \"Clean build folder\",\n" ..
            "\t\t\t\"type\": \"shell\",\n" ..
            "\t\t\t\"group\": \"none\",\n" ..
            "\t\t\t\"linux\": {\n" ..
            "\t\t\t\t\"command\": \"rm\",\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"-rf\",\n" ..
            "\t\t\t\t\t\"Build\",\n" ..
            "\t\t\t\t\t\";\",\n" ..
            "\t\t\t\t\t\"echo\",\n" ..
            "\t\t\t\t\t\"Cleaning Build folder\"\n" ..
            "\t\t\t\t]\n" ..
            "\t\t\t},\n" ..
            "\t\t\t\"windows\": {\n" ..
            "\t\t\t\t\"command\": \"rd\",\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"/s\",\n" ..
            "\t\t\t\t\t\"/q\",\n" ..
            "\t\t\t\t\t\"Build\",\n" ..
            "\t\t\t\t\t\";\",\n" ..
            "\t\t\t\t\t\"echo\",\n" ..
            "\t\t\t\t\t\"Cleaning Build folder\"\n" ..
            "\t\t\t\t]\n" ..
            "\t\t\t}\n" ..
            "\t\t},\n" ..
            "\t\t{\n" ..
            "\t\t\t\"label\": \"Build\",\n" ..
            "\t\t\t\"type\": \"shell\",\n" ..
            "\t\t\t\"group\": \"build\",\n" ..
            "\t\t\t\"dependsOn\": [\n" ..
            "\t\t\t\t\"Generate build files\"\n" ..
            "\t\t\t],\n" ..
            "\t\t\t\"linux\": {\n" ..
            "\t\t\t\t\"command\": \"make\",\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"-C\",\n" ..
            "\t\t\t\t\t\"Generated\",\n" ..
            "\t\t\t\t\t\"config=${input:buildConfig}\"\n" ..
            "\t\t\t\t]\n" ..
            "\t\t\t},\n" ..
            "\t\t\t\"windows\": {\n" ..
            "\t\t\t\t\"command\": \"msbuild\",\n" ..
            "\t\t\t\t\"args\": [\n" ..
            "\t\t\t\t\t\"Generated/" .. workspaceName .. ".sln\",\n" ..
            "\t\t\t\t\t\"/m\",\n" ..
            "\t\t\t\t\t\"/property:Configuration=${input:buildConfig}\",\n" ..
            "\t\t\t\t\t\"/property:GenerateFullPaths=true\",\n" ..
            "\t\t\t\t\t\"/t:build\"\n" ..
            "\t\t\t\t],\n" ..
            "\t\t\t\t\"problemMatcher\": \"$msCompile\"\n" ..
            "\t\t\t},\n" ..
            "\t\t},\n" ..
            "\t],\n" ..
            "\t\"inputs\": [\n" ..
            "\t\t{\n" ..
            "\t\t\t\"id\": \"buildConfig\",\n" ..
            "\t\t\t\"description\": \"Select build config\",\n" ..
            "\t\t\t\"default\": \"" .. configurations[1] .."\",\n" ..
            "\t\t\t\"type\": \"pickString\",\n" ..
            "\t\t\t\"options\": ["
        )

        for index, config in pairs(configurations) do
            tasksFile:write("\"" .. config .. "\",")
        end
        
        tasksFile:write(
            " ]\n" ..
            "\t\t}\n" ..
            "\t]\n" ..
            "}"
        )
        tasksFile:close()

        launchFile = io.open(".vscode/launch.json", "w")
        launchFile:write(
            "{\n" ..
            "\t\"version\": \"0.2.0\",\n" ..
            "\t\"configurations\":[\n"
        )

        for index, name in pairs(projectNames) do
            if operatingSystem == "windows" then
                winLaunch(name, launchFile)
            elseif operatingSystem == "linux" then
                linLaunch(name, launchFile)
            end
        end
        launchFile:write("\t],\n")

        launchFile:write("\n}")
        launchFile:close()
    end
}