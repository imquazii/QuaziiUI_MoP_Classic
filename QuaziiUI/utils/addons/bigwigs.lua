local L = QuaziiUI.L

function QuaziiUI:importBigWigsProfile()
    local profileName = "QuaziiUI"
    BigWigsAPI.RegisterProfile(
        self:GetName(),
        self.imports.BigWigs.data,
        profileName,
        function(accepted)
            if accepted then
                self.db.profile.imports.BigWigs = {}
                self.db.profile.imports.BigWigs.date = GetServerTime()
                self.db.profile.imports.BigWigs.versionNumber = self.versionNumber
                self.db.char.openPage = 1
                BigWigs3DB.namespaces = BigWigs3DB.namespaces or {}
                self.DF:ShowPromptPanel(
                    L["BigWigsNameplateDisable"],
                    function()
                        for k, v in pairs(QuaziiUI.imports.BigWigsBosses) do
                            BigWigs3DB.namespaces[k] = BigWigs3DB.namespaces[k] or {}
                            BigWigs3DB.namespaces[k].profiles = BigWigs3DB.namespaces[k].profiles or {}
                            BigWigs3DB.namespaces[k].profiles[profileName] = v
                        end
                    end,
                    function()
                    end,
                    true
                )
            end
        end
    )
end
