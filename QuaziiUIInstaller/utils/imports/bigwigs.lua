---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

function QUI.importBigWigsProfile(self)
    local profileName = "QuaziiUI"
    BigWigsAPI:ImportProfileString(
        addonName,
        QUI.imports.BigWigs.data,
        profileName,
        function(accepted)
            if accepted then
                QuaziiUI_DB.imports.BigWigs = {}
                QuaziiUI_DB.imports.BigWigs.date = GetServerTime()
                QuaziiUI_DB.imports.BigWigs.version = QUI.version
                QuaziiUI_CDB.openPage = 1
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles =
                    BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles or {}
                BigWigs3DB.namespaces.BigWigs_Plugins_Colors.profiles[profileName] = QUI.imports.BigWigsColors
            end
        end
    )
end
