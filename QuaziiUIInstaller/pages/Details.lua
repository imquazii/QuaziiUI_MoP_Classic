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
    if QuaziiUI_DB and QuaziiUI_DB.imports.Details then
        page.lastDetailsImportTime:SetText(
            date("%m/%d/%y", QuaziiUI_DB.imports.Details.date))
        page.lastDetailsVersion:SetText(QuaziiUI_DB.imports.Details.version)
    else
        page.lastDetailsImportTime:SetText("N/A")
        page.lastDetailsVersion:SetText("N/A")
    end

    if QuaziiUI_DB and QuaziiUI_DB.imports.OmniCD then
        page.lastOmniCDImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.OmniCD.date))
        page.lastOmniCDVersion:SetText(QuaziiUI_DB.imports.OmniCD.version)
    else
        page.lastOmniCDImportTime:SetText("N/A")
        page.lastOmniCDVersion:SetText("N/A")
    end
    if QuaziiUI_DB and QuaziiUI_DB.imports.Plater then
        page.lastPlaterImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.Plater.date))
        page.lastPlaterVersion:SetText(QuaziiUI_DB.imports.Plater.version)
    else
        page.lastPlaterImportTime:SetText("N/A")
        page.lastPlaterVersion:SetText("N/A")
    end

    if QuaziiUI_DB and QuaziiUI_DB.imports.BigWigs then
        page.lastBigWigsImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.BigWigs.date))
        page.lastBigWigsVersion:SetText(QuaziiUI_DB.imports.BigWigs.version)
    else
        page.lastBigWigsImportTime:SetText("N/A")
        page.lastBigWigsVersion:SetText("N/A")
    end
end
local function importDetailsProfile(self)
    DF:ShowTextPromptPanel("Insert a Name for the New Details Profile:",
                           function(newProfileName)
        QuaziiUI_DB.imports.Details = {}
        QuaziiUI_DB.imports.Details.date = GetServerTime()
        QuaziiUI_DB.imports.Details.version = QUI.version
        Details:ImportProfile(QUI.imports.Details.data, newProfileName)
        QuaziiUI_CDB.openPage = pageIndex
        updateDisplay()
    end, function() end, true)
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end

local function importOmniCDProfile(self)
    DF:ShowPromptPanel("Are you sure you want to import/update OmniCD profile?",
                       function()
        QuaziiUI_DB.imports.OmniCD = {}
        QuaziiUI_DB.imports.OmniCD.date = GetServerTime()
        QuaziiUI_DB.imports.OmniCD.version = QUI.version
        local OmniCD = OmniCD[1]
        local Profile = OmniCD.ProfileSharing
        local profileType, profileKey, profileData = Profile:Decode(
                                                         QUI["imports"]["OmniCD"]["data"])
        Profile:CopyProfile(profileType, profileKey, profileData)
        QuaziiUI_CDB.openPage = pageIndex
    end, function() end, true)
end

local function importPlaterProfile(self)
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

local function importBigWigsProfile(self)
    local profileName = "QuaziiUI"
    BigWigsAPI:ImportProfileString(addonName, QUI.imports.BigWigs.data,
                                   profileName, function(accepted)
        if accepted then
            QuaziiUI_DB.imports.BigWigs = {}
            QuaziiUI_DB.imports.BigWigs.date = GetServerTime()
            QuaziiUI_DB.imports.BigWigs.version = QUI.version
            QuaziiUI_CDB.openPage = pageIndex
            BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles =
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles or {}
            BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles[profileName] =
                QUI.imports.BigWigsColors
        end
    end)
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local mainLabel = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                         "Other Addon Imports|r",
                                     QUI.PageHeaderSize)
    mainLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -20)
    mainLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT",-10, -20)
    mainLabel:SetJustifyH("CENTER")
    mainLabel:SetJustifyV("TOP")
    local detailsImportContainer = QUI:CreateImportFrame(frame, "Details",
                                                         "Details", nil, nil,
                                                         nil,
                                                         importDetailsProfile)
    detailsImportContainer:SetPoint("TOPRIGHT", mainLabel.widget, "BOTTOM", -15,
                                    -20)
    local PlaterImportContainer = QUI:CreateImportFrame(frame, "Plater",
                                                        "Plater", nil, nil, nil,
                                                        importPlaterProfile)
    PlaterImportContainer:SetPoint("LEFT", detailsImportContainer, "RIGHT", 30,
                                   0)
    local BigWigsImportContainer = QUI:CreateImportFrame(frame, "BigWigs",
                                                         "BigWigs", nil, nil,
                                                         nil,
                                                         importBigWigsProfile)
    BigWigsImportContainer:SetPoint("TOP", detailsImportContainer, "BOTTOM", 0,
    20)
    local OmniCDImportContainer = QUI:CreateImportFrame(frame, "OmniCD",
                                                         "OmniCD", nil, nil,
                                                         nil,
                                                         importOmniCDProfile)
    OmniCDImportContainer:SetPoint("TOPRIGHT", PlaterImportContainer, "BOTTOMRIGHT", 0,
    20)

    page.lastDetailsImportTime = detailsImportContainer.lastImportText
    page.lastDetailsVersion = detailsImportContainer.versionText
    page.lastBigWigsImportTime = BigWigsImportContainer.lastImportText
    page.lastBigWigsVersion = BigWigsImportContainer.versionText
    page.lastPlaterImportTime = PlaterImportContainer.lastImportText
    page.lastPlaterVersion = PlaterImportContainer.versionText
    page.lastOmniCDImportTime = OmniCDImportContainer.lastImportText
    page.lastOmniCDVersion = OmniCDImportContainer.versionText
    page.rootFrame = frame

end
function page:ShouldShow() return true end
function page:Show()
    updateDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
