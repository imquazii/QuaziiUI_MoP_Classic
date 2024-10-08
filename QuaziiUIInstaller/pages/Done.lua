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
    local header = DF:CreateLabel(frame, 
        "|c" .. QUI.highlightColorHex .. L["FinishHeader"] .. "|r", 
        18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
end

function page:CreateText(frame)
    local text = DF:CreateLabel(frame, L["FinishedText"], 16)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -30)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
end

function page:CreateImage(frame)
    local image = DF:CreateImage(frame,
        "Interface\\AddOns\\MeeresUIInstall\\assets\\meeresL.tga",
        128, 128)
    image:SetPoint("CENTER", frame, "CENTER", 0, -50)
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