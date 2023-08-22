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

newaction {
    trigger = "vscode",
    description = "Generate vscode tasks",

    onWorkspace = function(wrk)

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

io.write([[{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch (VS2022)",
            "program": "${workspaceFolder}\\Build\\bin\\${input:buildProject}\\${input:buildProject}.exe",
            "type": "cppvsdbg",
            "request": "launch",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "console": "externalTerminal"
        }
    ],
    "inputs": [
        {
            "id": "buildProject",
            "description": "Select project to launch: ",
            "default": "]] .. projects[1] .. [[",
            "type": "pickString",
            "options": []] .. projectOptions .. [[]
        }
    ]
}]])
        io.close(file)

        file = io.open(".vscode/tasks.json", "w")
        io.output(file)

io.write([[
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Clean Build folder",
            "type": "shell",
            "group": "none",
            "windows": {
                "command": "Remove-Item",
                "args": [
                    "build",
                    "-Recurse",
                    "-Force",
                    "-Confirm:$false",
                    ";",
                    "echo",
                    "Cleaning Build folder."
                ]
            },
            "problemMatcher": []
        },
        {
            "label": "Generate build files (VS2022)",
            "type": "shell",
            "group": "none",
            "command": "premake5 vs2022",
            "problemMatcher": []
        },
        {
            "dependsOn": [
                "Generate build files (VS2022)",
                "Clean Build folder"
            ],
            "label": "Build (VS2022)",
            "type": "shell",
            "command": "msbuild",
            "args": [
                "${workspaceFolderBaseName}.sln",
                "/m",
                "/property:Configuration=${input:buildConfigVS2022}",
                "/property:Platform=${input:buildPlatformVS2022}",
                "/property:GenerateFullPaths=true",
                "/t:build"
            ],
            "presentation": {
                "reveal": "silent"
            },
            "problemMatcher": "$msCompile"
        },
        {
            "dependsOn": [
                "Build (VS2022)"
            ],
            "label": "Run unit tests",
            "command": "Build\\bin\\Testing\\Testing.exe",
            "group": {
                "kind": "build",
                "isDefault": true
            },
        }
    ],
    "inputs": [
        {
            "id": "buildConfigVS2022",
            "description": "Select build config for VS2022",
            "default": "]] .. configurations[1] .. [[",
            "type": "pickString",
            "options": []] .. configurationOptions .. [[]
        },
        {
            "id": "buildPlatformVS2022",
            "description": "Select build platform for VS2022:",
            "default": "]] .. platforms[1] .. [[",
            "type": "pickString",
            "options": []] .. platformOptions .. [[]
        }
    ]
}]])
    io.close(file)
    end
}

return vscode