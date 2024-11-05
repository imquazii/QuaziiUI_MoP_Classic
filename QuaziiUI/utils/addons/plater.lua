local L = QuaziiUI.L

function QuaziiUI:importPlaterProfile()
    self.DF:ShowTextPromptPanel(
        L["PlaterPrompt"],
        function(newProfileName)
            self.db.global.imports.Plater = {}
            self.db.global.imports.Plater.date = GetServerTime()
            self.db.global.imports.Plater.versionNumber = self.versionNumber
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
