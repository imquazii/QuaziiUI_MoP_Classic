---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local L = QUI.L
local DF = _G["DetailsFramework"]

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)
QUI.pageIndex = #QUI.pagePrototypes

-- Utility Functions
local function updateAddonDisplay(addonName)
    local importInfo = QuaziiUI_DB and QuaziiUI_DB.imports[addonName]
    if importInfo then
        page["last" .. addonName .. "ImportTime"]:SetText(date("%m/%d/%y", importInfo.date))
        page["last" .. addonName .. "Version"]:SetText(importInfo.version)
    else
        page["last" .. addonName .. "ImportTime"]:SetText(L["NA"])
        page["last" .. addonName .. "Version"]:SetText(L["NA"])
    end
end

local function updateDisplay()
    updateAddonDisplay("Details")
    updateAddonDisplay("OmniCD")
    updateAddonDisplay("Plater")
    updateAddonDisplay("BigWigs")
end

-- Main Page Functions
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateImportFrames(frame)

    self.rootFrame = frame
end

function page:CreateHeader(frame)
    local mainLabel = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex .. "Other Addon Imports|r", QUI.PageHeaderSize)
    mainLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    mainLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    mainLabel:SetJustifyH("CENTER")
    mainLabel:SetJustifyV("TOP")
    frame.headerAnchor = mainLabel.widget
end

function page:CreateImportFrames(frame)
    local headerHeight = frame.headerAnchor:GetHeight()
    local containerWidth = frame:GetWidth() / 2 - 20  -- Adjust as needed
    local containerHeight = (frame:GetHeight() - headerHeight - 60) / 2  -- Adjust as needed

    local function createContainer(addon, row, col, importFunc)
        local container = QUI:CreateImportFrame(frame, addon, addon, containerWidth, containerHeight, nil, function()
            importFunc()
            updateDisplay()
        end)
        container:SetPoint("TOPLEFT", frame, "TOPLEFT", 10 + (col - 1) * (containerWidth + 20), -headerHeight - 20 - (row - 1) * (containerHeight + 20))
        return container
    end

    local detailsContainer = createContainer("Details", 1, 1, QUI.importDetailsProfile)
    local platerContainer = createContainer("Plater", 1, 2, QUI.importPlaterProfile)
    local bigWigsContainer = createContainer("BigWigs", 2, 1, QUI.importBigWigsProfile)
    local omniCDContainer = createContainer("OmniCD", 2, 2, QUI.importOmniCDProfile)

    self.lastDetailsImportTime = detailsContainer.lastImportText
    self.lastDetailsVersion = detailsContainer.versionText
    self.lastPlaterImportTime = platerContainer.lastImportText
    self.lastPlaterVersion = platerContainer.versionText
    self.lastBigWigsImportTime = bigWigsContainer.lastImportText
    self.lastBigWigsVersion = bigWigsContainer.versionText
    self.lastOmniCDImportTime = omniCDContainer.lastImportText
    self.lastOmniCDVersion = omniCDContainer.versionText
end

function page:ShouldShow()
    return true
end

function page:Show()
    updateDisplay()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end

-- Return the page object
return page