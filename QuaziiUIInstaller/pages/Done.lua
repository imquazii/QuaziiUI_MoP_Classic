local addonName, QUI = ...
local DF = _G["DetailsFramework"]
local L = QUI.L
QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      L["FinishHeader"] .. "|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString = L["FinishedText"]
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -30)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local image = DF:CreateImage(frame,
                                 "Interface\\AddOns\\MeeresUIInstall\\assets\\meeresL.tga",
                                 128, 128)
    image:ClearAllPoints()
    image:SetPoint("CENTER", frame, "CENTER", 0, -50)
    page.rootFrame = frame
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
