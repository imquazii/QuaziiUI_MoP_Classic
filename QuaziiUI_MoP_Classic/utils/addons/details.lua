local L = QuaziiUI.L

function QuaziiUI:importDetailsProfile()
    self.DF:ShowTextPromptPanel(
        L["DetailsPrompt"],
        function(newProfileName)
            self.db.global.imports.Details = {}
            self.db.global.imports.Details.date = GetServerTime()
            self.db.global.imports.Details.versionNumber = self.versionNumber
            
            local success, error = pcall(function()
                Details:ImportProfile(self.imports.Details.data, newProfileName, nil, nil, true)
            end)
            
            if success then
                self.db.char.openPage = 2
                print("QuaziiUI: Details profile imported successfully!")
            else
                print("QuaziiUI Error: Failed to import Details profile - " .. tostring(error))
                print("The profile data may be incompatible with your Details version.")
            end
        end,
        function()
        end,
        true
    )
    DetailsFrameworkPrompt.EntryBox:SetText("Quazii")
end
