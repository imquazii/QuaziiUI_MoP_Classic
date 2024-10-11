function QuaziiUI.importPlaterProfile(self)
    QuaziiUI.DF:ShowTextPromptPanel(
        "Insert a Name for the New Plater Profile:",
        function(newProfileName)
            QuaziiUI.db.profile.imports.Plater = {}
            QuaziiUI.db.profile.imports.Plater.date = GetServerTime()
            QuaziiUI.db.profile.imports.Plater.versionNumber = QuaziiUI.versionNumber
            Plater.OpenOptionsPanel()
            PlaterOptionsPanelFrame:Hide()

            local profileFrame = PlaterOptionsPanelContainer.AllFrames[22]
            profileFrame.ImportStringField.importDataText = QuaziiUI.imports.Plater["data"]
            profileFrame.NewProfileTextEntry:SetText(newProfileName)
            QuaziiUI.db.char.openPage = 1
            profileFrame.ConfirmImportProfile()
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
