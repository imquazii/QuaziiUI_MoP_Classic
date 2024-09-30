local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local pageIndex = #addon.pagePrototypes
local function updateDisplay()
    if QuaziiUIDB and QuaziiUIDB.imports.Details then
        page.lastImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.Details.date))
        page.lastVersion:SetText(QuaziiUIDB.imports.Details.version)
    else
        page.lastImportTime:SetText("N/A")
        page.lastVersion:SetText("N/A")
    end
end
local function importProfile(self)
    DF:ShowTextPromptPanel("Insert a Name for the New Details Profile:",
                           function(newProfileName)
        QuaziiUIDB.imports.Details = {}
        QuaziiUIDB.imports.Details.date = GetServerTime()
        QuaziiUIDB.imports.Details.version = addon.version
        Details:ImportProfile(addon.imports.Details["data"], newProfileName)
        updateDisplay()
    end, function() end, true)
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "Details! import:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString = ""
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importContainer = addon:CreateImportFrame(frame, "Details", "Details",
                                                    "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiDetails.png",
                                                    178, 274, importProfile)
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
