local L = QuaziiUI.L

-- Page Functions
local function createPages(parentFrame)
    for i, page in ipairs(QuaziiUI.pagePrototypes) do
        page:Create(parentFrame)
    end
end

function QuaziiUI.selectPage(pageIndex)
    ---@type integer
    QuaziiUI.db.char.selectedPage = pageIndex
    QuaziiUI.db.char.shownPages = 0

    for i, page in ipairs(QuaziiUI.pagePrototypes) do
        if not page:ShouldShow() then
            page:Hide()
        else
            QuaziiUI.db.char.shownPages = QuaziiUI.db.char.shownPages + 1
            if QuaziiUI.db.char.shownPages == pageIndex then
                QuaziiUI.db.char.openPage = pageIndex
                page:Show()
            else
                page:Hide()
            end
        end
    end
end

local function selectNextPage()
    if ((QuaziiUI.db.char.selectedPage or 0) < QuaziiUI.db.char.shownPages) then -- If selectedPage is less than total pages
        QuaziiUI.db.char.openPage = QuaziiUI.db.char.selectedPage + 1
        QuaziiUI.selectPage(QuaziiUI.db.char.openPage) -- Show next page
    else -- If last page or higher
        QuaziiUI.frames.main:Hide() -- Hide installer UI
        QuaziiUI.db.char.isDone = true -- Set done as true
        ReloadUI() -- reload UI
    end
    QuaziiUI.db.char.openPage = nil
end

local function selectIndexPage()
    QuaziiUI.db.char.openPage = 2
    QuaziiUI.selectPage(2)
end

local function selectPreviousPage()
    if QuaziiUI.db.char.selectedPage > 1 then
        QuaziiUI.db.char.openPage = QuaziiUI.db.char.selectedPage - 1
        QuaziiUI.selectPage(QuaziiUI.db.char.openPage)
    end
end

-- Frame Template Functions
function QuaziiUI:CreateImportFrame(parentPanel, addonName, importLabel, importFunction)
    local frame = CreateFrame("Frame", nil, parentPanel)
    frame:SetHeight(100)

    local profileText = QuaziiUI.DF:CreateLabel(frame, "", QuaziiUI.TableHeaderSize)
    profileText:SetPoint("TOPLEFT", frame, "TOPLEFT")

    -- Button Template
    local importProfileButton =
        QuaziiUI.DF:CreateButton(frame, importFunction, 90, 25, L["Import"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    importProfileButton:SetPoint("LEFT", profileText, "RIGHT", 10) -- Attach Button to profileText Label
    importProfileButton.text_overlay:SetFont(importProfileButton.text_overlay:GetFont(), QuaziiUI.TableTextSize) -- Set Button Font Size

    local lastImportLabel = QuaziiUI.DF:CreateLabel(frame, L["ImportLastImportText"], QuaziiUI.TableTextSize)
    lastImportLabel:SetPoint("TOPRIGHT", profileText, "BOTTOMRIGHT", 0, -3)
    local versionLabel = QuaziiUI.DF:CreateLabel(frame, L["Version"] ..": ", QuaziiUI.TableTextSize)
    versionLabel:SetPoint("TOPRIGHT", lastImportLabel, "BOTTOMRIGHT", 4, -3)

    local lastImportText = QuaziiUI.DF:CreateLabel(frame, "", QuaziiUI.TableTextSize)
    lastImportText:SetPoint("LEFT", lastImportLabel, "RIGHT", 10, 0)
    local versionText = QuaziiUI.DF:CreateLabel(frame, "", QuaziiUI.TableTextSize)
    versionText:SetPoint("LEFT", versionLabel, "RIGHT", 6, 0)

    local function update()
        local addonLoaded = C_AddOns and C_AddOns.IsAddOnLoaded(addonName)
        local addonRealName = addonLoaded and select(2, C_AddOns and C_AddOns.GetAddOnInfo(addonName)) or addonName

        local updateLabel = addonRealName

        if not importLabel ~= nil then
            updateLabel = importLabel
        end

        profileText:SetText("|c" .. QuaziiUI.highlightColorHex .. updateLabel .. L["ImportProfileText"] .. "|r")
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
    
    local panel = QuaziiUI.DF:CreateSimplePanel(UIParent, 600, 500, L["AddonName"] .. QuaziiUI.versionString) -- Create a 600x500 panel
    QuaziiUI.DF:ApplyStandardBackdrop(panel) -- Give it a basic backdrop

    -- Panel Border
    QuaziiUI.DF:CreateBorder(panel) -- Give it a border
    panel:SetBorderColor(unpack(QuaziiUI.highlightColorRGBA)) -- Sets border color to Quazii Blue RGBA

    -- Panel Title Bar
    panel.Title:SetFont(panel.Title:GetFont(), 18) -- Set Title Font Size to 18
    panel.Title:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text Color
    panel.Title:SetPoint("CENTER", panel.TitleBar, "CENTER", 0, 1) -- Center Title Text in the Title Bar, offset 1 Y pixel

    -- Panel Options
    panel:ClearAllPoints() -- Resets Panel Anchor point
    panel:SetPoint("CENTER", UIParent, "CENTER") -- Centers Panel on Screen
    panel:SetFrameStrata("DIALOG") -- We use Dialog to ensure it is above most other elements
    panel:SetFrameLevel(100) -- Same as above line
    panel:SetLayerVisibility(true, false, false) -- DFramework Layer Visibilty options, we only use layer 1, so others are set to false

    -- Previous Button
    local previousButton =
        QuaziiUI.DF:CreateButton(panel, selectPreviousPage, 90, 40, "<- " .. L["Back"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    previousButton:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 10, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    previousButton.text_overlay:SetFont(previousButton.text_overlay:GetFont(), 18) -- Set Font Size
    previousButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Index Button
    local indexButton =
        QuaziiUI.DF:CreateButton(panel, selectIndexPage, 90, 40, "- " .. L["Index"] .. " -", nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    indexButton:SetPoint("BOTTOM", panel, "BOTTOM", 0, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    indexButton.text_overlay:SetFont(indexButton.text_overlay:GetFont(), 18) -- Set Font Size
    indexButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Next Button
    local nextButton =
        QuaziiUI.DF:CreateButton(panel, selectNextPage, 90, 40, L["Next"] .. " ->", nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    nextButton:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 5) -- Anchor Button to Bottom Right of Panel, with 5 pixel buffer
    nextButton.text_overlay:SetFont(nextButton.text_overlay:GetFont(), 18) -- Set Font Size
    nextButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Panel Content Frame
    local panelContentFrame = CreateFrame("Frame", nil, panel)
    panelContentFrame:SetPoint("TOPLEFT", panel.TitleBar, "BOTTOMLEFT", 0, -5) -- Set Top Left anchor to Bottom Left anchor of TitleBar, with 5px buffer
    panelContentFrame:SetPoint("TOPRIGHT", panel.TitleBar, "BOTTOMRIGHT", 0, -5) -- Above but for Top Right / Bottom Right
    panelContentFrame:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 48) -- Set Bottom Left Anchor to Bottom Left anchor of panel, with 48px buffer for buttons
    panelContentFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 48) -- Above for Bottom Right

    panel.frameContent = panelContentFrame
    QuaziiUI.frames.main = panel
    createPages(panel)
end

createPanel()
