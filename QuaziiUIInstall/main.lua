local addonName, addon = ...
local DF = _G.DetailsFramework
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded
local GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo
addon.color = "FF30d1ff"
addon.colorRGB = {0.188, 0.819, 1}
addon.colorRGBA = {0.188, 0.819, 1, 1}
addon.colorHighlightRGBA = addon.colorRGBA
addon.colorTextHighlightRGBA = addon.colorHighlightRGBA
addon.colorTextHighlight = addon.color
local metaVersion = GetAddOnMetadata(addonName, "Version")
addon.version = tonumber(metaVersion)
addon.frames = {}
local dbDefaults = {imports = {}}
function addon:AddonPrint(...)
    print("|c" .. addon.colorTextHighlight .. "QuaziiUIInstall|r:",
          tostringall(...))
end
function addon:AddonPrintError(...)
    print("|cffff0000QuaziiUIInstall|r|cffff9117:|r", tostringall(...))
end
function addon:ShowFrame() addon.frames.mainFrame:Show() end
function addon:HideFrame() addon.frames.mainFrame:Hide() end
function addon:ToggleFrame()
    if addon.frames.mainFrame:IsShown() then
        addon:HideFrame()
    else
        addon:ShowFrame()
    end
end
function addon:GetDisplayResolution() return GetPhysicalScreenSize() end
function addon:CreateImportFrame(parent, addonName, importLabel, addonLogo,
                                 addonLogoWidth, addonLogoHeight, importFunction)
    local container = CreateFrame("Frame", nil, parent)
    local profileText = DF:CreateLabel(container, "", 16)
    profileText:SetPoint("TOPLEFT", container, "TOPLEFT")
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local importProfileButton = DF:CreateButton(container, nil, 80, 20,
                                                "Import", nil, nil, nil, nil,
                                                nil, nil,
                                                options_dropdown_template)
    importProfileButton:SetPoint("LEFT", profileText, "RIGHT", 10)
    importProfileButton.text_overlay:SetFont(
        importProfileButton.text_overlay:GetFont(), 14)
    importProfileButton:SetClickFunction(importFunction)
    container:SetHeight(90 + addonLogoHeight)
    local lastImportLabel = DF:CreateLabel(container, "Last Import Time:", 14)
    lastImportLabel:SetPoint("TOPRIGHT", profileText, "BOTTOMRIGHT", 0, -3)
    local versionLabel = DF:CreateLabel(container, "Version:", 14)
    versionLabel:SetPoint("TOPRIGHT", lastImportLabel, "BOTTOMRIGHT", 0, -3)
    local lastImportText = DF:CreateLabel(container, "", 14)
    lastImportText:SetPoint("LEFT", lastImportLabel, "RIGHT", 10, 0)
    local versionText = DF:CreateLabel(container, "", 14)
    versionText:SetPoint("LEFT", versionLabel, "RIGHT", 10, 0)
    local logo = DF:CreateImage(container, addonLogo, addonLogoWidth,
                                addonLogoHeight)
    logo:SetPoint("TOP", container, "TOP", 0, -70)
    local function update()
        local addonLoaded = IsAddOnLoaded(addonName)
        local addonRealName =
            addonLoaded and select(2, GetAddOnInfo(addonName)) or addonName
        if not type(importLabel) == "string" then
            importLabel = addonRealName
        end
        profileText:SetText("|c" .. addon.colorTextHighlight .. importLabel ..
                                " profile|r:")
        container:SetWidth(profileText:GetStringWidth() + 100)
        if not addonLoaded then
            importProfileButton:Disable()
            importProfileButton:SetText("Addon not loaded :(")
        else
            importProfileButton:Enable()
            importProfileButton:SetText("Import")
        end
        importProfileButton:SetWidth(
            importProfileButton.button.text:GetStringWidth() + 10)
    end
    container:SetScript("OnShow", update)
    container.lastImportText = lastImportText
    container.versionText = versionText
    return container
end

function addon:CreateImportFrameNoLogo(parent, addonName, importLabel, importFunction)
    local container = CreateFrame("Frame", nil, parent)
    local profileText = DF:CreateLabel(container, "", 16)
    profileText:SetPoint("TOPLEFT", container, "TOPLEFT")
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local importProfileButton = DF:CreateButton(container, nil, 80, 20,
                                                "Import", nil, nil, nil, nil,
                                                nil, nil,
                                                options_dropdown_template)
    importProfileButton:SetPoint("LEFT", profileText, "RIGHT", 10)
    importProfileButton.text_overlay:SetFont(
        importProfileButton.text_overlay:GetFont(), 14)
    importProfileButton:SetClickFunction(importFunction)
    container:SetHeight(90)
    local lastImportLabel = DF:CreateLabel(container, "Last Import Time:", 14)
    lastImportLabel:SetPoint("TOPRIGHT", profileText, "BOTTOMRIGHT", 0, -3)
    local versionLabel = DF:CreateLabel(container, "Version:", 14)
    versionLabel:SetPoint("TOPRIGHT", lastImportLabel, "BOTTOMRIGHT", 0, -3)
    local lastImportText = DF:CreateLabel(container, "", 14)
    lastImportText:SetPoint("LEFT", lastImportLabel, "RIGHT", 10, 0)
    local versionText = DF:CreateLabel(container, "", 14)
    versionText:SetPoint("LEFT", versionLabel, "RIGHT", 10, 0)
    local function update()
        local addonLoaded = IsAddOnLoaded(addonName)
        local addonRealName =
            addonLoaded and select(2, GetAddOnInfo(addonName)) or addonName
        if not type(importLabel) == "string" then
            importLabel = addonRealName
        end
        profileText:SetText("|c" .. addon.colorTextHighlight .. importLabel ..
                                " profile|r:")
        container:SetWidth(profileText:GetStringWidth() + 100)
        if not addonLoaded then
            importProfileButton:Disable()
            importProfileButton:SetText("Addon not loaded :(")
        else
            importProfileButton:Enable()
            importProfileButton:SetText("Import")
        end
        importProfileButton:SetWidth(
            importProfileButton.button.text:GetStringWidth() + 10)
    end
    container:SetScript("OnShow", update)
    container.lastImportText = lastImportText
    container.versionText = versionText
    return container
end

function addon:HandleAceDBBullshit(database, import)
    for profileName, profile in pairs(import.profiles) do
        database.profiles[profileName] = profile
    end
    if import.namespaces then
        for namespaceName, namespace in pairs(import.namespaces) do
            if namespace.profiles then
                for namespacesProfileName, namespacesProfile in pairs(
                                                                    namespace.profiles) do
                    if database.namespaces[namespaceName] then
                        if not database.namespaces[namespaceName].profiles then
                            database.namespaces[namespaceName].profiles = {}
                        end
                        database.namespaces[namespaceName].profiles[namespacesProfileName] =
                            namespacesProfile
                    end
                end
            end
        end
    end
end
local function SlashCmdList_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ""
    for i = 1, select("#", ...) do
        command = select(i, ...)
        _G["SLASH_" .. name .. i] = command
    end
end

local selectPage
do
    addon.frames.eventListener = CreateFrame("Frame")
    addon.frames.eventListener:RegisterEvent("PLAYER_ENTERING_WORLD")
    addon.frames.eventListener:RegisterEvent("ADDON_LOADED")
    local function handleDBLoad(database)
        for k, v in pairs(dbDefaults) do
            if not database[k] then database[k] = v end
        end
    end
    local function shouldShow()
        return not QuaziiUICDB.pressedDone or (QuaziiUICDB.lastVersion or 0) <
                   addon.version or QuaziiUICDB.openPage ~= nil
    end
    local shown = false
    addon.frames.eventListener:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" and not shown then
            if shouldShow() then
                addon:ShowFrame()
                QuaziiUICDB.lastVersion = addon.version
            end
            shown = true
        elseif event == "ADDON_LOADED" then
            local loadedAddonName = ...
            if loadedAddonName == addonName then
                QuaziiUIDB = QuaziiUIDB or {}
                QuaziiUICDB = QuaziiUICDB or {}
                handleDBLoad(QuaziiUIDB)
                handleDBLoad(QuaziiUICDB)
                selectPage(QuaziiUICDB.openPage or 1)
                SlashCmdList_AddSlashCommand("QUAZIIUISHOW", function()
                    selectPage(1)
                    addon:ShowFrame()
                end, "/qui")
            end
        end
    end)
end
local function createPages(parent)
    for i, page in ipairs(addon.pagePrototypes) do page:Create(parent) end
end
function selectPage(index)
    addon.selectedPage = index
    addon.shownPages = 0
    for i, page in ipairs(addon.pagePrototypes) do
        if not page:ShouldShow() then
            page:Hide()
        else
            addon.shownPages = addon.shownPages + 1
            if addon.shownPages == index then
                page:Show()
            else
                page:Hide()
            end
        end
    end
    if addon.selectedPage == 1 then
        addon.frames.mainFrame.prevButton:Hide()
    else
        addon.frames.mainFrame.prevButton:Show()
    end
    if addon.selectedPage == addon.shownPages then
        addon.frames.mainFrame.nextButton:SetText("Done!")
    else
        addon.frames.mainFrame.nextButton:SetText("Next >>")
    end
end
local function selectNextPage()
    if addon.selectedPage < addon.shownPages then
        selectPage(addon.selectedPage + 1)
    elseif addon.selectedPage == addon.shownPages then
        addon.frames.mainFrame:Hide()
        QuaziiUICDB.pressedDone = true
        ReloadUI()
    end
    QuaziiUICDB.openPage = nil
end
local function selectPrevPage()
    if addon.selectedPage > 1 then selectPage(addon.selectedPage - 1) end
    QuaziiUICDB.openPage = nil
end
function addon:SkipPage() selectNextPage() end
local function createFrames()
    local frame = DF:CreateSimplePanel(UIParent, 500, 400,
                                       "Quazii UI Install Retail V" ..
                                           metaVersion)
    frame.Title:SetFont(frame.Title:GetFont(), 16)
    frame.Title:SetPoint("CENTER", frame.TitleBar, "CENTER", 0, 1)
    DF:ApplyStandardBackdrop(frame)
    DF:CreateBorder(frame)
    frame:SetBorderColor(unpack(addon.colorRGBA))
    frame:SetLayerVisibility(true, false, false)
    frame:ClearAllPoints()
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(100)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    local options_dropdown_template = DF:GetTemplate("dropdown",
                                                     "OPTIONS_DROPDOWN_TEMPLATE")
    local snow = {DF:ParseColors("snow")}
    local prevButton = DF:CreateButton(frame, nil, 80, 30, "<< Prev", nil, nil,
                                       nil, nil, nil, nil,
                                       options_dropdown_template)
    prevButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
    prevButton.text_overlay:SetFont(prevButton.text_overlay:GetFont(), 16)
    prevButton.text_overlay:SetTextColor(unpack(snow))
    prevButton:SetClickFunction(selectPrevPage)
    prevButton.onenter_backdrop_border_color = addon.colorHighlightRGBA
    local nextButton = DF:CreateButton(frame, nil, 80, 30, "Next >>", nil, nil,
                                       nil, nil, nil, nil,
                                       options_dropdown_template)
    nextButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
    nextButton.text_overlay:SetFont(nextButton.text_overlay:GetFont(), 16)
    nextButton.text_overlay:SetTextColor(unpack(snow))
    nextButton:SetClickFunction(selectNextPage)
    nextButton.onenter_backdrop_border_color = addon.colorHighlightRGBA
    frame.prevButton = prevButton
    frame.nextButton = nextButton
    local frameContent = CreateFrame("Frame", nil, frame)
    frameContent:SetPoint("TOPLEFT", frame.TitleBar, "BOTTOMLEFT", 0, -5)
    frameContent:SetPoint("TOPRIGHT", frame.TitleBar, "BOTTOMRIGHT", 0, -5)
    frameContent:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 38)
    frameContent:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 38)
    frame.frameContent = frameContent
    addon.frames.mainFrame = frame
    createPages(frame)
    selectPage(1)
end
createFrames()
