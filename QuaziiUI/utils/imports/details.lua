function QuaziiUI:importDetailsProfile()
    self.DF:ShowTextPromptPanel(
        "Insert a Name for the New Details Profile:",
        function(newProfileName)
            self.db.profile.imports.Details = {}
            self.db.profile.imports.Details.date = GetServerTime()
            self.db.profile.imports.Details.versionNumber = self.versionNumber
            Details:ImportProfile(self.imports.Details.data, newProfileName)
            self.db.char.openPage = 2
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
