const fs = require('node:fs');
const path = require('node:path');

const csv = require('csv-parse');

const buildSpellDatabase = async () => {
    console.log(`- Spell Database`);

    const mobs = await getMobs();
    const lua = mobsToLua(mobs);

    return lua;
}

const getMobs = async () => {
    const parser = fs.createReadStream(path.join(__dirname, "db.csv")).pipe(csv.parse({ 
        columns: true,
    }));

    const mobs = {};
    for await (const record of parser) {
        // Work with each record
        const spell = {
            // spellName: record['Spell Name'],
            spellId: Number.parseInt(record['Spell ID']),
            npcId: Number.parseInt(record['NPC ID']),
            // npcName: record['NPC Name'],
            // npcDungeon: record['NPC Dungeon'],
            interruptible: record['Interruptible'] === 'TRUE',
            emphasizedInterrupt: record['Important Interrupt'] === 'TRUE',
            stoppable: record['Stoppable'] === 'TRUE',
            emphasizedStoppable: record['Important Stoppable'] === 'TRUE',
        };

        if (typeof mobs[spell.npcId] === "undefined") {
            mobs[spell.npcId] = {};
        }

        mobs[spell.npcId][spell.spellId] = spell;
    }

    return mobs;
}

const mobsToLua = (mobs) => {
    const mobNpcsParsed = [];
    const mobSpellsParsed = [];
    for (const [mobId, mobSpells] of Object.entries(mobs)) {
        const props = {
            interruptible: false,
            emphasizedInterrupt: false,
            stoppable: false,
            emphasizedStoppable: false,
        }

        for (const [spellId, spellInfo] of Object.entries(mobSpells)) {
            const spellLines = [];
            for (const [key, value] of Object.entries(spellInfo)) {
                for (const [propKey, _] of Object.entries(props)) {
                    if (key === propKey && value === true) {
                        props[propKey] = true;
                    }
                }

                const valueLine = typeof value === "string" ? `"${value}"`: value;
                const spellLine = `["${key}"]=${valueLine}`;

                if ((typeof value === "boolean" && value === true) || typeof value !== "boolean") {
                    spellLines.push(spellLine);
                }
            }
            const spellLinesParsed = `[${spellInfo.spellId}]={${spellLines.join(",")}}`;
            mobSpellsParsed.push(spellLinesParsed);
        }

        const propsStr = Object.entries(props).filter(([key, value]) => value === true).map(([key, value]) => `["${key}"]=${value}`).join(",");
        mobNpcsParsed.push(`[${mobId}]={${propsStr}}`);
    }
      
    const lua = `AuroclockTools.Data.MPlusNpcDb={${mobNpcsParsed.join(',')}};\nAuroclockTools.Data.MPlusSpellDb={${mobSpellsParsed.join(',')}};`;

    return lua;
}

module.exports = buildSpellDatabase;