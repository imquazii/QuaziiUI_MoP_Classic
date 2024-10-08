local addonName, QUI = ...
local DF = _G["DetailsFramework"]
local L = QUI.L

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateText(frame)
    self:CreateImage(frame)

    self.rootFrame = frame
end

function page:CreateHeader(frame)
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex .. L["FinishHeader"] .. "|r", QUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateText(frame)
    local text = DF:CreateLabel(frame, L["FinishedText"], QUI.PageTextSize)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, -40)
    text:SetSpacing(5)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("TOP")
    frame.textWidget = text.widget
end

function page:CreateImage(frame)
    local image = DF:CreateImage(frame, "Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.png", 256, 256)
    image:SetPoint("CENTER", frame, "CENTER", 0, -10)
end

function page:ShouldShow()
    return true
end

function page:Show()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
