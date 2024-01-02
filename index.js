const fs = require('node:fs/promises');
const path = require('node:path');

// Project Data
const projects = [
    {
        name: "AuroclockTools",
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

// Build Functions
const buildProjects = async () => {
    console.log("Building AuroclockTools!\n")
    for await (const project of projects) {
        await buildProject(project);
    }
    console.log("Done!")
}

const buildProject = async (project) => {
    console.log(`- ${project.name}`);
    for await (const target of project.files) {
        await buildLua(target, project.name);
    }

    console.log("\n");
}

const buildLua = async (target, projectName) => {
    // Build File
    console.log(`-- ${target.output}`);
    const data = [];
    for await (const file of target.input) {
        const fileData = await readFile(file);
        const compiledFile = await compileFile(fileData);
        data.push(compiledFile);
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