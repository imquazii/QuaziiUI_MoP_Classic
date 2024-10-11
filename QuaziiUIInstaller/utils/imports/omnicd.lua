function QuaziiUI.importOmniCDProfile(self)
    QuaziiUI.DF:ShowPromptPanel(
        "Are you sure you want to import/update OmniCD profile?",
        function()
            QuaziiUI.db.profile.imports.OmniCD = {}
            QuaziiUI.db.profile.imports.OmniCD.date = GetServerTime()
            QuaziiUI.db.profile.imports.OmniCD.versionNumber = QuaziiUI.versionNumber
            local OmniCD = OmniCD[1]
            local Profile = OmniCD.ProfileSharing
            local profileType, profileKey, profileData = Profile:Decode(QuaziiUI.imports.OmniCD.data)
            Profile:CopyProfile(profileType, profileKey, profileData)
            QuaziiUI.db.char.openPage = 2
        end,
        function()
        end,
        true
    )
end
