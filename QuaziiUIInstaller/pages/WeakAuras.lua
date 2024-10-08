---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local L = QUI.L

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)

local currentCategory = 1
local GameTooltip = GameTooltip

local function decodeWAPacket(importString)
    return QUI.decodeWAPacket(importString)
end

local function getWAUpdateStatus(waTable)
    local isWAInstalled = WeakAuras.GetData(waTable.d.id)
    if not isWAInstalled then
        return "N/A"
    end

    local installedVersion = isWAInstalled.version
    local newVersion = waTable.d.version or 0
    return newVersion > (installedVersion or 0) and "|cFFbc1f00Yes|r" or "|cFF28bc00No|r"
end

local function fillWAFromCategoryIndex(index)
    local data = {}
    for _, importString in ipairs(QUI.imports.WAStrings[index].WAs) do
        local waTable = decodeWAPacket(importString)
        if waTable then
            table.insert(data, {
                icon = waTable.d.groupIcon or waTable.d.displayIcon or "Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.tga",
                name = waTable.d.id:gsub("%[READ%sINFORMATION%sTAB%]", ""),
                update = getWAUpdateStatus(waTable)
            })
        end
    end
    page.waScrollBox:SetData(data)
    page.waScrollBox:Refresh()
end

local function onCategoryClick(_, _, index)
    currentCategory = index
    fillWAFromCategoryIndex(currentCategory)
end

local function fillSelectionDropdown()
    local options = {}
    for index, category in ipairs(QUI.imports.WAStrings) do
        local label = category.color and "|c" .. category.color .. category.name .. "|r" or category.name
        table.insert(options, {value = index, label = label, onclick = onCategoryClick})
    end
    return options
end

local function waScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            line.nameLabel:SetText(info.name)
            line.updateLabel:SetText(info.update)
            line.icon:SetTexture(info.icon)
            
            if info.update == "N/A" then
                line.updateLabel:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
                    GameTooltip:AddLine("WeakAura not installed or has been renamed")
                    GameTooltip:Show()
                end)
                line.updateLabel:SetScript("OnLeave", GameTooltip_Hide)
            else
                line.updateLabel:SetScript("OnEnter", nil)
                line.updateLabel:SetScript("OnLeave", nil)
            end

            if not WeakAuras then
                line.importButton:Disable()
                line.importButton:SetText("Load WAs")
            else
                line.importButton:SetClickFunction(function()
                    WeakAuras.Import(QUI.imports.WAStrings[currentCategory].WAs[index])
                end)
            end
        end
    end
end

local function createWAButton(self, index)
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

    line.icon = line:CreateTexture(nil, "OVERLAY")
    line.icon:SetSize(42, 42)
    line.nameLabel = DF:CreateLabel(line, "", 16)
    line.updateLabel = DF:CreateLabel(line, "", 16)
    line.nameLabel:SetSize(318, self.LineHeight / 2)
    line.updateLabel:SetSize(68, self.LineHeight / 2)
    line.updateLabel:SetJustifyH("CENTER")

    line.importButton = DF:CreateButton(line, nil, 110, 30, "Import", nil, nil, nil, nil, nil, nil, QUI.ODT)
    line.importButton.text_overlay:SetFont(line.importButton.text_overlay:GetFont(), 16)

    line:AddFrameToHeaderAlignment(line.icon)
    line:AddFrameToHeaderAlignment(line.nameLabel)
    line:AddFrameToHeaderAlignment(line.updateLabel)
    line:AddFrameToHeaderAlignment(line.importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")

    return line
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateDescription(frame)
    self:CreateSelectionDropdown(frame)
    self:CreateWAList(frame)

    self.rootFrame = frame
    fillWAFromCategoryIndex(1)
end

function page:CreateHeader(frame)
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex .. L["WeakAuras"] .. " " .. L["Imports"] .. "|r", QUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateDescription(frame)
    local text = DF:CreateLabel(frame, L["WeakAuraText"], QUI.PageTextSize)
    text:SetWordWrap(true)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    self.descriptionText = text
end

function page:CreateSelectionDropdown(frame)
    local selectionDropdown = DF:CreateDropDown(frame, fillSelectionDropdown, nil, 200, 25, nil, nil, QUI.ODT)
    selectionDropdown:SetPoint("TOPLEFT", self.descriptionText, "BOTTOMLEFT", -1, -5)
    selectionDropdown.label:SetFont(selectionDropdown.label:GetFont(), 16)
end

function page:CreateWAList(frame)
    local headerTable = {
        {text = "Icon", width = 50, offset = 1},
        {text = "Name", width = 317},
        {text = "Update?", width = 67},
        {text = "Import", width = 117}
    }
    local options = {text_size = 16}
    frame.addonHeader = DF:CreateHeader(frame, headerTable, options, "QuaziiUIInstallWAHeader")
    frame.addonHeader:SetPoint("TOPLEFT", self.descriptionText.widget, "BOTTOMLEFT", -2, -35)

    local waScrollBox = DF:CreateScrollBox(frame, nil, waScrollBoxUpdate, {}, 557, 271, 0, 44, createWAButton, true)
    waScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    waScrollBox.ScrollBar.scrollStep = 44
    DF:ReskinSlider(waScrollBox)
    self.waScrollBox = waScrollBox
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