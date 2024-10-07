---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
local pageIndex = #QUI.pagePrototypes
local function updateDisplay()
    if QuaziiUI_DB and QuaziiUI_DB.imports.Plater then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.Plater.date))
        page.lastVersion:SetText(QuaziiUI_DB.imports.Plater.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
    DF:ShowTextPromptPanel("Insert a Name for the New Plater Profile:",
                           function(newProfileName)
        QuaziiUI_DB.imports.Plater = {}
        QuaziiUI_DB.imports.Plater.date = GetServerTime()
        QuaziiUI_DB.imports.Plater.version = QUI.version
        Plater.OpenOptionsPanel()
        PlaterOptionsPanelFrame:Hide()
        local profileFrame = PlaterOptionsPanelContainer.AllFrames[22]
        profileFrame.ImportStringField.importDataText =
            QUI.imports.Plater["data"]
        profileFrame.NewProfileTextEntry:SetText(newProfileName)
        QuaziiUI_CDB.openPage = pageIndex
        updateDisplay()
        profileFrame.ConfirmImportProfile()
    end, function() end, true)
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      "Plater import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your Plater profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = QUI:CreateImportFrame(frame, "Plater", "Plater",
                                                  nil, nil, nil, importProfile)
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
