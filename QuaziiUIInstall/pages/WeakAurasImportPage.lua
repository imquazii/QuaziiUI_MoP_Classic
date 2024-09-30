local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
local currentCategory = 1
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local Serializer = LibStub:GetLibrary("AceSerializer-3.0")
local LibSerializer = LibStub("LibSerialize")
local function decodeWAPacket(importString)
    local _, _, encodeVersion, encoded = importString:find("^(!WA:%d+!)(.+)$")
    if encodeVersion then
        encodeVersion = tonumber(encodeVersion:match("%d+"))
    else
        encoded, encodeVersion = importString:gsub("^%!", "")
    end
    if encoded then
        local decoded = LibDeflate:DecodeForPrint(encoded)
        local decompressed = LibDeflate:DecompressDeflate(decoded)
        local deserialized
        if encodeVersion == 2 then
            _, deserialized = LibSerializer:Deserialize(decompressed)
        else
            _, deserialized = Serializer:Deserialize(decompressed)
        end
        return deserialized
    end
    return nil
end
local function fillWAFromCategoryIndex(index)
    local data = {}
    for _, importString in ipairs(addon.imports.WAStrings[index].WAs) do
        local waTable = decodeWAPacket(importString)
        if waTable then
            local icon = waTable.d.groupIcon or waTable.d.displayIcon or
                             "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiLogo.tga"
            table.insert(data, {
                name = waTable.d.id,
                version = waTable.d.version,
                icon = icon
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
    for index, category in ipairs(addon.imports.WAStrings) do
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
            line.versionLabel:SetText(info.version)
            line.icon:SetTexture(info.icon)
            if not WeakAuras then
                line.importButton:Disable()
                line.importButton:SetText("Load WAs")
            else
                line.importButton:SetClickFunction(function(self)
                    WeakAuras.Import(addon.imports.WAStrings[currentCategory]
                                         .WAs[index])
                end)
            end
        end
    end
end
local function createWAButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
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
    local icon = line:CreateTexture(nil, "OVERLAY")
    icon:SetSize(42, 42)
    local nameLabel = DF:CreateLabel(line, "", 16)
    nameLabel:SetSize(263, self.LineHeight)
    local versionLabel = DF:CreateLabel(line, "", 16)
    versionLabel:SetSize(50, self.LineHeight / 2)
    versionLabel:SetJustifyH("CENTER")
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local importButton = DF:CreateButton(line, nil, 90, 30, "Import", nil, nil,
                                         nil, nil, nil, nil,
                                         options_dropdown_template)
    importButton.text_overlay:SetFont(importButton.text_overlay:GetFont(), 16)
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
    local header = DF:CreateLabel(frame, "|c" .. addon.colorTextHighlight ..
                                      "WeakAuras import|r", 18)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT")
    local textString =
        "Here you can chose witch WAs you would like to import or update."
    local text = DF:CreateLabel(frame, textString, 16)
    text:SetWordWrap(true)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -20)
    text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -20)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local selectionDropdown = DF:CreateDropDown(frame, fillSelectionDropdown,
                                                nil, 200, 25, nil, nil,
                                                options_dropdown_template)
    selectionDropdown:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -5)
    selectionDropdown.label:SetFont(selectionDropdown.label:GetFont(), 16)
    local headerTable = {
        {text = "Icon", width = 50, offset = 1}, {text = "Name", width = 263},
        {text = "Version", width = 50}, {text = "Import", width = 100}
    }
    frame.addonHeader = DF:CreateHeader(frame, headerTable, nil,
                                        "QuaziiUIInstallWAHeader")
    frame.addonHeader:SetPoint("TOPLEFT", text.widget, "BOTTOMLEFT", 0, -35)
    local waScrollBox = DF:CreateScrollBox(frame, nil, waScrollBoxUpdate, {},
                                           470, 226, 0, 44, createWAButton, true)
    waScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT")
    waScrollBox.ScrollBar.scrollStep = 44
    DF:ReskinSlider(waScrollBox)
    page.waScrollBox = waScrollBox
    page.rootFrame = frame
    fillWAFromCategoryIndex(1)
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
