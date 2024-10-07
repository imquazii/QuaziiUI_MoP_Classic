---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

function QUI.importOmniCDProfile(self)
    DF:ShowPromptPanel("Are you sure you want to import/update OmniCD profile?",
                       function()
        QuaziiUI_DB.imports.OmniCD = {}
        QuaziiUI_DB.imports.OmniCD.date = GetServerTime()
        QuaziiUI_DB.imports.OmniCD.version = QUI.version
        local OmniCD = OmniCD[1]
        local Profile = OmniCD.ProfileSharing
        local profileType, profileKey, profileData = Profile:Decode(
                                                         QUI["imports"]["OmniCD"]["data"])
        Profile:CopyProfile(profileType, profileKey, profileData)
        QuaziiUI_CDB.openPage = QUI.pageIndex
    end, function() end, true)
end

