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

local function fillWAFromCategoryIndex(index)
    local data = {}
    for _, importString in ipairs(QUI.imports.WAStrings[index].WAs) do
        local waTable = QUI.decodeWAPacket(importString)
        if waTable then
            local isWAInstalled = WeakAuras.GetData(waTable.d.id)
            local installedWAVersion, needsUpdate
            if isWAInstalled then
                installedWAVersion = isWAInstalled.version
                if (waTable.d.version or 0) > (installedWAVersion or 0) then
                    print("WA NEEDS UPDATE")
                    needsUpdate = "|cFFbc1f00Yes|r"
                else
                    print("WA NO NEEDS UPDATE")
                    needsUpdate = "|cFF28bc00No|r"
                end
            else
                needsUpdate = "N/A"
            end

            local icon = waTable.d.groupIcon or waTable.d.displayIcon or
                             "Interface\\AddOns\\QuaziiUIInstaller\\assets\\quaziiLogo.tga"
            table.insert(data, {
                icon = icon,
                name = waTable.d.id:gsub("%[READ%sINFORMATION%sTAB%]", ""),
                update = needsUpdate
            })
        end
    end
    page.waScrollBox:SetData(data)
    page.waScrollBox:Refresh()
end
local function onCategoryClick(self, _, index)
    currentCategory = index
    fillWAFromCategoryIndex(currentCategory)
end
local function fillSelectionDropdown()
    local options = {}
    for index, category in ipairs(QUI.imports.WAStrings) do
        local label =
            category.color and "|c" .. category.color .. category.name .. "|r" or
                category.name
        table.insert(options,
                     {value = index, label = label, onclick = onCategoryClick})
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
            if info.update == "N/A" then
                line.updateLabel:SetScript("onEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
                    GameTooltip:AddLine("Weakaura not installed or has been renamed")
                    GameTooltip:Show()
                end)
                line.updateLabel:SetScript("onLeave", function()
                    GameTooltip:Hide()
                end)
            end
            line.icon:SetTexture(info.icon)
            if not WeakAuras then
                line.importButton:Disable()
                line.importButton:SetText("Load WAs")
            else
                line.importButton:SetClickFunction(function(self)
                    WeakAuras.Import(
                        QUI.imports.WAStrings[currentCategory].WAs[index])
                end)
            end
        end
    end
end
local function createWAButton(self, index)
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
    local nameLabel = DF:CreateLabel(line, "", 16)
    local updateLabel = DF:CreateLabel(line, "", 16)
    nameLabel:SetSize(318, self.LineHeight / 2)

    updateLabel:SetSize(68, self.LineHeight / 2)
    updateLabel:SetJustifyH("CENTER")

    local importButton = DF:CreateButton(line, nil, 110, 30, "Import", nil, nil,
                                         nil, nil, nil, nil, QUI.ODT)
    importButton.text_overlay:SetFont(importButton.text_overlay:GetFont(), 16)
    line:AddFrameToHeaderAlignment(icon)
    line:AddFrameToHeaderAlignment(nameLabel)
    line:AddFrameToHeaderAlignment(updateLabel)
    line:AddFrameToHeaderAlignment(importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")
    line.icon = icon
    line.nameLabel = nameLabel
    line.updateLabel = updateLabel
    line.importButton = importButton
    return line
end
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local header = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                      L["WeakAuras"] .. L["Imports"] .. "|r",
                                  QUI.PageHeaderSize)
    header:SetPoint("CENTER", frame, "TOP", 0, -20)
    local textString = L["WeakAuraText"]
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
        {text = "Icon", width = 50, offset = 1}, {text = "Name", width = 317},
        {text = "Update?", width = 67}, {text = "Import", width = 117}
    }
    local options = {text_size = 16}
    frame.addonHeader = DF:CreateHeader(frame, headerTable, options,
                                        "QuaziiUIInstallWAHeader")
    frame.addonHeader:SetPoint("TOPLEFT", text.widget, "BOTTOMLEFT", -2, -35)
    local waScrollBox = DF:CreateScrollBox(frame, nil, waScrollBoxUpdate, {},
                                           557, 271, 0, 44, createWAButton, true)
    waScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    waScrollBox.ScrollBar.scrollStep = 44
    DF:ReskinSlider(waScrollBox)
    page.waScrollBox = waScrollBox
    page.rootFrame = frame
    fillWAFromCategoryIndex(1)
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
