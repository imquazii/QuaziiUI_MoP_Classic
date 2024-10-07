---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local L = QUI.L

-- Page Setup
QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)

function page:Create(parent)
    -- Init Frame
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    -- Make Page Header
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      L["WelcomeHeader"] .. "|r",
                                  QUI.PageHeaderSize)
    header:SetPoint("CENTER", frame, "TOP", 0, -20)

    -- Make Page Text
    local textString =
        L["WelcomeText1"] .. "\n" .. L["WelcomeText2"] .. "\n\n" ..
            L["WelcomeText3"]
    local text = DF:CreateLabel(frame, textString, QUI.PageTextSize)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, -40)
    text:SetSpacing(5)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")

    -- Make Page Image
    local image = DF:CreateImage(frame,
                                 "Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.png",
                                 256, 256)
    image:ClearAllPoints()
    image:SetPoint("CENTER", frame, "CENTER", 0, -100)
    page.rootFrame = frame
    return frame
end

function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
