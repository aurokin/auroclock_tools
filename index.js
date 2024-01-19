const fs = require('node:fs/promises');
const path = require('node:path');

const buildSpellDatabase = require("./spellDatabase/parse.js");

// Project Data
const projects = [
    {
        name: "AuroclockTools",
        type: "WA",
        files: [
            {
                input: ["/init/init.lua"],
                output: "init.lua"
            },
            {
                input: ["/trigger/trigger.lua"],
                output: "trigger.lua"
            }
        ]
    },
    {
        name: "KeystoneReporter",
        type: "WA",
        files: [
            {
                input: ["/weakauras/keystoneReporter/init.lua"],
                output: "init.lua",
            }, {
                input: ["/weakauras/keystoneReporter/trigger.lua"],
                output: "trigger.lua",
            }

        ]
    },  
    {
        name: "FocusHelper",
        type: "WA",
        files: [
            {
                input: ["/weakauras/focusHelper/init.lua"],
                output: "init.lua",
            }, {
                input: ["/weakauras/focusHelper/trigger.lua"],
                output: "trigger.lua",
            }

        ]
    },
    {
        name: "TargetCastbar",
        type: "WA",
        files: [
            {
                input: ["/weakauras/castbar/target/init.lua"],
                output: "init.lua",
            }, {
                input: ["/weakauras/castbar/target/trigger.lua"],
                output: "trigger.lua",
            }

        ]
    },
    {
        name: "FocusCastbar",
        type: "WA",
        files: [
            {
                input: ["/weakauras/castbar/focus/init.lua"],
                output: "init.lua",
            }, {
                input: ["/weakauras/castbar/focus/trigger.lua"],
                output: "trigger.lua",
            }

        ]
    },
    {
        name: "FormatName",
        type: "Plater",
        files: [{
            input: ["/plater/formatName/init.lua"],
            output: "init.lua",
        }, {
            input: ["/plater/formatName/added.lua"],
            output: "added.lua",
        }, {
            input: ["/plater/formatName/created.lua"],
            output: "created.lua",
        }, {
            input: ["/plater/formatName/updated.lua"],
            output: "updated.lua",
        }, {
            input: ["/plater/formatName/nameUpdated.lua"],
            output: "nameUpdated.lua",
        }]
    },     {
        name: "FormatBorder",
        type: "Plater",
        files: [{
            input: ["/plater/formatBorder/init.lua"],
            output: "init.lua",
        }, {
            input: ["/plater/formatBorder/added.lua"],
            output: "added.lua",
        }, {
            input: ["/plater/formatBorder/created.lua"],
            output: "created.lua",
        }, {
            input: ["/plater/formatBorder/updated.lua"],
            output: "updated.lua",
        }, {
            input: ["/plater/formatBorder/targetChanged.lua"],
            output: "targetChanged.lua",
        }]
    }
]

// Build Functions
const buildProjects = async () => {
    console.log("Building AuroclockTools!\n")

    // Spell Database
    const lua = await buildSpellDatabase();
    await saveLua(lua, "SpellDatabase", "LuaData", "db.lua");  
    console.log(`\n`);

    // WeakAuras
    for await (const project of projects) {
        await buildProject(project);
    }

    console.log("Done!");
}

const buildProject = async (project) => {
    console.log(`- ${project.name}`);
    for await (const target of project.files) {
        await buildLua(target, project.name, project.type);
    }

    console.log("\n");
}

const buildLua = async (target, projectName, type) => {
    // Build File
    const data = [];
    for await (const file of target.input) {
        const fileData = await readFile(file);
        const compiledFile = await compileFile(fileData);
        data.push(compiledFile);
    }
    const lua = data.join("\n\n");

    await saveLua(lua, projectName, type, target.output);
}

const saveLua = async (lua, projectName, type, fileName) => {
    // Create build directory if it doesn't exist
    const buildDir = path.join(__dirname, "/build");
    await makeDirectoryIfItDoesntExist(buildDir);

    // Create project directory if it doesn't exist
    const projectDir = path.join(buildDir, `${type}-${projectName}`);
    await makeDirectoryIfItDoesntExist(projectDir);

    // Output to build directory
    const targetPath = path.join(projectDir, fileName);
    await fs.writeFile(targetPath, lua);

    console.log(`-- ${fileName}`);
}

// Logic Functions
const compileFile = async (fileData) => {
    // (?<=-- #\?# ).*
    const prefix = "-- #\?#";
    const regex = /(?<=-- #\?# ).*/g;
    const snippets = fileData.match(regex);

    const pairs = [];

    if (Array.isArray(snippets)) {
        for await (const snippetPath of snippets) {
            const snippet = await readFile(snippetPath);
            const snippetTag = `${prefix} ${snippetPath}`;
            pairs.push({ snippet, snippetTag });
        }
    }

    let newFileData = fileData;
    pairs.forEach(({ snippet, snippetTag }) => {
        newFileData = newFileData.replace(snippetTag, snippet);
    })

    return newFileData;
}

// IO Functions
const readFile = async (file) => {
    // Input string path
    const filePath = path.join(__dirname, file);
    const fileData = await fs.readFile(filePath, { encoding: 'utf8' });

    // Output file values
    return fileData;
}

const makeDirectoryIfItDoesntExist = async (path) => {
    // Create build directory if it doesn't exist
    let dirExists = false;
    try {
        await fs.access(path);
        dirExists = true;
    } catch(e) {
        dirExists = false;
    }
    
    if (!dirExists) {
        await fs.mkdir(path);
    }
}

buildProjects();