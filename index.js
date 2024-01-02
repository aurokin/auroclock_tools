const fs = require('node:fs/promises');
const path = require('node:path');

const init = {
    filename: "init.lua",
    files: ["/init/init.lua"],
}

const trigger = {
    filename: "trigger.lua",
    files: ["/trigger/trigger.lua"],
}

const readFile = async (file) => {
    // Input string path
    const filePath = path.join(__dirname, file);
    const fileData = await fs.readFile(filePath);
    // Output file values
    return fileData;
}

const buildLua = async (target) => {
    // Build File
    const data = [];
    for await (const file of target.files) {
        const fileData = await readFile(file);
        data.push(fileData);
    }
    const dataStr = data.join("\n\n");

    // Create build directory if it doesn't exist
    const buildDir = path.join (__dirname, "/build")
    let buildDirExists = false;
    try {
        await fs.access(buildDir);
        buildDirExists = true;
    } catch {
        buildDirExists = false;
    }
    
    if (!buildDirExists) {
        await fs.mkdir(buildDir);
    }

    // Output to build directory
    const targetPath = path.join(buildDir, target.filename);
    await fs.writeFile(targetPath, dataStr);
}

buildLua(init);
buildLua(trigger);