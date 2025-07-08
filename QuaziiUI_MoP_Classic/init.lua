---@type table|AceAddon
QuaziiUI = LibStub("AceAddon-3.0"):NewAddon("QuaziiUI_MoP_Classic", "AceConsole-3.0", "AceEvent-3.0")

-- Initialize essential tables immediately
QuaziiUI.imports = QuaziiUI.imports or {}
QuaziiUI.pages = QuaziiUI.pages or {}

---@type table<string, string>
QuaziiUI.L = LibStub("AceLocale-3.0"):GetLocale("QuaziiUI")

local L = QuaziiUI.L

---@type table
QuaziiUI.DF = _G["DetailsFramework"]
QuaziiUI.DEBUG_MODE = false

---@type table
QuaziiUI.defaults = {
    global = {
        ---@type boolean
        isDone = false,
        ---@type integer
        lastVersion = 0,
        ---@type table
        imports = {}
    },
    char = {
        ---@type integer
        shownPages = 0,
        ---@type integer
        selectedPage = 1,
        ---@type integer
        openPage = 1,
        ---@type table
        debug = {
            ---@type boolean
            reload = false
        }
    }
}

-- Tables already initialized at the top of file

function QuaziiUI:OnInitialize()
    ---@type AceDBObject-3.0
    self.db = LibStub("AceDB-3.0"):New("QuaziiUI_MoP_Classic_DB", self.defaults, "Default")

    self:RegisterChatCommand("qui", "SlashCommandOpen")
    self:RegisterChatCommand("quaziiui", "SlashCommandOpen")
    self:RegisterChatCommand("rl", "SlashCommandReload")
    
    -- Register our media files with LibSharedMedia
    self:RegisterMedia()
    
    -- Initialize DetailsFramework templates now that DF is available
    self:InitializeDetailsFrameworkTemplates()
end

function QuaziiUI:SlashCommandOpen(input)
    if input and input == "debug" then
        self.db.char.debug.reload = true
        ReloadUI()
    end
    self:InitializePanel()
    QuaziiUI_CompartmentClick()
end

function QuaziiUI:SlashCommandReload()
    ReloadUI()
end

function QuaziiUI:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function QuaziiUI:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
    QuaziiUI:BackwardsCompat()
    local isNotDone = not self.db.global.isDone
    local newVersion = (self.db.global.lastVersion or 0) < self.versionNumber

    if not self.DEBUG_MODE then
        if self.db.char.debug.reload then
            self.DEBUG_MODE = true
            self.db.char.debug.reload = false
            QuaziiUI:DebugPrint("Debug Mode Enabled")
        end
    else
        QuaziiUI:DebugPrint("Debug Mode Enabled")
    end

    if (isInitialLogin and not isReloadingUi) or self.DEBUG_MODE then
        self:Print("Thank you for using QuaziiUI!")
        self:Print("You may access the installer by using /qui or /quaziiui at anytime!")

        self:DebugPrint("Is Not Done?: ", isNotDone, " | New Version?: ", newVersion)
        if (isNotDone) or (newVersion) then
            self.db.global.lastVersion = self.versionNumber
            self:DebugPrint("Installer condition met (first run or new version), but not showing automatically.")
        end
    end
end

-- ADDON COMPARTMENT FUNCTIONS --
function QuaziiUI_CompartmentClick()
    QuaziiUI:InitializePanel() -- Ensure panel is created before showing
    QuaziiUI:selectPage(QuaziiUI.db.char.openPage or 1)
    QuaziiUI:Show()
end
local GameTooltip = GameTooltip
function QuaziiUI_CompartmentOnEnter(self, button)
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
    GameTooltip:AddLine(L["AddonName"] .. QuaziiUI.versionString)
    GameTooltip:AddLine(L["LeftClickOpen"])
    GameTooltip:Show()
end

function QuaziiUI_CompartmentOnLeave()
    GameTooltip:Hide()
end

function QuaziiUI:InitializePanel()
    if self.panelInitialized then return end -- Only run once
    self:DebugPrint("Initializing Panel UI...")
    createPanel() -- Call the actual creation function
    if self.panel then
        self.panelInitialized = true
        self:DebugPrint("Panel UI Initialized.")
    else
        self:DebugPrint("Panel UI Initialization failed - panel object not created.")
    end
end
