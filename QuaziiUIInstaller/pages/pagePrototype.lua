local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pagePrototypes, page)

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()
    page.rootFrame = frame
    return frame
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
