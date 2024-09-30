local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local pageIndex = #addon.pagePrototypes
local function updateDisplay()
    if QuaziiUIDB and QuaziiUIDB.imports.BigWigs then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.BigWigs.date))
        page.lastVersion:SetText(QuaziiUIDB.imports.BigWigs.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
    local profileName = "QuaziiUI"
    BigWigsAPI:ImportProfileString(addonName, addon.imports.BigWigs.data,
                                   profileName, function(accepted)
        if accepted then
            QuaziiUIDB.imports.BigWigs = {}
            QuaziiUIDB.imports.BigWigs.date = GetServerTime()
            QuaziiUIDB.imports.BigWigs.version = addon.version
            QuaziiUICDB.openPage = pageIndex
            BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles =
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles or {}
            BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles[profileName] =
                addon.imports.BigWigsColors
            ReloadUI()
        end
    end)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "BigWigs import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your BigWigs profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = addon:CreateImportFrame(frame, "BigWigs", "BigWigs",
                                                    "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiBigwigs.png",
                                                    223, 115, importProfile)
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
