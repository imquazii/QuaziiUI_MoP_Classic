local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")

function QuaziiUI:importCellProfile()
    local F = Cell.funcs

    local importString = self.imports.Cell.data

    local version, data = string.match(importString, "^!CELL:(%d+):ALL!(.+)$")
    version = tonumber(version)

    if version and data then
        if version >= Cell.MIN_VERSION and version <= Cell.versionNum then
            local success
            local imported = {}
            local ignoredIndices = {}

            data = LibDeflate:DecodeForPrint(data) -- decode
            success, data = pcall(LibDeflate.DecompressDeflate, LibDeflate, data) -- decompress
            success, data = Serializer:Deserialize(data) -- deserialize

            if success and data then
                imported = data
                -- raid debuffs

                for instanceID in pairs(imported["raidDebuffs"]) do
                    if not Cell.snippetVars.loadedDebuffs[instanceID] then
                        imported["raidDebuffs"][instanceID] = nil
                    end
                end

                -- deal with invalid
                if Cell.isRetail then
                    imported["appearance"]["useLibHealComm"] = false
                end

                -- layouts
                local builtInFound = {}
                for _, layout in pairs(imported["layouts"]) do
                    -- indicators
                    for i = #layout["indicators"], 1, -1 do
                        if layout["indicators"][i]["type"] == "built-in" then -- remove unsupported built-in
                            local indicatorName = layout["indicators"][i]["indicatorName"]
                            builtInFound[indicatorName] = true
                            if not Cell.defaults.indicatorIndices[indicatorName] then
                                tremove(layout["indicators"], i)
                            end
                        else -- remove invalid spells from custom indicators
                            F:FilterInvalidSpells(layout["indicators"][i]["auras"])
                        end
                    end
                    -- powerFilters
                    if Cell.flavor ~= imported.flavor then
                        layout.powerFilters = F:Copy(Cell.defaults.layout.powerFilters)
                    end
                end

                -- add missing indicators
                if F:Getn(builtInFound) ~= Cell.defaults.builtIns then
                    for indicatorName, index in pairs(Cell.defaults.indicatorIndices) do
                        if not builtInFound[indicatorName] then
                            for _, layout in pairs(imported["layouts"]) do
                                tinsert(layout["indicators"], index, Cell.defaults.layout.indicators[index])
                            end
                        end
                    end
                end

                -- click-castings
                local clickCastings
                if Cell.isRetail then -- RETAIL -> RETAIL
                    clickCastings = imported["clickCastings"]
                end
                imported["clickCastings"] = nil

                -- layout auto switch
                local layoutAutoSwitch
                if imported["layoutAutoSwitch"] then
                    if Cell.isRetail then -- RETAIL -> RETAIL
                        layoutAutoSwitch = imported["layoutAutoSwitch"]
                    else -- RETAIL -> WRATH
                        layoutAutoSwitch = nil
                    end
                    imported["layoutAutoSwitch"] = nil
                end

                -- remove characterDB
                imported["characterDB"] = nil

                -- remove invalid spells
                F:FilterInvalidSpells(imported["debuffBlacklist"])
                F:FilterInvalidSpells(imported["bigDebuffs"])
                F:FilterInvalidSpells(imported["actions"])
                F:FilterInvalidSpells(imported["customDefensives"])
                F:FilterInvalidSpells(imported["customExternals"])
                F:FilterInvalidSpells(imported["targetedSpellsList"])

                --! overwrite
                if Cell.isRetail then
                    if not ignoredIndices["clickCastings"] then
                        CellDB["clickCastings"] = clickCastings
                    end
                    if not ignoredIndices["layouts"] then
                        CellDB["layoutAutoSwitch"] = layoutAutoSwitch
                    end
                end

                for k, v in pairs(imported) do
                    CellDB[k] = v
                end
            end
        end
    end
end
