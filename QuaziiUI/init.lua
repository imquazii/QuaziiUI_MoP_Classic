---@type table|AceAddon
QuaziiUI = LibStub("AceAddon-3.0"):NewAddon("QuaziiUI", "AceConsole-3.0", "AceEvent-3.0")

---@type table
QuaziiUI.DF = _G["DetailsFramework"]

---@type table
QuaziiUI.defaults = {
    profile = {
        ---@type table
        imports = {}
    },
    char = {
        ---@type boolean
        isDone = false,
        ---@type integer
        lastVersion = 0,
        ---@type integer
        shownPages = 0,
        ---@type integer
        selectedPage = 1,
        ---@type integer
        openPage = 1
    }
}

---@type table
QuaziiUI.imports = {}
---@type table
QuaziiUI.pagePrototypes = QuaziiUI.pagePrototypes or {}

function QuaziiUI:OnInitialize()
    ---@type AceDBObject-3.0
    self.db = LibStub("AceDB-3.0"):New("QuaziiUI_DB", self.defaults, true)

    self:RegisterChatCommand("qui", "SlashCommandOpen")
    self:RegisterChatCommand("rl", "SlashCommandReload")
end

function QuaziiUI:SlashCommandOpen()
    self:selectPage(QuaziiUI.db.char.openPage or 1)
    self:Show()
end

function QuaziiUI:SlashCommandReload()
    ReloadUI()
end

function QuaziiUI:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function QuaziiUI:PLAYER_ENTERING_WORLD()
    local isNotDone = not self.db.char.isDone -- Has not finished installer before
    local newVersion = (self.db.char.lastVersion or 0) < self.versionNumber -- Attempts to set to lastVersion, if not found sets to 0
    if (isNotDone) or (newVersion) then
        self:selectPage((self.db.char.openPage or 1))
        self:Show()
        self.db.char.lastVersion = self.versionNumber
    end
end
