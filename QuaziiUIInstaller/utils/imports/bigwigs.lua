local addonName = ...

function QuaziiUI.importBigWigsProfile(self)
    local profileName = "QuaziiUI"
    BigWigsAPI:ImportProfileString(
        addonName,
        QuaziiUI.imports.BigWigs.data,
        profileName,
        function(accepted)
            if accepted then
                QuaziiUI.db.profile.imports.BigWigs = {}
                QuaziiUI.db.profile.imports.BigWigs.date = GetServerTime()
                QuaziiUI.db.profile.imports.BigWigs.versionNumber = QuaziiUI.versionNumber
                QuaziiUI.db.char.openPage = 1
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles =
                    BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles or {}
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles[profileName] = QuaziiUI.imports.BigWigsColors
            end
        end
    )
end
