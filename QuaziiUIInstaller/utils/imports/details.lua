function QuaziiUI.importDetailsProfile(self)
    QuaziiUI.DF:ShowTextPromptPanel(
        "Insert a Name for the New Details Profile:",
        function(newProfileName)
            QuaziiUI.db.profile.imports.Details = {}
            QuaziiUI.db.profile.imports.Details.date = GetServerTime()
            QuaziiUI.db.profile.imports.Details.versionNumber = QuaziiUI.versionNumber
            Details:ImportProfile(QuaziiUI.imports.Details.data, newProfileName)
            QuaziiUI.db.char.openPage = 2
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
