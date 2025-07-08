local L = QuaziiUI.L

function QuaziiUI:importElvUIProfile()
    QuaziiUI.DF:ShowPromptPanel(
        "Are you sure you want to import Quazii's Tank/DPS ElvUI profile?\nThis is the recommended profile for most users.",
        function()
            if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") and ElvUI and ElvUI[1] then
                QuaziiUI.db.global.imports.tankdps = {
                    date = GetServerTime(),
                    version = QuaziiUI.versionNumber
                }
                local Profile = ElvUI[1].Distributor
                if Profile and Profile.ImportProfile then
                    local success, error = pcall(function()
                        Profile:ImportProfile(QuaziiUI.imports.ElvUI.tankdps.data)
                    end)
                    
                    if success then
                        QuaziiUI.db.char.openPage = 1
                        print("QuaziiUI: ElvUI profile imported successfully!")
                    else
                        print("QuaziiUI Error: Failed to import ElvUI profile - " .. tostring(error))
                        print("The profile data may be incompatible with your ElvUI version.")
                    end
                else
                    print("QuaziiUI Error: ElvUI Distributor or ImportProfile method not found.")
                end
            else
                print("QuaziiUI Error: ElvUI is not loaded or ElvUI[1] is not available.")
            end
        end,
        function()
        end,
        true
    )
end 