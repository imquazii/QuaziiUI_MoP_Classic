local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pagePrototypes, page)

local function addonScrollBoxUpdate(self, data, offset, totalLines)
    for i = 1, totalLines do
        local index = i + offset
        local info = data[index]
        if info then
            local line = self:GetLine(i)
            local addonTitle = C_AddOns and C_AddOns.GetAddOnInfo(info)
            local addonEnabled = C_AddOns and C_AddOns.IsAddOnLoaded(info)
            line.addonLabel:SetText(addonTitle or info)
            line.versionLabel:SetText(addonTitle and C_AddOns and C_AddOns.GetAddOnMetadata(info, "Version") or L["NA"])
            line.enabledLabel:SetText(
                addonEnabled and "|cff00ff00" .. L["True"] .. "|r" or "|cffff0000" .. L["False"] .. "|r"
            )
            if addonTitle == "ElvUI" then
                if addonEnabled then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(3)
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "WeakAuras" then
                if addonEnabled then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(4)
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "MythicDungeonTools" then
                if addonEnabled then
                    line.importButton:SetText(L["GoToPage"])
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:selectPage(5)
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "Cell" then
                if addonEnabled then
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importCellProfile()
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "Plater" then
                if addonEnabled then
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importPlaterProfile()
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "BigWigs" then
                if addonEnabled then
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importBigWigsProfile()
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "Details" then
                if addonEnabled then
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importDetailsProfile()
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            elseif addonTitle == "OmniCD" then
                if addonEnabled then
                    line.importButton:SetClickFunction(
                        function()
                            QuaziiUI:importOmniCDProfile()
                        end
                    )
                else
                    line.importButton:Disable()
                    line.importButton:SetText(L["NA"])
                end
            end
        end
    end
end

---@param index integer
local function createAddonButton(self, index)
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

    line.addonLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.addonLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.versionLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.versionLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.enabledLabel = QuaziiUI.DF:CreateLabel(line, nil, QuaziiUI.TableTextSize)
    line.enabledLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    line.importButton = QuaziiUI.DF:CreateButton(line, nil, 105, 30, L["Import"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
    line.importButton.text_overlay:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)

    line:AddFrameToHeaderAlignment(line.addonLabel)
    line:AddFrameToHeaderAlignment(line.enabledLabel)
    line:AddFrameToHeaderAlignment(line.versionLabel)
    line:AddFrameToHeaderAlignment(line.importButton)
    line:AlignWithHeader(self:GetParent().addonHeader, "LEFT")

    return line
end

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateDescription(frame)
    self:CreateAddonList(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateHeader(frame)
    local header =
        QuaziiUI.DF:CreateLabel(frame, "|c" .. QuaziiUI.highlightColorHex .. L["SupportedAddonsHeader"] .. "|r", QuaziiUI.PageHeaderSize)
    header:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateDescription(frame)
    local description = QuaziiUI.DF:CreateLabel(frame, L["SupportedAddonsText"], QuaziiUI.PageTextSize)
    description:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    description:SetWordWrap(true)
    description:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    description:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -40)
    description:SetJustifyH("LEFT")
    description:SetJustifyV("TOP")
    self.description = description
end

function page:CreateAddonList(frame)
    local headerTable = {
        -- Widths should add to 551
        {text = "|c" .. QuaziiUI.highlightColorHex .. L["SupportedAddonsTable1stHeader"], width = 221, offset = 2},
        {text = L["SupportedAddonsTable2ndHeader"], width = 70},
        {text = L["SupportedAddonsTable3rdHeader"], width = 150},
        {text = L["Import"], width = 110}
    }
    local options = {text_size = QuaziiUI.TableHeaderSize}
    frame.addonHeader = QuaziiUI.DF:CreateHeader(frame, headerTable, options, "QuaziiUIInstallAddonHeader")
    frame.addonHeader:SetPoint("TOPLEFT", self.description.widget, "BOTTOMLEFT", -2, -10)

    local addonScrollBox =
        QuaziiUI.DF:CreateScrollBox(frame, nil, addonScrollBoxUpdate, {}, 557, 281, 0, 34, createAddonButton, true)
    addonScrollBox:SetPoint("TOPLEFT", frame.addonHeader, "BOTTOMLEFT", 0, 0)
    addonScrollBox.ScrollBar.scrollStep = 34
    QuaziiUI.DF:ReskinSlider(addonScrollBox)
    addonScrollBox:SetData(QuaziiUI.supportedAddons)
    addonScrollBox:Refresh()
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
