local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local pageIndex = #addon.pagePrototypes
local function updateDisplay()
    if QuaziiUIDB and QuaziiUIDB.imports.Plater then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.Plater.date))
        page.lastVersion:SetText(QuaziiUIDB.imports.Plater.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
    DF:ShowTextPromptPanel("Insert a Name for the New Plater Profile:",
                           function(newProfileName)
        QuaziiUIDB.imports.Plater = {}
        QuaziiUIDB.imports.Plater.date = GetServerTime()
        QuaziiUIDB.imports.Plater.version = addon.version
        Plater.OpenOptionsPanel()
        PlaterOptionsPanelFrame:Hide()
        local profileFrame = PlaterOptionsPanelContainer.AllFrames[22]
        profileFrame.ImportStringField.importDataText =
            addon.imports.Plater["data"]
        profileFrame.NewProfileTextEntry:SetText(newProfileName)
        QuaziiUICDB.openPage = pageIndex
        updateDisplay()
        profileFrame.ConfirmImportProfile()
    end, function() end, true)
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "Plater import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your Plater profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = addon:CreateImportFrame(frame, "Plater", "Plater",
                                                    "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiPlater.png",
                                                    482, 148, importProfile)
    importContainer:SetPoint("CENTER", frame, "CENTER", 0, -35)
    page.lastImportTime = importContainer.lastImportText
    page.lastVersion = importContainer.versionText
    page.rootFrame = frame
end
function page:ShouldShow() return true end
function page:Show()
    updateDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
