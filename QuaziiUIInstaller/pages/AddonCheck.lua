---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local L = QUI.L

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)

QUI.supportedAddons = {
    "ElvUI", "WeakAuras", "MythicDungeonTools", "Plater", "BigWigs", "Details", "OmniCD"
}

local function addonScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            local addonTitle = C_AddOns and C_AddOns.GetAddOnInfo(info)
            line.addonLabel:SetText(addonTitle or info)
            line.versionLabel:SetText(addonTitle and C_AddOns and C_AddOns.GetAddOnMetadata(info, "Version") or L["NA"])
            line.enabledLabel:SetText(
                C_AddOns and C_AddOns.IsAddOnLoaded(info) and 
                "|cff00ff00" .. L["True"] .. "|r" or 
                "|cffff0000" .. L["False"] .. "|r"
            )
        end
    end
end

local function createAddonButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
    line:SetClipsChildren(true)
    line:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -((index - 1) * (self.LineHeight + 1)) - 1)
    line:SetSize(555, self.LineHeight)
    line:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tileSize = 64,
        tile = true
    })
    line:SetBackdropColor(0.8, 0.8, 0.8, 0.2)
    DF:Mixin(line, DF.HeaderFunctions)

    line.addonLabel = DF:CreateLabel(line, nil, QUI.TableTextSize)
    line.versionLabel = DF:CreateLabel(line, nil, QUI.TableTextSize)
    line.enabledLabel = DF:CreateLabel(line, nil, QUI.TableTextSize)

    line:AddFrameToHeaderAlignment(line.addonLabel)
    line:AddFrameToHeaderAlignment(line.enabledLabel)
    line:AddFrameToHeaderAlignment(line.versionLabel)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")

    return line
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateDescription(frame)
    self:CreateAddonList(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateHeader(frame)
    local header = DF:CreateLabel(frame, 
        "|c" .. QUI.highlightColorHex .. L["SupportedAddonsHeader"] .. "|r",
        QUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateDescription(frame)
    local description = DF:CreateLabel(frame, L["SupportedAddonsText"], QUI.PageTextSize)
    description:SetWordWrap(true)
    description:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    description:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    description:SetJustifyH("LEFT")
    description:SetJustifyV("TOP")
    self.description = description
end

function page:CreateAddonList(frame)
    local headerTable = {
        {text = "|c" .. QUI.highlightColorHex .. L["SupportedAddonsTable1stHeader"], width = 331, offset = 2},
        {text = L["SupportedAddonsTable2ndHeader"], width = 71},
        {text = L["SupportedAddonsTable3rdHeader"], width = 151}
    }
    local options = {text_size = QUI.TableHeaderSize}
    frame.addonHeader = DF:CreateHeader(frame, headerTable, options, "QuaziiUIInstallAddonHeader")
    frame.addonHeader:SetPoint("TOPLEFT", self.description.widget, "BOTTOMLEFT", -2, -10)

    local addonScrollBox = DF:CreateScrollBox(frame, nil, addonScrollBoxUpdate, {}, 557, 320, 0, 24, createAddonButton, true)
    addonScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    DF:ReskinSlider(addonScrollBox)
    addonScrollBox:SetData(QUI.supportedAddons)
    addonScrollBox:Refresh()
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