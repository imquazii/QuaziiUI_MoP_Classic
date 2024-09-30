local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local pageIndex = #addon.pagePrototypes
local function updateDisplay()
    if QuaziiUIDB and QuaziiUIDB.imports.OmniCD then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.OmniCD.date))
        page.lastVersion:SetText(QuaziiUIDB.imports.OmniCD.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
    DF:ShowPromptPanel("Are you sure you want to import/update OmniCD profile?",
                       function()
        QuaziiUIDB.imports.OmniCD = {}
        QuaziiUIDB.imports.OmniCD.date = GetServerTime()
        QuaziiUIDB.imports.OmniCD.version = addon.version
        local OmniCD = OmniCD[1]
        local Profile = OmniCD.ProfileSharing
        local profileType, profileKey, profileData = Profile:Decode(
                                                         addon.imports.OmniCD["data"])
        Profile:CopyProfile(profileType, profileKey, profileData)
        QuaziiUICDB.openPage = pageIndex
        ReloadUI()
    end, function() end, true)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "OmniCD import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can import/update your OmniCD profile if you wish!"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = addon:CreateImportFrame(frame, "OmniCD", "OmniCD",
                                                    "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiOmniCD.png",
                                                    460, 201, importProfile)
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
