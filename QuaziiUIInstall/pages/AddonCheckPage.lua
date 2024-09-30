local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded
local GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo
addon.supportedAddons = {
    "ElvUI", "WeakAuras", "Plater", "BigWigs", "Details", "OmniCD"
}
local function addonScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            local _, addonTitle = GetAddOnInfo(info)
            line.addonLabel:SetText(addonTitle or info)
            line.versionLebel:SetText(addonTitle and
                                          GetAddOnMetadata(info, "Version") or
                                          "N/A")
            line.enabledLabel:SetText(
                IsAddOnLoaded(info) and "|cff00ff00True|r" or
                    "|cffff0000False|r")
        end
    end
end
local function createAddonButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
    line:SetClipsChildren(true)
    line:SetPoint("TOPLEFT", self, "TOPLEFT", 1,
                  -((index - 1) * (self.LineHeight + 1)) - 1)
    line:SetSize(468, self.LineHeight)
    line:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tileSize = 64,
        tile = true
    })
    line:SetBackdropColor(unpack({0.8, 0.8, 0.8, 0.2}))
    DF:Mixin(line, DF.HeaderFunctions)
    local addonLabel = DF:CreateLabel(line, nil, 12)
    local versionLabel = DF:CreateLabel(line, nil, 12)
    local enabledLabel = DF:CreateLabel(line, nil, 12)
    line:AddFrameToHeaderAlignment(addonLabel)
    line:AddFrameToHeaderAlignment(enabledLabel)
    line:AddFrameToHeaderAlignment(versionLabel)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")
    line.addonLabel = addonLabel
    line.versionLebel = versionLabel
    line.enabledLabel = enabledLabel
    return line
end
function page:Create(parent)
    page.rootFrame = CreateFrame("Frame", nil, parent.frameContent)
    page.rootFrame:SetAllPoints()
    local header = DF:CreateLabel(page.rootFrame, "|c" ..
                                      addon.colorTextHighlight ..
                                      "Supported addons check:|r", 18)
    header:SetPoint("TOPLEFT", page.rootFrame, "TOPLEFT")
    local description = DF:CreateLabel(page.rootFrame,
                                       "Here you will see what addon profiles are suppored by this\ninstaller. So you dont miss out on anything!")
    description:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 2, -5)
    description:SetFont(description:GetFont(), 14)
    local headerTable = {
        {
            text = "|c" .. addon.colorTextHighlight .. "Supported|r Addons",
            width = 250,
            offset = 2
        }, {text = "Enabled", width = 50},
        {text = "Installed version", width = 165}
    }
    page.rootFrame.addonHeader = DF:CreateHeader(page.rootFrame, headerTable,
                                                 nil,
                                                 "QuaziiUIInstallAddonHeader")
    page.rootFrame.addonHeader:SetPoint("TOPLEFT", description.widget,
                                        "BOTTOMLEFT", 1, -10)
    local addonScrollBox = DF:CreateScrollBox(page.rootFrame, nil,
                                              addonScrollBoxUpdate, {}, 470,
                                              251, 0, 24, createAddonButton,
                                              true)
    addonScrollBox:SetPoint("TOPLEFT", page.rootFrame.addonHeader, "BOTTOMLEFT")
    DF:ReskinSlider(addonScrollBox)
    addonScrollBox:SetData(addon.supportedAddons)
    addonScrollBox:Refresh()
    return page.rootFrame
end
function page:ShouldShow() return true end
local didDisable = false
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
