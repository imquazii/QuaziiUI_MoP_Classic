---@type string
local addonName = ...

---@class QUI
local QUI = select(2, ...)

local DF = _G["DetailsFramework"]

QUI.pagePrototypes = QUI.pagePrototypes or {}
local page = {}
table.insert(QUI.pagePrototypes, page)

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    page.rootFrame = frame
end

function page:ShouldShow()
    return true
end

function page:Show()
    page.rootFrame:Show()
end

function page:Hide()
    page.rootFrame:Hide()
end
