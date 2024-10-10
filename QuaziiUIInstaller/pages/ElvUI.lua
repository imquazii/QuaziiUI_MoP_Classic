---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local L = QUI.L

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
local pageIndex = #QUI.pagePrototypes

-- Helper Functions
local function updateElvUIDisplay()
    local function updateImportInfo(importType, dateField, versionField)
        if QuaziiUI_DB and QuaziiUI_DB.imports[importType] then
            page[dateField]:SetText(date("%m/%d/%y", QuaziiUI_DB.imports[importType].date))
            page[versionField]:SetText(QuaziiUI_DB.imports[importType].version)
        else
            page[dateField]:SetText(L["NA"])
            page[versionField]:SetText(L["NA"])
        end
    end

    updateImportInfo("ElvUIHeals", "lastHImportTime", "lastHVersion")
    --[[updateImportInfo("ElvUIHealsCell", "lastHCImportTime", "lastHCVersion")]]
    updateImportInfo("ElvUITank", "lastTImportTime", "lastTVersion")
end

local function updateScaleDisplay()
    local currentUIScale
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        currentUIScale = ElvUI[1].global.general.UIScale
    else
        currentUIScale = C_CVar.GetCVar("uiScale")
    end
    page.uiScaleText:SetText("|c" .. QUI.highlightColorHex .. tostring(currentUIScale) .. "|r")
end

local function updateUIScale(scale)
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        local Elv = ElvUI[1]
        Elv.global.general.UIScale = scale
        Elv.PixelScaleChanged()
    else
        C_CVar.SetCVar("uiScale", scale)
        C_CVar.SetCVar("useUIScale", 1)
    end
    updateScaleDisplay()
end

-- UI Scale Functions
local function smallUIScale()
    updateUIScale(0.64)
end
local function medUIScale()
    updateUIScale(0.71)
end
local function lgUIScale()
    updateUIScale(0.78)
end
local function autoUIScale()
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        updateUIScale(ElvUI[1]:PixelBestSize())
    else
        local _, physHeight = GetPhysicalScreenSize()
        local perfect = 768 / physHeight
        updateUIScale(max(0.4, min(1.15, perfect)))
    end
end

-- Import Profile Functions
local function importProfile(profileType, dataKey)
    return function()
        DF:ShowPromptPanel(
            string.format("Are you sure you want to import/update Quazii's %s ElvUI profile?", profileType),
            function()
                QuaziiUI_DB.imports[dataKey] = {
                    date = GetServerTime(),
                    version = QUI.version
                }
                local Profile = ElvUI[1].Distributor
                Profile:ImportProfile(QUI.imports.ElvUI[dataKey].data)
                QuaziiUI_CDB.openPage = pageIndex
                updateElvUIDisplay()
            end,
            function()
            end,
            true
        )
    end
end

local importHealerProfile = importProfile("Healer", "healer.normal")
--[[local importHealerCellProfile = importProfile("Healer - Cell", "healer.cell")--]]
local importTankProfile = importProfile("Tank/DPS", "tankdps")

-- Page Creation
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateElvUISection(frame)
    self:CreateUIScaleSection(frame)

    self.rootFrame = frame
end

function page:CreateElvUISection(frame)
    local elvHeader =
        DF:CreateLabel(
        frame,
        "|c" .. QUI.highlightColorHex .. L["ElvUI"] .. " " .. L["Imports"] .. "|r",
        QUI.PageHeaderSize
    )
    elvHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    elvHeader:SetPoint("TOPRIGHT", frame, "TOP", -10, -10)
    elvHeader:SetJustifyH("CENTER")
    elvHeader:SetJustifyV("TOP")

    local elvDescription = DF:CreateLabel(frame, L["ElvUIText"]:gsub("QHCH", QUI.highlightColorHex), QUI.PageTextSize)
    elvDescription:SetWordWrap(true)
    elvDescription:SetPoint("TOPLEFT", elvHeader.widget, "BOTTOMLEFT", 0, -10)
    elvDescription:SetPoint("TOPRIGHT", elvHeader.widget, "BOTTOMRIGHT", 0, -10)
    elvDescription:SetJustifyH("LEFT")
    elvDescription:SetJustifyV("TOP")

    local importTankContainer = QUI:CreateImportFrame(frame, "ElvUI", L["Tank"] .. "/" .. L["DPS"], importTankProfile)
    importTankContainer:SetPoint("TOP", elvDescription.widget, "BOTTOM", 0, -20)

    local importHealerContainer = QUI:CreateImportFrame(frame, "ElvUI", L["Healer"], importHealerProfile)
    importHealerContainer:SetPoint("TOPRIGHT", importTankContainer, "BOTTOMRIGHT", 0, 10)

    self.lastHImportTime = importHealerContainer.lastImportText
    self.lastTImportTime = importTankContainer.lastImportText
    self.lastHVersion = importHealerContainer.versionText
    self.lastTVersion = importTankContainer.versionText

    --[[local importHealerCellContainer =
        QUI:CreateImportFrame(frame, "ElvUI", L["Healer"] .. " - " .. L["Cell"], importHealerCellProfile)
    importHealerCellContainer:SetPoint("TOPRIGHT", importHealerContainer, "BOTTOMRIGHT", 0, 10)
    self.lastHCVersion = importHealerCellContainer.versionText
    self.lastHCImportTime = importHealerCellContainer.lastImportText--]]
end

function page:CreateUIScaleSection(frame)
    local uiHeader =
        DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex .. L["UIScaleHeader"] .. "|r", QUI.PageHeaderSize)
    uiHeader:SetPoint("TOPLEFT", frame, "TOP", 10, -10)
    uiHeader:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    uiHeader:SetJustifyH("CENTER")

    local uiDescription = DF:CreateLabel(frame, L["UIScaleText"], QUI.PageTextSize)
    uiDescription:SetWordWrap(true)
    uiDescription:SetPoint("TOPLEFT", uiHeader.widget, "BOTTOMLEFT", 0, -10)
    uiDescription:SetPoint("TOPRIGHT", uiHeader.widget, "BOTTOMRIGHT", 0, -10)
    uiDescription:SetJustifyH("LEFT")
    uiDescription:SetJustifyV("TOP")

    local uiScaleLabel = DF:CreateLabel(frame, L["CurrentUIScale"], QUI.PageTextSize)
    uiScaleLabel:SetPoint("TOP", uiDescription.widget, "BOTTOM", 0, -35)

    self.uiScaleText = DF:CreateLabel(frame, "", QUI.PageTextSize)
    self.uiScaleText:SetPoint("TOP", uiScaleLabel, "BOTTOM", 0, -10)

    self:CreateScaleButtons(frame)
end

function page:CreateScaleButtons(frame)
    local buttonConfig = {
        {text = L["ScaleButtonAuto"], func = autoUIScale},
        {text = L["ScaleButtonSmall"], func = smallUIScale},
        {text = L["ScaleButtonMedium"], func = medUIScale},
        {text = L["ScaleButtonLarge"], func = lgUIScale}
    }

    local lastButton
    for i, config in ipairs(buttonConfig) do
        local button = DF:CreateButton(frame, config.func, 90, 30, config.text, nil, nil, nil, nil, nil, nil, QUI.ODT)
        if i == 1 then
            button:SetPoint("TOP", self.uiScaleText.widget, "BOTTOM", 0, -10)
        else
            button:SetPoint("TOP", lastButton, "BOTTOM", 0, -10)
        end
        button.text_overlay:SetFont(button.text_overlay:GetFont(), QUI.PageTextSize)
        lastButton = button
    end
end

function page:ShouldShow()
    return true
end

function page:Show()
    updateElvUIDisplay()
    updateScaleDisplay()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
