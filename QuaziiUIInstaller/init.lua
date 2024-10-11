QuaziiUI = LibStub("AceAddon-3.0"):NewAddon("QuaziiUI", "AceConsole-3.0", "AceEvent-3.0")

QuaziiUI.DF = _G["DetailsFramework"]

QuaziiUI.defaults = {
    profile = {
        imports = {}
    },
    char = {
        isDone = false,
        lastVersion = 0,
        selectedPage = 1
    }
}

QuaziiUI.imports = {}
QuaziiUI.pagePrototypes = QuaziiUI.pagePrototypes or {}

function QuaziiUI:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("QuaziiUI.db.profile", self.defaults, true)

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
    local hasopenPage = self.db.char.openPage ~= nil -- Hasn't finished on a page before

    if (isNotDone) or (newVersion) or (hasopenPage) then
        self:selectPage((self.db.char.openPage or 1))
        self:Show()
        self.db.char.lastVersion = self.versionNumber
    end
end
