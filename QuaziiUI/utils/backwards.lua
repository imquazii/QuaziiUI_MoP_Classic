function QuaziiUI:BackwardsCompat()
    -- Prior to 20241104 Last Version Data was stored in char-specific and default profiles
    if not self.db.global then
        self:DebugPrint("DB Global not found")
        -- Since self.db.global doesn't exist, initialize it.
        self.db.global = {
            lastVersion = 0,
            imports = {}
        }
    end
    if self.db.char then
        -- If lastVersion is specified in self.db.char, and not in db.global - move it to db.global and remove lastVErsion from char
        if self.db.char.lastVersion and not self.db.global.lastVersion then
            self:DebugPrint("Last version found in char profile, but not global.")
            self.db.global.lastVersion = self.db.char.lastVersion
            table.remove(self.db.char, 1)
        end
    end
    self:DebugPrint("Profiles.Default Exists: " .. tostring(not (not QuaziiUI_DB.profiles.Default)))
    if QuaziiUI_DB.profiles and QuaziiUI_DB.profiles.Default then
        self:DebugPrint("Profiles.Default.imports Exists: " .. tostring(not (not QuaziiUI_DB.profiles.Default.imports)))
        self:DebugPrint("global.imports Exists: " .. tostring(not (not self.db.global.imports)))
        self:DebugPrint("global.imports is {}: " .. tostring(self.db.global.imports == {}))
        -- if imports are in defualt profile db, and not in global, move them over, and remove imports from profile.
        if QuaziiUI_DB.profiles.Default.imports and (not self.db.global.imports or next(self.db.global.imports) == nil) then
            self:DebugPrint("Import Data found in profile imports but not global imports.")
            self.db.global.imports = QuaziiUI_DB.profiles.Default.imports
            table.remove(self.db.profiles, 1)
        end
    end
end
