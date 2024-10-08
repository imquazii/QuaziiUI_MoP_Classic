---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

function QUI.importDetailsProfile(self)
    DF:ShowTextPromptPanel(
        "Insert a Name for the New Details Profile:",
        function(newProfileName)
            QuaziiUI_DB.imports.Details = {}
            QuaziiUI_DB.imports.Details.date = GetServerTime()
            QuaziiUI_DB.imports.Details.version = QUI.version
            Details:ImportProfile(QUI.imports.Details.data, newProfileName)
            QuaziiUI_CDB.openPage = 1
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
