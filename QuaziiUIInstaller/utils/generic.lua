function QuaziiUI:Show()
    self.frames.main:Show()
end -- Makes the installer UI visible

function QuaziiUI:Hide()
    self.frames.main:Hide()
end -- Makes the installer UI hidden

---@param inputVersion integer|string "string|integer in the format of YYYYMMDD"
---@return string
function QuaziiUI.VersionToString(inputVersion) -- I
    local Y, M, D = string.match(tostring(inputVersion), "(%d%d%d%d)(%d%d)(%d%d)")
    return " v" .. Y .. "." .. M .. "." .. D
end
