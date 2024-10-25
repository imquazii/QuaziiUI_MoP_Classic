local L = QuaziiUI.L

function QuaziiUI:importDetailsProfile()
    self.DF:ShowTextPromptPanel(
        L["DetailsPrompt"],
        function(newProfileName)
            self.db.profile.imports.Details = {}
            self.db.profile.imports.Details.date = GetServerTime()
            self.db.profile.imports.Details.versionNumber = self.versionNumber
            Details:ImportProfile(self.imports.Details.data, newProfileName, nil, nil, true)
            self.db.char.openPage = 2
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
