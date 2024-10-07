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
local function updateDisplay()
    if QuaziiUI_DB and QuaziiUI_DB.imports.Details then
        page.lastDetailsImportTime:SetText(
            date("%m/%d/%y", QuaziiUI_DB.imports.Details.date))
        page.lastDetailsVersion:SetText(QuaziiUI_DB.imports.Details.version)
    else
        page.lastDetailsImportTime:SetText(L["NA"])
        page.lastDetailsVersion:SetText(L["NA"])
    end

    if QuaziiUI_DB and QuaziiUI_DB.imports.OmniCD then
        page.lastOmniCDImportTime:SetText(date("%m/%d/%y",
                                               QuaziiUI_DB.imports.OmniCD.date))
        page.lastOmniCDVersion:SetText(QuaziiUI_DB.imports.OmniCD.version)
    else
        page.lastOmniCDImportTime:SetText(L["NA"])
        page.lastOmniCDVersion:SetText(L["NA"])
    end
    if QuaziiUI_DB and QuaziiUI_DB.imports.Plater then
        page.lastPlaterImportTime:SetText(date("%m/%d/%y",
                                               QuaziiUI_DB.imports.Plater.date))
        page.lastPlaterVersion:SetText(QuaziiUI_DB.imports.Plater.version)
    else
        page.lastPlaterImportTime:SetText(L["NA"])
        page.lastPlaterVersion:SetText(L["NA"])
    end

    if QuaziiUI_DB and QuaziiUI_DB.imports.BigWigs then
        page.lastBigWigsImportTime:SetText(
            date("%m/%d/%y", QuaziiUI_DB.imports.BigWigs.date))
        page.lastBigWigsVersion:SetText(QuaziiUI_DB.imports.BigWigs.version)
    else
        page.lastBigWigsImportTime:SetText(L["NA"])
        page.lastBigWigsVersion:SetText(L["NA"])
    end
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    local mainLabel = DF:CreateLabel(frame, "|c" .. QUI.highlightColorHex ..
                                         "Other Addon Imports|r",
                                     QUI.PageHeaderSize)
    mainLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -20)
    mainLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -20)
    mainLabel:SetJustifyH("CENTER")
    mainLabel:SetJustifyV("TOP")
    local detailsImportContainer = QUI:CreateImportFrame(frame, "Details",
                                                         "Details", nil, nil,
                                                         nil, function()
        QUI.importDetailsProfile()
        updateDisplay()
    end)
    detailsImportContainer:SetPoint("TOPRIGHT", mainLabel.widget, "BOTTOM", -15,
                                    -20)
    local PlaterImportContainer = QUI:CreateImportFrame(frame, "Plater",
                                                        "Plater", nil, nil, nil,
                                                        function()
        QUI.importPlaterProfile()
        updateDisplay()
    end)
    PlaterImportContainer:SetPoint("LEFT", detailsImportContainer, "RIGHT", 30,
                                   0)
    local BigWigsImportContainer = QUI:CreateImportFrame(frame, "BigWigs",
                                                         "BigWigs", nil, nil,
                                                         nil, function()
        QUI.importBigWigsProfile()
        updateDisplay()
    end)
    BigWigsImportContainer:SetPoint("TOP", detailsImportContainer, "BOTTOM", 0,
                                    20)
    local OmniCDImportContainer = QUI:CreateImportFrame(frame, "OmniCD",
                                                        "OmniCD", nil, nil, nil,
                                                        function()
        updateDisplay()
        QUI.importOmniCDProfile()
    end)
    OmniCDImportContainer:SetPoint("TOPRIGHT", PlaterImportContainer,
                                   "BOTTOMRIGHT", 0, 20)

    page.lastDetailsImportTime = detailsImportContainer.lastImportText
    page.lastDetailsVersion = detailsImportContainer.versionText
    page.lastBigWigsImportTime = BigWigsImportContainer.lastImportText
    page.lastBigWigsVersion = BigWigsImportContainer.versionText
    page.lastPlaterImportTime = PlaterImportContainer.lastImportText
    page.lastPlaterVersion = PlaterImportContainer.versionText
    page.lastOmniCDImportTime = OmniCDImportContainer.lastImportText
    page.lastOmniCDVersion = OmniCDImportContainer.versionText
    page.rootFrame = frame

end
function page:ShouldShow() return true end
function page:Show()
    updateDisplay()
    page.rootFrame:Show()
end
function page:Hide() page.rootFrame:Hide() end
