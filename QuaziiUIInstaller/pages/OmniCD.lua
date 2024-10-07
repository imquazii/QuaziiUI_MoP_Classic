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
    if QuaziiUI_DB and QuaziiUI_DB.imports.OmniCD then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.OmniCD.date))
        page.lastVersion:SetText(QuaziiUI_DB.imports.OmniCD.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
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
        ReloadUI()
    end, function() end, true)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local detailsHeader = DF:CreateLabel(frame,
                                         "|c" .. QUI.highlightColorHex ..
                                             "OmniCD import:|r", 18)
    detailsHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -20)
    detailsHeader:SetPoint("TOPRIGHT", frame, "TOP", -5, -20)
    detailsHeader:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your OmniCD profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", detailsHeader, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = QUI:CreateImportFrame(frame, "OmniCD", "OmniCD",
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
