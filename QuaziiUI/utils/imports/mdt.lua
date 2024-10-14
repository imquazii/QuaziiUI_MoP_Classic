function QuaziiUI:importMDTRoute(preset)
    -- if MDT addon isn't present, GTFO
    -- if MDT isn't initialized, GTFO
    if not MDT then
        return
    end
    if not MythicDungeonToolsDB and MythicDungeonToolsDB.global then
        return
    end

    local fromLiveSession = false
    local currentDungeonIdx = preset.value.currentDungeonIdx
    -- change dungeon to dungeon of the new preset
    -- QUI Change: Set Init to true so it doesn't require MDT.main_frame
    MDT:UpdateToDungeon(preset.value.currentDungeonIdx, true, true)

    --search for uid, basically checking if route is already imported
    local updateIndex
    local duplicatePreset
    for k, v in pairs(MythicDungeonToolsDB.global.presets[currentDungeonIdx]) do
        if v.uid and v.uid == preset.uid then
            updateIndex = k
            duplicatePreset = v
            break
        end
    end

    local updateCallback = function()
        MythicDungeonToolsDB.global.presets[currentDungeonIdx][updateIndex] = preset
        MythicDungeonToolsDB.global.currentPreset[currentDungeonIdx] = updateIndex
    end
    local copyCallback = function()
        local name = preset.text
        local num = 2
        for k, v in pairs(MythicDungeonToolsDB.global.presets[currentDungeonIdx]) do
            if name == v.text then
                name = preset.text .. " " .. num
                num = num + 1
            end
        end
        preset.text = name
        if fromLiveSession then
            if duplicatePreset then
                duplicatePreset.uid = nil
            end
        else
            if not preset.uid then
                preset.uid = nil
                MDT:SetUniqueID(preset)
            end
        end
        local countPresets = 0
        for k, v in pairs(MythicDungeonToolsDB.global.presets[currentDungeonIdx]) do
            countPresets = countPresets + 1
        end
        MythicDungeonToolsDB.global.presets[currentDungeonIdx][countPresets + 1] =
            MythicDungeonToolsDB.global.presets[currentDungeonIdx][countPresets] --put <New Preset> at the end of the list
        MythicDungeonToolsDB.global.presets[currentDungeonIdx][countPresets] = preset
        MythicDungeonToolsDB.global.currentPreset[currentDungeonIdx] = countPresets
    end

    --open dialog to ask for replacing
    if updateIndex then
        updateCallback()
    else
        copyCallback()
    end
    if MDT.main_frame then
        MDT:UpdateToDungeon(currentDungeonIdx, true, true)
        MDT:UpdatePresetDropDown()
        MDT:UpdateMap()
    end
end
