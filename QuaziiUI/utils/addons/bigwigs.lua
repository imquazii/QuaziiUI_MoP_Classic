function QuaziiUI:importBigWigsProfile()
    local profileName = "QuaziiUI"
    BigWigsAPI:ImportProfileString(
        self:GetName(),
        self.imports.BigWigs.data,
        profileName,
        function(accepted)
            if accepted then
                self.db.profile.imports.BigWigs = {}
                self.db.profile.imports.BigWigs.date = GetServerTime()
                self.db.profile.imports.BigWigs.versionNumber = self.versionNumber
                self.db.char.openPage = 1
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles =
                    BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles or {}
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles[profileName] = self.imports.BigWigsColors
            end
        end
    )
end
