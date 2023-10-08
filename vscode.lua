require "vscodeTasks"
local p = premake

p.modules.vscode = {}
p.modules.vscode._VERSION = p._VERSION

local vscode = p.modules.vscode
local projects = {}
local projectOptions = ""
local configurations = {}
local configurationOptions = ""
local platforms = {}
local platformOptions = ""
local operatingSystem = ""

newaction {
    trigger = "vscode",
    description = "Generate vscode tasks",

    onWorkspace = function(wrk)
        operatingSystem = wrk.system
        for index, c in ipairs(wrk.configurations) do
            if #configurations == 0 then
                configurationOptions = configurationOptions .. [["]] .. c .. [["]]
            else
                configurationOptions = configurationOptions .. [[, "]] .. c ..[["]]
            end
            table.insert(configurations, c)
        end

        for index, p in ipairs(wrk.platforms) do
            if #platforms == 0 then
                platformOptions = platformOptions .. [["]] .. p .. [["]]
            else
                platformOptions = platformOptions .. [[, "]] .. p ..[["]]
            end
            table.insert(platforms, p)
        end
    end,

    onProject = function(prj)
        if prj.kind == 'ConsoleApp' or prj.kind == 'WindowedApp' then
            if #projects == 0 then
                projectOptions = projectOptions .. [["]] .. prj.name .. [["]]
            else
                projectOptions = projectOptions .. [[, "]] .. prj.name ..[["]]
            end
            table.insert(projects, prj.name)
        end
    end,

    execute = function()
        file = io.open(".vscode/launch.json", "w")
        io.output(file)
        if operatingSystem == 'windows' then
            io.write(winLaunch(projects[1], projectOptions, configurations, platforms))
        elseif operatingSystem == 'linux' then
            io.write(linLaunch(projects[1], projectOptions, configurations, platforms))
        end
        io.close(file)

        file = io.open(".vscode/tasks.json", "w")
        io.output(file)
        if operatingSystem == 'windows' then
            io.write(winTasks(configurations[1], configurationOptions, platforms[1], platformOptions))
        elseif operatingSystem == 'linux' then
            io.write(linTasks(configurations[1], configurationOptions, platforms[1], platformOptions))
        end
        io.close(file)
    end
}

return vscode