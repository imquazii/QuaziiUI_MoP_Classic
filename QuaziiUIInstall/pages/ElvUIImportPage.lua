local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local pageIndex = #addon.pagePrototypes
local function updateDisplay()
    if QuaziiUIDB and QuaziiUIDB.imports.ElvUIHeals then
        page.lastHImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.ElvUIHeals.date))
        page.lastHVersion:SetText(QuaziiUIDB.imports.ElvUIHeals.version)
    else
        page.lastHImportTime:SetText("N/A")
        page.lastHVersion:SetText("N/A")
    end
    if QuaziiUIDB and QuaziiUIDB.imports.ElvUIHealsCell then
        page.lastHCImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.ElvUIHealsCell.date))
        page.lastHCVersion:SetText(QuaziiUIDB.imports.ElvUIHealsCell.version)
    else
        page.lastHCImportTime:SetText("N/A")
        page.lastHCVersion:SetText("N/A")
    end
    if QuaziiUIDB and QuaziiUIDB.imports.ElvUITank then
        page.lastTImportTime:SetText(date("%m/%d/%y",
                                         QuaziiUIDB.imports.ElvUITank.date))
        page.lastTVersion:SetText(QuaziiUIDB.imports.ElvUITank.version)
    else
        page.lastTImportTime:SetText("N/A")
        page.lastTVersion:SetText("N/A")
    end
end
local function importHealerProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Healer ElvUI profile?",
        function()
            QuaziiUIDB.imports.ElvUIHeals = {}
            QuaziiUIDB.imports.ElvUIHeals.date = GetServerTime()
            QuaziiUIDB.imports.ElvUIHeals.version = addon.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(addon.imports.ElvUI.healer.normal.data)
            QuaziiUICDB.openPage = pageIndex
            updateDisplay()
        end, function() end, true)
end
local function importHealerCellProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Healer ElvUI profile?",
        function()
            QuaziiUIDB.imports.ElvUIHealsCell = {}
            QuaziiUIDB.imports.ElvUIHealsCell.date = GetServerTime()
            QuaziiUIDB.imports.ElvUIHealsCell.version = addon.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(addon.imports.ElvUI.healer.cell.data)
            QuaziiUICDB.openPage = pageIndex
            updateDisplay()
        end, function() end, true)
end
local function importTankProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Tank/DPS ElvUI profile?",
        function()
            QuaziiUIDB.imports.ElvUITank = {}
            QuaziiUIDB.imports.ElvUITank.date = GetServerTime()
            QuaziiUIDB.imports.ElvUITank.version = addon.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(addon.imports.ElvUI.tankdps.data)
            QuaziiUICDB.openPage = pageIndex
            updateDisplay()
        end, function() end, true)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "ElvUI import:|r", 24)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString = "Here you can import/update |c" ..
                           addon.colorTextHighlight ..
                           "Quazii's|r ElvUI profile!\n|c" ..
                           addon.colorTextHighlight ..
                           "NOTE:|r If you import multiple profiles, you can switch in ElvUI's Profile Settings"
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local importHealerContainer = addon:CreateImportFrameNoLogo(frame, "ElvUI",
                                                                "Healer",
                                                                importHealerProfile)
    importHealerContainer:SetPoint("CENTER", frame, "LEFT", 155, -100)
    local importHealerCellContainer = addon:CreateImportFrameNoLogo(frame, "ElvUI",
                                                                "Healer (Cell)",
                                                                importHealerCellProfile)
    importHealerCellContainer:SetPoint("CENTER", frame, "RIGHT", -105, -100)
    local importTankContainer = addon:CreateImportFrameNoLogo(frame, "ElvUI",
                                                                "Tank",
                                                                importTankProfile)
    importTankContainer:SetPoint("CENTER", frame, "LEFT", 159, 0)
    page.lastHImportTime = importHealerContainer.lastImportText
    page.lastHCImportTime = importHealerCellContainer.lastImportText
    page.lastTImportTime = importTankContainer.lastImportText
    page.lastHVersion = importHealerContainer.versionText
    page.lastHCVersion = importHealerCellContainer.versionText
    page.lastTVersion = importTankContainer.versionText
    page.rootFrame = frame
end
function page:ShouldShow() return true end
function page:Show()
    updateDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
