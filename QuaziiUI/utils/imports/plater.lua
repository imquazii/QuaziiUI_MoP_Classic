function QuaziiUI:importPlaterProfile(self)
    self.DF:ShowTextPromptPanel(
        "Insert a Name for the New Plater Profile:",
        function(newProfileName)
            self.db.profile.imports.Plater = {}
            self.db.profile.imports.Plater.date = GetServerTime()
            self.db.profile.imports.Plater.versionNumber = self.versionNumber
            Plater.OpenOptionsPanel()
            PlaterOptionsPanelFrame:Hide()

            local profileFrame = PlaterOptionsPanelContainer.AllFrames[22]
            profileFrame.ImportStringField.importDataText = self.imports.Plater.data
            profileFrame.NewProfileTextEntry:SetText(newProfileName)
            self.db.char.openPage = 1
            profileFrame.ConfirmImportProfile()
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
