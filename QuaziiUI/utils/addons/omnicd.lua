function QuaziiUI:importOmniCDProfile()
    self.DF:ShowPromptPanel(
        "Are you sure you want to import/update OmniCD profile?",
        function()
            self.db.profile.imports.OmniCD = {}
            self.db.profile.imports.OmniCD.date = GetServerTime()
            self.db.profile.imports.OmniCD.versionNumber = self.versionNumber
            local OmniCD = OmniCD[1]
            local Profile = OmniCD.ProfileSharing
            local profileType, profileKey, profileData = Profile:Decode(self.imports.OmniCD.data)
            Profile:CopyProfile(profileType, profileKey, profileData)
            self.db.char.openPage = 2
        end,
        function()
        end,
        true
    )
end
