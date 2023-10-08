-- Windows

function winLaunch(projects, projectOptions, configurations, platforms)
    -- determine possible builds
    local options = "";
    for _, c in ipairs(configurations) do
        for _, p in ipairs(platforms) do
            if options == "" then
                options = options .. [["]] .. string.lower(c) .. [[_]] .. string.lower(p) .. [["]]
            else
                options = options .. [[, "]] .. string.lower(c) .. [[_]] .. string.lower(p) .. [["]]
            end
        end
    end
return 
[[{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch (VS2022)",
            "program": "${workspaceFolder}\\Build\\${input:buildConfig}\\bin\\${input:buildProject}\\${input:buildProject}.exe",
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
            "default": "]] .. projects .. [[",
            "type": "pickString",
            "options": []] .. projectOptions .. [[]
        },
        {
            "id": "buildConfig",
            "description": "Select build config for",
            "default": "]] .. string.lower(configurations[1]) .. "_" .. string.lower(platforms[1]) .. [[",
            "type": "pickString",
            "options": []] .. options .. [[]
        }
    ]
}]]
end

function winTasks(configuration, configurationOptions, platform, platformOptions)
return
[[
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
                    "/property:Configuration=${input:buildConfig}",
                    "/property:Platform=${input:buildPlatform}",
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
                "command": "Build\\${input:buildConfig}_${input:buildPlatform}\\bin\\UnitTests\\UnitTests.exe",
                "group": {
                    "kind": "build",
                    "isDefault": true
                },
            }
        ],
        "inputs": [
            {
                "id": "buildConfig",
                "description": "Select build config for",
                "default": "]] .. string.lower(configuration) .. [[",
                "type": "pickString",
                "options": []] .. string.lower(configurationOptions) .. [[]
            },
            {
                "id": "buildPlatform",
                "description": "Select build platform for :",
                "default": "]] .. string.lower(platform) .. [[",
                "type": "pickString",
                "options": []] .. string.lower(platformOptions) .. [[]
            }
        ]
}]]
end

-- Linux
function linLaunch(projects, projectOptions, configurations, platforms)
    -- determine possible builds
    local options = "";
    for _, c in ipairs(configurations) do
        for _, p in ipairs(platforms) do
            if options == "" then
                options = options .. [["]] .. string.lower(c) .. [[_]] .. string.lower(p) .. [["]]
            else
                options = options .. [[, "]] .. string.lower(c) .. [[_]] .. string.lower(p) .. [["]]
            end
        end
    end
return
    [[
        {
            "version": "0.2.0",
            "configurations": [
                {
                "name": "Debug MyProject",
                "type": "cppdbg",
                "request": "launch",
                "program": "${workspaceFolder}\\Build\\${input:buildConfig}\\bin\\${input:buildProject}\\${input:buildProject}",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${workspaceFolder}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "setupCommands": [
                    {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                    }
                ],
                "miDebuggerPath": "/usr/bin/gdb"
                }
            ],
            "inputs": [
                {
                    "id": "buildProject",
                    "description": "Select project to launch: ",
                    "default": "]] .. projects .. [[",
                    "type": "pickString",
                    "options": []] .. projectOptions .. [[]
                },
                {
                    "id": "buildConfig",
                    "description": "Select build config for",
                    "default": "]] .. string.lower(configurations[1]) .. "_" .. string.lower(platforms[1]) .. [[",
                    "type": "pickString",
                    "options": []] .. options .. [[]
                }
            ]
        }
    ]]
          
end
    
function linTasks(configuration, configurationOptions, platform, platformOptions)
    return
    [[
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
                    "label": "Generate build files (Gmake2)",
                    "type": "shell",
                    "group": "none",
                    "command": "premake5 gmake2",
                    "problemMatcher": []
                },
              {
                "dependsOn": [
                    "Generate build files (Gmake2)",
                    "Clean Build folder"
                ],
                "label": "Build (gmake2)",
                "type": "shell",
                "command": "make config=${input:buildConfig}_${input:buildPlatform}",
                "args": [],
                "group": {
                  "kind": "build"
                },
                "presentation": {
                  "reveal": "always",
                  "panel": "new"
                }
              },
              {
                "dependsOn": [
                    "Build (gmake2)"
                ],
                "label": "Run unit tests",
                "command": "./Build/${input:buildConfig}_${input:buildPlatform}/bin/UnitTests/UnitTests",
                "group": {
                    "kind": "build",
                    "isDefault": true
                },
            }
            ],
            "inputs": [
                {
                    "id": "buildConfig",
                    "description": "Select build config for",
                    "default": "]] .. string.lower(configuration) .. [[",
                    "type": "pickString",
                    "options": []] .. string.lower(configurationOptions) .. [[]
                },
                {
                    "id": "buildPlatform",
                    "description": "Select build platform for :",
                    "default": "]] .. string.lower(platform) .. [[",
                    "type": "pickString",
                    "options": []] .. string.lower(platformOptions) .. [[]
                }
            ]
          }
          
    ]]
    end