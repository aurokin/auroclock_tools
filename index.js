const fs = require('node:fs/promises');
const path = require('node:path');

const projects = [
    {
        name: "AuroclockTools",
        files: [
            {
                input: ["/init/start.lua", "/init/versionChecking.lua", "/init/general.lua", "/init/utility.lua", "/init/mplus.lua", "/init/end.lua"],
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
        files: [
            {
                input: ["/weakauras/keystoneReporter/init.lua"],
                output: "init.lua",
            }, {
                input: ["/weakauras/keystoneReporter/trigger.lua"],
                output: "trigger.lua",
            }

        ]
    }
]

const readFile = async (file) => {
    // Input string path
    const filePath = path.join(__dirname, file);
    const fileData = await fs.readFile(filePath);
    // Output file values
    return fileData;
}

const buildProjects = async () => {
    for await (const project of projects) {
        await buildProject(project);
    }
}

const buildProject = async (project) => {
    for await (const target of project.files) {
        await buildLua(target, project.name);
    }
}

const buildLua = async (target, projectName) => {
    // Build File
    const data = [];
    for await (const file of target.input) {
        const fileData = await readFile(file);
        data.push(fileData);
    }
    const dataStr = data.join("\n\n");

    // Create build directory if it doesn't exist
    const buildDir = path.join(__dirname, "/build");
    await makeDirectoryIfItDoesntExist(buildDir);

    // Create project directory if it doesn't exist
    const projectDir = path.join(buildDir, projectName);
    await makeDirectoryIfItDoesntExist(projectDir);

    // Output to build directory
    const targetPath = path.join(projectDir, target.output);
    await fs.writeFile(targetPath, dataStr);
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