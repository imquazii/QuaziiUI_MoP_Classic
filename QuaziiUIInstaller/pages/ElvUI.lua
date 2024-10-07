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
local function updateElvUIDisplay()
    if QuaziiUI_DB and QuaziiUI_DB.imports.ElvUIHeals then
        page.lastHImportTime:SetText(date("%m/%d/%y",
                                          QuaziiUI_DB.imports.ElvUIHeals.date))
        page.lastHVersion:SetText(QuaziiUI_DB.imports.ElvUIHeals.version)
    else
        page.lastHImportTime:SetText(L["NA"])
        page.lastHVersion:SetText(L["NA"])
    end
    if QuaziiUI_DB and QuaziiUI_DB.imports.ElvUIHealsCell then
        page.lastHCImportTime:SetText(date("%m/%d/%y", QuaziiUI_DB.imports
                                               .ElvUIHealsCell.date))
        page.lastHCVersion:SetText(QuaziiUI_DB.imports.ElvUIHealsCell.version)
    else
        page.lastHCImportTime:SetText(L["NA"])
        page.lastHCVersion:SetText(L["NA"])
    end
    if QuaziiUI_DB and QuaziiUI_DB.imports.ElvUITank then
        page.lastTImportTime:SetText(date("%m/%d/%y",
                                          QuaziiUI_DB.imports.ElvUITank.date))
        page.lastTVersion:SetText(QuaziiUI_DB.imports.ElvUITank.version)
    else
        page.lastTImportTime:SetText(L["NA"])
        page.lastTVersion:SetText(L["NA"])
    end
end

local function updateScaleDisplay()
    local currentUIScale
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        local Elv = ElvUI[1]
        currentUIScale = Elv.global.general.UIScale
    else
        currentUIScale = C_CVar.GetCVar("uiScale");
    end
    local currentUIScaleText = currentUIScale
    page.uiScaleText:SetText("|c" .. QUI.highlightColorHex ..
                                 tostring(currentUIScaleText) .. "|r")
end

local function updateUIScale(scale)
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        local Elv = ElvUI[1]
        Elv.global.general.UIScale = scale
        Elv.PixelScaleChanged()
    else
        C_CVar.SetCVar("uiScale", scale);
        C_CVar.SetCVar("useUIScale", 1);
    end
    updateScaleDisplay()
end

local function smallUIScale() updateUIScale(0.64) end

local function medUIScale() updateUIScale(0.71) end

local function lgUIScale() updateUIScale(0.78) end

local function autoUIScale()
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        updateUIScale(ElvUI[1]:PixelBestSize())
    else
        local _, physHeight = GetPhysicalScreenSize()
        local perfect = 768 / physHeight
        local scale = max(0.4, min(1.15, perfect))
        updateUIScale(scale)
    end
end

local function importHealerProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Healer ElvUI profile?",
        function()
            QuaziiUI_DB.imports.ElvUIHeals = {}
            QuaziiUI_DB.imports.ElvUIHeals.date = GetServerTime()
            QuaziiUI_DB.imports.ElvUIHeals.version = QUI.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(QUI.imports.ElvUI.healer.normal.data)
            QuaziiUI_CDB.openPage = pageIndex
            updateElvUIDisplay()
        end, function() end, true)
end
local function importHealerCellProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Healer ElvUI profile?",
        function()
            QuaziiUI_DB.imports.ElvUIHealsCell = {}
            QuaziiUI_DB.imports.ElvUIHealsCell.date = GetServerTime()
            QuaziiUI_DB.imports.ElvUIHealsCell.version = QUI.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(QUI.imports.ElvUI.healer.cell.data)
            QuaziiUI_CDB.openPage = pageIndex
            updateElvUIDisplay()
        end, function() end, true)
end
local function importTankProfile(self)
    DF:ShowPromptPanel(
        "Are you sure you want to import/update Quazii's Tank/DPS ElvUI profile?",
        function()
            QuaziiUI_DB.imports.ElvUITank = {}
            QuaziiUI_DB.imports.ElvUITank.date = GetServerTime()
            QuaziiUI_DB.imports.ElvUITank.version = QUI.version
            local Elv = ElvUI[1]
            local Profile = Elv.Distributor
            Profile:ImportProfile(QUI.imports.ElvUI.tankdps.data)
            QuaziiUI_CDB.openPage = pageIndex
            updateElvUIDisplay()
        end, function() end, true)
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local elvHeader = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                         L["ElvUI"] .. L["Imports"] .. "|r",
                                     QUI.PageHeaderSize)
    elvHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -20)
    elvHeader:SetPoint("TOPRIGHT", frame, "TOP", -5, -20)
    elvHeader:SetJustifyH("CENTER")
    elvHeader:SetJustifyV("TOP")

    local elvTextString = L["ElvUIText"]:gsub("QHCH", QUI.highlightColorHex)

    local elvDescription =
        DF:CreateLabel(frame, elvTextString, QUI.PageTextSize)
    elvDescription:SetWordWrap(true)
    elvDescription:SetPoint("TOPLEFT", elvHeader.widget, "BOTTOMLEFT", 0, -10)
    elvDescription:SetPoint("TOPRIGHT", elvHeader.widget, "BOTTOMRIGHT", 0, -10)
    elvDescription:SetJustifyH("LEFT")
    elvDescription:SetJustifyV("TOP")

    local importTankContainer = QUI:CreateImportFrame(frame, "ElvUI",
                                                      L["Tank"] .. "/" ..
                                                          L["DPS"], nil, nil,
                                                      nil, importTankProfile)
    importTankContainer:SetPoint("TOPRIGHT", elvDescription.widget,
                                 "BOTTOMRIGHT", 0, -20)
    local importHealerContainer = QUI:CreateImportFrame(frame, "ElvUI",
                                                        L["Healer"], nil, nil,
                                                        nil, importHealerProfile)
    importHealerContainer:SetPoint("TOPRIGHT", importTankContainer,
                                   "BOTTOMRIGHT", 0, 10)
    local importHealerCellContainer = QUI:CreateImportFrame(frame, "ElvUI",
                                                            L["Healer"] .. " - " ..
                                                                L["Cell"], nil,
                                                            nil, nil,
                                                            importHealerCellProfile)
    importHealerCellContainer:SetPoint("TOPRIGHT", importHealerContainer,
                                       "BOTTOMRIGHT", 0, 10)

    local uiHeader = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                        L["UIScaleHeader"] .. "|r",
                                    QUI.PageHeaderSize)
    uiHeader:SetPoint("TOPLEFT", frame, "TOP", 5, -20)
    uiHeader:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, 10)
    uiHeader:SetJustifyH("CENTER")
    local scaleTextString = L["UIScaleText"]
    local uiDescription = DF:CreateLabel(frame, scaleTextString,
                                         QUI.PageTextSize)
    uiDescription:SetWordWrap(true)
    uiDescription:SetPoint("TOPLEFT", uiHeader.widget, "BOTTOMLEFT", 0, -10)
    uiDescription:SetPoint("TOPRIGHT", uiHeader.widget, "BOTTOMRIGHT", 0, -10)
    uiDescription:SetJustifyH("LEFT")
    uiDescription:SetJustifyV("TOP")

    local uiScaleLabel = DF:CreateLabel(frame, L["CurrentUIScale"],
                                        QUI.PageTextSize)
    uiScaleLabel:SetPoint("TOP", uiDescription.widget, "BOTTOM", 0, -35)
    local uiScaleText = DF:CreateLabel(frame, "", QUI.PageTextSize)
    uiScaleText:SetPoint("TOP", uiScaleLabel, "BOTTOM", 0, -10)

    local autoUIScaleButton = DF:CreateButton(frame, autoUIScale, 90, 30,
                                              L["ScaleButtonAuto"], nil, nil,
                                              nil, nil, nil, nil, QUI.ODT)
    autoUIScaleButton:SetPoint("TOP", uiScaleText.widget, "BOTTOM", 0, -10)
    autoUIScaleButton.text_overlay:SetFont(
        autoUIScaleButton.text_overlay:GetFont(), QUI.PageTextSize)
    local smallUIScaleButton = DF:CreateButton(frame, smallUIScale, 90, 30,
                                               L["ScaleButtonSmall"], nil, nil,
                                               nil, nil, nil, nil, QUI.ODT)
    smallUIScaleButton:SetPoint("TOP", autoUIScaleButton, "BOTTOM", 0, -10)
    smallUIScaleButton.text_overlay:SetFont(
        smallUIScaleButton.text_overlay:GetFont(), QUI.PageTextSize)
    local medUIScaleButton = DF:CreateButton(frame, medUIScale, 90, 30,
                                             L["ScaleButtonMedium"], nil, nil,
                                             nil, nil, nil, nil, QUI.ODT)
    medUIScaleButton:SetPoint("TOP", smallUIScaleButton, "BOTTOM", 0, -10)
    medUIScaleButton.text_overlay:SetFont(
        medUIScaleButton.text_overlay:GetFont(), QUI.PageTextSize)
    local lgUIScaleButton = DF:CreateButton(frame, lgUIScale, 90, 30,
                                            L["ScaleButtonLarge"], nil, nil,
                                            nil, nil, nil, nil, QUI.ODT)
    lgUIScaleButton:SetPoint("TOP", medUIScaleButton, "BOTTOM", 0, -10)
    lgUIScaleButton.text_overlay:SetFont(lgUIScaleButton.text_overlay:GetFont(),
                                         QUI.PageTextSize)
    page.uiScaleText = uiScaleText

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
    updateElvUIDisplay()
    updateScaleDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
