function QuaziiUI:Show()
    self:DebugPrint("Show Quazii UI Frame")
    self.panel:Show()
end -- Makes the installer UI visible

function QuaziiUI:Hide()
    self:DebugPrint("Hide Quazii UI Frame")
    QuaziiUI.db.global.isDone = true
    self.panel:Hide()
end -- Makes the installer UI hidden

---@param inputVersion integer|string "string|integer in the format of YYYYMMDD"
---@return string
function QuaziiUI.VersionToString(inputVersion)
    local Y, M, D = string.match(tostring(inputVersion or ""), "(%d%d%d%d)(%d%d)(%d%d)")
    if Y and M and D then
        return " v" .. Y .. "." .. M .. "." .. D
    else
        return " vUnknown"
    end
end

function QuaziiUI:DebugPrint(...)
    if self.DEBUG_MODE then
        self:Print(...)
    end
end