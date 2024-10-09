---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local dbDefaults = {imports = {}}
local L = QUI.L

-- Page Functions
local function AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ""
    for i = 1, select("#", ...) do
        command = select(i, ...)
        _G["SLASH_" .. name .. i] = command
    end
end

local selectPage
do
    QUI.frames.eventListener = CreateFrame("Frame")
    QUI.frames.eventListener:RegisterEvent("PLAYER_ENTERING_WORLD") -- Register Event to Listen for
    QUI.frames.eventListener:RegisterEvent("ADDON_LOADED") -- Register Event to Listen for

    local shown = false

    local function loadDB(database)
        for key, value in pairs(dbDefaults) do
            if (not database[key]) then
                database[key] = value
            end
        end
    end

    local function ShouldShow()
        local isNotDone = not QuaziiUI_CDB.isDone -- Has not finished installer before
        local lastVersion = QuaziiUI_CDB.lastVersion or 0 -- Attempts to set to lastVersion, if not found sets to 0
        local noLastPage = QuaziiUI_CDB.lastPage ~= nil -- Hasn't finished on a page before
        return isNotDone or lastVersion < QUI.version or noLastPage
    end

    QUI.frames.eventListener:SetScript(
        "OnEvent",
        function(self, event, ...)
            if (event == "PLAYER_ENTERING_WORLD" and not shown) then -- if Event is Player Loading in
                if (ShouldShow()) then -- Check if Should Show
                    QUI:Show() -- If we should, show frame
                    QuaziiUI_CDB.lastVersion = QUI.version -- Update lastVersion to current addon version
                    shown = true -- Set shown to true
                end
            elseif (event == "ADDON_LOADED") then
                local loadedAddonName = ... -- Get Loaded Addon Name

                if loadedAddonName == addonName then -- if Loaded Addon is outs
                    QuaziiUI_DB = QuaziiUI_DB or {} -- Init Addon DB
                    QuaziiUI_CDB = QuaziiUI_CDB or {} -- Init Character Addon DB
                    loadDB(QuaziiUI_DB) -- Load Addon DB
                    loadDB(QuaziiUI_CDB) -- Load Character Addon DB
                    QUI.selectPage(QuaziiUI_CDB.openPage or 1) -- Open last open page or page 1
                    AddSlashCommand(
                        "QUAZIIUISHOW",
                        function()
                            QUI.selectPage(QuaziiUI_CDB.openPage or 1)
                            QUI:Show()
                        end,
                        "/qui"
                    )
                    AddSlashCommand(
                        "QUAZIIUIRELOAD",
                        function()
                            ReloadUI()
                        end,
                        "/rl"
                    )
                end
            end
        end
    )
end

local function createPages(parentFrame)
    for i, page in ipairs(QUI.pagePrototypes) do
        page:Create(parentFrame)
    end
end

function QUI.selectPage(pageIndex)
    ---@type integer
    QuaziiUI_CDB.selectedPage = pageIndex
    QuaziiUI_CDB.shownPages = 0

    for i, page in ipairs(QUI.pagePrototypes) do
        if not page:ShouldShow() then
            page:Hide()
        else
            QuaziiUI_CDB.shownPages = QuaziiUI_CDB.shownPages + 1
            if QuaziiUI_CDB.shownPages == pageIndex then
                QuaziiUI_CDB.openPage = pageIndex
                page:Show()
            else
                page:Hide()
            end
        end
    end
end

local function selectNextPage()
    if ((QuaziiUI_CDB.selectedPage or 0) < QuaziiUI_CDB.shownPages) then -- If selectedPage is less than total pages
        QUI.selectPage(QuaziiUI_CDB.selectedPage + 1) -- Show next page
    else -- If last page or higher
        QUI.frames.main:Hide() -- Hide installer UI
        QuaziiUI_CDB.isDone = true -- Set done as true
        ReloadUI() -- reload UI
    end
    QuaziiUI_CDB.openPage = nil
end

local function selectIndexPage()
    QUI.selectPage(2)
end

local function selectPreviousPage()
    if QuaziiUI_CDB.selectedPage > 1 then
        QUI.selectPage(QuaziiUI_CDB.selectedPage - 1)
    end
end

-- Frame Template Functions
function QUI:CreateImportFrame(parentPanel, addonName, importLabel, importFunction)
    local frame = CreateFrame("Frame", nil, parentPanel)
    frame:SetHeight(100)

    local profileText = DF:CreateLabel(frame, "", QUI.TableHeaderSize)
    profileText:SetPoint("TOPLEFT", frame, "TOPLEFT")

    -- Button Template
    local importProfileButton =
        DF:CreateButton(frame, importFunction, 90, 25, "Import", nil, nil, nil, nil, nil, nil, QUI.ODT)
    importProfileButton:SetPoint("LEFT", profileText, "RIGHT", 10) -- Attach Button to profileText Label
    importProfileButton.text_overlay:SetFont(importProfileButton.text_overlay:GetFont(), QUI.TableTextSize) -- Set Button Font Size

    local lastImportLabel = DF:CreateLabel(frame, "Last Import Time:", QUI.TableTextSize)
    lastImportLabel:SetPoint("TOPRIGHT", profileText, "BOTTOMRIGHT", 0, -3)
    local versionLabel = DF:CreateLabel(frame, "Version: ", QUI.TableTextSize)
    versionLabel:SetPoint("TOPRIGHT", lastImportLabel, "BOTTOMRIGHT", 4, -3)

    local lastImportText = DF:CreateLabel(frame, "", QUI.TableTextSize)
    lastImportText:SetPoint("LEFT", lastImportLabel, "RIGHT", 10, 0)
    local versionText = DF:CreateLabel(frame, "", QUI.TableTextSize)
    versionText:SetPoint("LEFT", versionLabel, "RIGHT", 6, 0)

    local function update()
        local addonLoaded = C_AddOns and C_AddOns.IsAddOnLoaded(addonName)
        local addonRealName = addonLoaded and select(2, C_AddOns and C_AddOns.GetAddOnInfo(addonName)) or addonName

        local updateLabel = addonRealName

        if not importLabel ~= nil then
            updateLabel = importLabel
        end

        profileText:SetText("|c" .. QUI.highlightColorHex .. updateLabel .. " Profile|r:")
        frame:SetWidth(profileText:GetStringWidth() + 100)

        if (not addonLoaded) then
            importProfileButton:Disable()
            importProfileButton:SetText(L["NA"])
        else
            importProfileButton:Enable()
            importProfileButton:SetText(L["Import"])
        end
        importProfileButton:SetWidth(importProfileButton.button.text:GetStringWidth() + 10)
    end

    frame:SetScript("OnShow", update)

    frame.lastImportText = lastImportText
    frame.versionText = versionText

    return frame
end

-- Create Main UI Frame
local function createPanel()
    -- Init panel
    local panel = DF:CreateSimplePanel(UIParent, 600, 500, L["AddonName"] .. " v" .. QUI.version) -- Create a 600x500 panel
    DF:ApplyStandardBackdrop(panel) -- Give it a basic backdrop

    -- Panel Border
    DF:CreateBorder(panel) -- Give it a border
    panel:SetBorderColor(unpack(QUI.highlightColorRGBA)) -- Sets border color to Quazii Blue RGBA

    -- Panel Title Bar
    panel.Title:SetFont(panel.Title:GetFont(), 18) -- Set Title Font Size to 18
    panel.Title:SetTextColor(unpack(QUI.textColorRGBA)) -- Set Text Color
    panel.Title:SetPoint("CENTER", panel.TitleBar, "CENTER", 0, 1) -- Center Title Text in the Title Bar, offset 1 Y pixel

    -- Panel Options
    panel:ClearAllPoints() -- Resets Panel Anchor point
    panel:SetPoint("CENTER", UIParent, "CENTER") -- Centers Panel on Screen
    panel:SetFrameStrata("DIALOG") -- We use Dialog to ensure it is above most other elements
    panel:SetFrameLevel(100) -- Same as above line
    panel:SetLayerVisibility(true, false, false) -- DFramework Layer Visibilty options, we only use layer 1, so others are set to false

    -- Previous Button
    local previousButton =
        DF:CreateButton(panel, selectPreviousPage, 90, 40, "<- " .. L["Back"], nil, nil, nil, nil, nil, nil, QUI.ODT)
    previousButton:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 10, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    previousButton.text_overlay:SetFont(previousButton.text_overlay:GetFont(), 18) -- Set Font Size
    previousButton:SetTextColor(unpack(QUI.textColorRGBA)) -- Set Text to Text Color

    -- Index Button
    local indexButton =
        DF:CreateButton(panel, selectIndexPage, 90, 40, "- " .. L["Index"] .. " -", nil, nil, nil, nil, nil, nil, QUI.ODT)
    indexButton:SetPoint("BOTTOM", panel, "BOTTOM", 0, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    indexButton.text_overlay:SetFont(indexButton.text_overlay:GetFont(), 18) -- Set Font Size
    indexButton:SetTextColor(unpack(QUI.textColorRGBA)) -- Set Text to Text Color

    -- Next Button
    local nextButton =
        DF:CreateButton(panel, selectNextPage, 90, 40, L["Next"] .. " ->", nil, nil, nil, nil, nil, nil, QUI.ODT)
    nextButton:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 5) -- Anchor Button to Bottom Right of Panel, with 5 pixel buffer
    nextButton.text_overlay:SetFont(nextButton.text_overlay:GetFont(), 18) -- Set Font Size
    nextButton:SetTextColor(unpack(QUI.textColorRGBA)) -- Set Text to Text Color

    -- Panel Content Frame
    local panelContentFrame = CreateFrame("Frame", nil, panel)
    panelContentFrame:SetPoint("TOPLEFT", panel.TitleBar, "BOTTOMLEFT", 0, -5) -- Set Top Left anchor to Bottom Left anchor of TitleBar, with 5px buffer
    panelContentFrame:SetPoint("TOPRIGHT", panel.TitleBar, "BOTTOMRIGHT", 0, -5) -- Above but for Top Right / Bottom Right
    panelContentFrame:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 48) -- Set Bottom Left Anchor to Bottom Left anchor of panel, with 48px buffer for buttons
    panelContentFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 48) -- Above for Bottom Right

    panel.frameContent = panelContentFrame
    QUI.frames.main = panel
    createPages(panel)
end

createPanel()
