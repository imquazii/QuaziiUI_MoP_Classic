local addonName, QUI = ...
local DF = _G["DetailsFramework"]
QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
local pageIndex = #QUI.pagePrototypes
local function updateDisplay()
    if QuaziiUI_DB and QuaziiUI_DB.imports.BigWigs then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUI_DB.imports.BigWigs.date))
        page.lastVersion:SetText(QuaziiUI_DB.imports.BigWigs.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
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
            ReloadUI()
        end
    end)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      "BigWigs import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your BigWigs profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = QUI:CreateImportFrame(frame, "BigWigs", "BigWigs",
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
