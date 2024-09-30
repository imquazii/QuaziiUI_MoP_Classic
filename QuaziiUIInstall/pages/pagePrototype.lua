local addonName, addon = ...
local DF = _G.DetailsFramework
addon.pagePrototypes = addon.pagePrototypes or {}
local page = {}
table.insert(addon.pagePrototypes, page)
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    page.rootFrame = frame
end
function page:ShouldShow() return true end
function page:Show() page.rootFrame:Show() end
function page:Hide() page.rootFrame:Hide() end
