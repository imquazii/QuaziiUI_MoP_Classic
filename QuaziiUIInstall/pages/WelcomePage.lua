local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
function page:Create(parent)
    page.rootFrame = CreateFrame("Frame", nil, parent.frameContent)
    page.rootFrame:SetAllPoints()
    local header = DF:CreateLabel(page.rootFrame, "|c" ..
                                      addon.colorTextHighlight ..
                                      "Welcome to the UI import guide!|r", 18)
    header:SetPoint("TOP", page.rootFrame, "TOP", 0, -5)
    local textString =
        "This installer will take you through the steps needed to import and install Quazii's UI. \nPlease follow the instructions on each necessary step. \n\nLet's get started!"
    local text = DF:CreateLabel(page.rootFrame, textString, 16)
    text:SetPoint("TOPLEFT", page.rootFrame, "TOPLEFT", 0, -30)
    text:SetPoint("BOTTOMRIGHT", page.rootFrame, "BOTTOMRIGHT")
    text:SetSpacing(5)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local image = DF:CreateImage(page.rootFrame,
                                 "Interface\\AddOns\\QuaziiUIInstall\\assets\\quaziiLogo.png",
                                 256, 256)
    image:ClearAllPoints()
    image:SetPoint("CENTER", page.rootFrame, "CENTER", 0, -60)
    return page.rootFrame
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
