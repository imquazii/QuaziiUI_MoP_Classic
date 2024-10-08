---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

function QUI.importPlaterProfile(self)
    DF:ShowTextPromptPanel(
        "Insert a Name for the New Plater Profile:",
        function(newProfileName)
            QuaziiUI_DB.imports.Plater = {}
            QuaziiUI_DB.imports.Plater.date = GetServerTime()
            QuaziiUI_DB.imports.Plater.version = QUI.version
            Plater.OpenOptionsPanel()
            PlaterOptionsPanelFrame:Hide()
            local profileFrame = PlaterOptionsPanelContainer.AllFrames[22]
            profileFrame.ImportStringField.importDataText = QUI.imports.Plater["data"]
            profileFrame.NewProfileTextEntry:SetText(newProfileName)
            QuaziiUI_CDB.openPage = 1
            profileFrame.ConfirmImportProfile()
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
