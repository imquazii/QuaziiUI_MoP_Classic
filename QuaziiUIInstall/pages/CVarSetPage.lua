local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local target1440UIScale = 0.64
local target1080UIScale = 0.7
local function updateDisplay()
    local Elv = ElvUI[1]
    local currentUIScale = Elv.global.general.UIScale
    local currentUIScaleText = currentUIScale
    page.uiScaleText:SetText("|c" .. addon.colorTextHighlight ..
                                 tostring(currentUIScaleText) .. "|r")
end
local function updateUIScale(scale)
    local Elv = ElvUI[1]
    Elv.global.general.UIScale = scale
    Elv.PixelScaleChanged()
    updateDisplay()
end
local function smallUIScale() updateUIScale(0.64) end
local function medUIScale() updateUIScale(0.71) end
local function lgUIScale() updateUIScale(0.78) end

local function autoUIScale()
    local Elv = ElvUI[1]
    updateUIScale(Elv:PixelBestSize())
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "CVar Set:|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "On this page we will assure you are running the correct UIScale for this UI. If your UI scale is wrong and not set to a specific value, whole UI will look off."
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetWordWrap(true)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -25)
    text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -25)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local uiScaleLabel = DF:CreateLabel(frame, "Current UI Scale:", 18)
    uiScaleLabel:SetPoint("CENTER", frame, "CENTER", 0, 0)
    local uiScaleText = DF:CreateLabel(frame, "", 18)
    uiScaleText:SetPoint("CENTER", uiScaleLabel, "CENTER", 0, -20)
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local autoUIScaleButton = DF:CreateButton(frame, autoUIScale, 80, 30,
                                              "Auto", nil, nil, nil, nil, nil,
                                              nil, options_dropdown_template)
    autoUIScaleButton:SetPoint("CENTER", frame, "CENTER", -135, -50)
    autoUIScaleButton.text_overlay:SetFont(
        autoUIScaleButton.text_overlay:GetFont(), 16)
    local smallUIScaleButton = DF:CreateButton(frame, smallUIScale, 80, 30,
                                               "Small", nil, nil, nil, nil, nil,
                                               nil, options_dropdown_template)
    smallUIScaleButton:SetPoint("CENTER", autoUIScaleButton, "CENTER", 90, 0)
    smallUIScaleButton.text_overlay:SetFont(
        smallUIScaleButton.text_overlay:GetFont(), 16)
    local medUIScaleButton = DF:CreateButton(frame, medUIScale, 80, 30,
                                             "Medium", nil, nil, nil, nil, nil,
                                             nil, options_dropdown_template)
    medUIScaleButton:SetPoint("CENTER", smallUIScaleButton, "CENTER", 90, 0)
    medUIScaleButton.text_overlay:SetFont(
        medUIScaleButton.text_overlay:GetFont(), 16)
    local lgUIScaleButton = DF:CreateButton(frame, lgUIScale, 80, 30, "Large",
                                            nil, nil, nil, nil, nil, nil,
                                            options_dropdown_template)
    lgUIScaleButton:SetPoint("CENTER", medUIScaleButton, "CENTER", 90, 0)
    lgUIScaleButton.text_overlay:SetFont(lgUIScaleButton.text_overlay:GetFont(),
                                         16)
    page.uiScaleText = uiScaleText
    page.rootFrame = frame
end
function page:ShouldShow() return true end
function page:Show()
    updateDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
