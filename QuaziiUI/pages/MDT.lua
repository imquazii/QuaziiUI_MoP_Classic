local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pagePrototypes, page)

local currentCategory = 1

-- Helper Functions
---@return boolean
local function isMDTLoaded()
    return C_AddOns and C_AddOns.IsAddOnLoaded("MythicDungeonTools")
end

---@param index integer
local function fillMDTFromCategoryIndex(index)
    local data = {}
    if isMDTLoaded() then
        for _, importString in ipairs(QuaziiUI.imports.MDT[index].Routes) do
            local MDTPreset = MDT:StringToTable(importString, true)
            if MDT:ValidateImportPreset(MDTPreset) then
                table.insert(
                    data,
                    {
                        name = MDTPreset["text"],
                        version = MDTPreset["uid"],
                        icon = "Interface\\AddOns\\" .. QuaziiUI:GetName() .. "\\assets\\quaziiLogo.tga"
                    }
                )
            end
        end
    else
        table.insert(
            data,
            {
                name = L["MDTNotLoaded"],
                version = "",
                icon = "Interface\\AddOns\\" .. QuaziiUI:GetName() .. "\\assets\\quaziiLogo.tga"
            }
        )
    end
    page.mdtScrollBox:SetData(data)
    page.mdtScrollBox:Refresh()
end

---@param index integer
local function onCategoryClick(_, _, index)
    currentCategory = index
    fillMDTFromCategoryIndex(currentCategory)
end

local function fillSelectionDropdown()
    local options = {}
    for index, category in ipairs(QuaziiUI.imports.MDT) do
        local label = category.color and "|c" .. category.color .. category.name .. "|r" or category.name
        table.insert(options, {value = index, label = label, onclick = onCategoryClick})
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
                line.importButton:SetClickFunction(
                    function()
                        local MDTPreset = MDT:StringToTable(QuaziiUI.imports.MDT[currentCategory].Routes[index], true)
                        if MDT:ValidateImportPreset(MDTPreset) then
                            QuaziiUI:importMDTRoute(MDTPreset)
                        end
                    end
                )
            end
        end
    end
end

local function createMDTButton(self, index)
    local line = CreateFrame("Button", nil, self, "BackdropTemplate")
    line:SetClipsChildren(true)
    line:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -((index - 1) * (self.LineHeight + 1)) - 1)
    line:SetSize(555, self.LineHeight)
    line:SetBackdrop(
        {
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tileSize = 64,
            tile = true
        }
    )
    line:SetBackdropColor(0.8, 0.8, 0.8, 0.2)
    QuaziiUI.DF:Mixin(line, QuaziiUI.DF.HeaderFunctions)

    line.icon = line:CreateTexture(nil, "OVERLAY")
    line.icon:SetSize(42, 42)
    line.nameLabel = QuaziiUI.DF:CreateLabel(line, "", 16)
    line.versionLabel = QuaziiUI.DF:CreateLabel(line, "", 16)
    line.nameLabel:SetSize(318, self.LineHeight / 2)
    line.versionLabel:SetSize(68, self.LineHeight / 2)
    line.versionLabel:SetJustifyH("CENTER")

    line.importButton = QuaziiUI.DF:CreateButton(line, nil, 105, 30, L["Import"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    line.importButton.text_overlay:SetFont("Interface\\AddOns\\QuaziiUI\\assets\\accidental_pres.ttf", 16)

    line:AddFrameToHeaderAlignment(line.icon)
    line:AddFrameToHeaderAlignment(line.nameLabel)
    line:AddFrameToHeaderAlignment(line.versionLabel)
    line:AddFrameToHeaderAlignment(line.importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")

    return line
end

-- Page Creation
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateDescription(frame)
    self:CreateSelectionDropdown(frame)
    self:CreateMDTList(frame)

    self.rootFrame = frame
    fillMDTFromCategoryIndex(1)
    return frame
end

function page:CreateHeader(frame)
    local header = QuaziiUI.DF:CreateLabel(frame, "|c" .. QuaziiUI.highlightColorHex .. L["MDTHeader"] .. "|r", QuaziiUI.PageHeaderSize)
    header:SetFont("Interface\\AddOns\\QuaziiUI\\assets\\accidental_pres.ttf", QuaziiUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateDescription(frame)
    local text = QuaziiUI.DF:CreateLabel(frame, L["MDTText"], QuaziiUI.PageTextSize)
    text:SetFont("Interface\\AddOns\\QuaziiUI\\assets\\accidental_pres.ttf", QuaziiUI.PageTextSize)
    text:SetWordWrap(true)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    self.descriptionText = text
end

function page:CreateSelectionDropdown(frame)
    local selectionDropdown = QuaziiUI.DF:CreateDropDown(frame, fillSelectionDropdown, nil, 200, 25, nil, nil, QuaziiUI.ODT)
    selectionDropdown:SetPoint("TOPLEFT", self.descriptionText, "BOTTOMLEFT", -1, -5)
    selectionDropdown.label:SetFont("Interface\\AddOns\\QuaziiUI\\assets\\accidental_pres.ttf", 16)
end

function page:CreateMDTList(frame)
    local headerTable = {
        {text = L["Icon"], width = 50, offset = 1},
        {text = L["Name"], width = 310},
        {text = L["Version"], width = 81},
        {text = L["Import"], width = 110}
    }
    local options = {text_size = QuaziiUI.TableHeaderSize}
    frame.addonHeader = QuaziiUI.DF:CreateHeader(frame, headerTable, options, "QuaziiUIInstallMDTHeader")
    frame.addonHeader:SetPoint("TOPLEFT", self.descriptionText.widget, "BOTTOMLEFT", -2, -35)

    local mdtScrollBox = QuaziiUI.DF:CreateScrollBox(frame, nil, mdtScrollBoxUpdate, {}, 557, 288, 0, 40, createMDTButton, true)
    mdtScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    mdtScrollBox.ScrollBar.scrollStep = 40
    QuaziiUI.DF:ReskinSlider(mdtScrollBox)
    self.mdtScrollBox = mdtScrollBox
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
