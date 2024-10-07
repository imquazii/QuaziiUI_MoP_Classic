---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local L = QUI.L
local DF = _G["DetailsFramework"]
QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
local currentCategory = 1

local function fillMDTFromCategoryIndex(index)
    local data = {}
    if C_AddOns and C_AddOns.IsAddOnLoaded("MythicDungeonTools") then
        for _, importString in ipairs(QUI.imports.MDT[index].Routes) do

            local MDTPreset = MDT:StringToTable(importString, true)
            local MDTValid = MDT:ValidateImportPreset(MDTPreset)
            if MDTValid then
                table.insert(data, {
                    name = MDTPreset["text"],
                    version = MDTPreset["uid"],
                    icon = "Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.tga"
                })
            end
        end
    else
        table.insert(data, {name=L["MDTNotLoaded"], version="", icon="Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.tga"})
    end
    page.mdtScrollBox:SetData(data)
    page.mdtScrollBox:Refresh()
end
local function onCategoryClick(self, _, index)
    currentCategory = index
    fillMDTFromCategoryIndex(currentCategory)
end
local function fillSelectionDropdown()
    local options = {}
    for index, category in ipairs(QUI.imports.MDT) do
        local label =
            category.color and "|c" .. category.color .. category.name .. "|r" or
                category.name
        table.insert(options,
                     {value = index, label = label, onclick = onCategoryClick})
    end
    return options
end
local function mdtScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            line.nameLabel:SetText(info.name)
            line.versionLabel:SetText(info.version)
            line.icon:SetTexture(info.icon)
            if not MDT then
                line.importButton:Disable()
                line.importButton:SetText(L["NA"])
            else
                line.importButton:SetClickFunction(function(self)
                    if MDT then
                        local MDTPreset = MDT:StringToTable(
                                            QUI.imports.MDT[currentCategory]
                                                .Routes[index], true)
                        local MDTValid = MDT:ValidateImportPreset(MDTPreset)
                        if MDTValid then
                            MDT:ImportPreset(MDTPreset, false)
                        end
                    end
                end)
            end
        end
    end
end
local function createMDTButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
    line:SetClipsChildren(true)
    line:SetPoint("TOPLEFT", self, "TOPLEFT", 1,
                  -((index - 1) * (self.LineHeight + 1)) - 1)
    line:SetSize(555, self.LineHeight)
    line:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tileSize = 64,
        tile = true
    })
    line:SetBackdropColor(unpack({0.8, 0.8, 0.8, 0.2}))
    DF:Mixin(line, DF.HeaderFunctions)

    local icon = line:CreateTexture(nil, "OVERLAY")
    icon:SetSize(42, 42)
    local nameLabel = DF:CreateLabel(line, "", 18)
    local versionLabel = DF:CreateLabel(line, "", 18)
    nameLabel:SetSize(318, self.LineHeight / 2)

    versionLabel:SetSize(68, self.LineHeight / 2)
    versionLabel:SetJustifyH("CENTER")

    local importButton = DF:CreateButton(line, nil, 110, 30, L["Import"], nil, nil,
                                         nil, nil, nil, nil, QUI.ODT)
    importButton.text_overlay:SetFont(importButton.text_overlay:GetFont(), 18)
    line:AddFrameToHeaderAlignment(icon)
    line:AddFrameToHeaderAlignment(nameLabel)
    line:AddFrameToHeaderAlignment(versionLabel)
    line:AddFrameToHeaderAlignment(importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")
    line.icon = icon
    line.nameLabel = nameLabel
    line.versionLabel = versionLabel
    line.importButton = importButton
    return line
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      L["MDTHeader"] .. "|r", QUI.PageHeaderSize)
    header:SetPoint("CENTER", frame, "TOP", 0, -20)
    local textString = L["MDTText"]
    local text = DF:CreateLabel(frame, textString, QUI.PageTextSize)
    text:SetWordWrap(true)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")

    local selectionDropdown = DF:CreateDropDown(frame, fillSelectionDropdown,
                                                nil, 200, 25, nil, nil, QUI.ODT)
    selectionDropdown:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -1, -5)
    selectionDropdown.label:SetFont(selectionDropdown.label:GetFont(), 16)
    local headerTable = {
        {text = L["Icon"], width = 50, offset = 1}, {text = L["Name"], width = 300},
        {text = L["Version"], width = 84}, {text = L["Import"], width = 117}
    }
    local options = {text_size = 16}
    frame.addonHeader = DF:CreateHeader(frame, headerTable, options,
                                        "QuaziiUIInstallMDTHeader")
    frame.addonHeader:SetPoint("TOPLEFT", text.widget, "BOTTOMLEFT", -2, -35)
    local mdtScrollBox = DF:CreateScrollBox(frame, nil, mdtScrollBoxUpdate, {},
                                            557, 271, 0, 44, createMDTButton,
                                            true)
    mdtScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    mdtScrollBox.ScrollBar.scrollStep = 44
    DF:ReskinSlider(mdtScrollBox)
    page.mdtScrollBox = mdtScrollBox
    page.rootFrame = frame
    fillMDTFromCategoryIndex(1)
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
