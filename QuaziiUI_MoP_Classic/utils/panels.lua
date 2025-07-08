---show a prompt to the player with a question (message) and two buttons "yes" and "no"
---@param message string the question to show to the player
---@param promptTitle string
---@param choice1Callback function if the player clicks on "yes"
---@param choice2Callback function if the player clicks on "no"
---@param dontOverride boolean|nil if true, won't show another prompt if theres already a shown prompt
---@param width number|nil width of the prompt frame, if ommited, will use the default width 400
---@param promptName string|nil set a name to the prompt, used on HidePromptPanel(promptName)
function QuaziiUI:Show2ChoicePromptPanel(message, promptTitle, choice1Text, choice1Callback, choice2Text, choice2Callback, dontOverride, width, promptName)
    local L = QuaziiUI.L
	if (not QuaziiUI.DFPromptSimple) then
		local promptFrame = CreateFrame("frame", "QuaziiUIPrompt", UIParent, "BackdropTemplate")
		promptFrame:SetSize(400, 90)
		promptFrame:SetFrameStrata("FULLSCREEN")
		promptFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
		QuaziiUI.DF:ApplyStandardBackdrop(promptFrame)
		table.insert(UISpecialFrames, "QuaziiUI.DFPromptSimple")

		QuaziiUI.DF:CreateTitleBar(promptFrame, promptTitle or "Prompt!")
        
		QuaziiUI.DF:ApplyStandardBackdrop(promptFrame)
        

		local prompt = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        prompt:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
		prompt:SetPoint("TOP", promptFrame, "TOP", 0, -28)
		prompt:SetJustifyH("CENTER")
		promptFrame.prompt = prompt

		local choice1Button = QuaziiUI.DF:CreateButton(promptFrame, nil, 70, 30, choice1Text or L["Yes"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
		choice1Button:SetPoint("BOTTOMRIGHT", promptFrame, "BOTTOMRIGHT", -5, 5)
        choice1Button.text_overlay:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize-2)
		promptFrame.button_choice1 = choice1Button

		local choice2Button = QuaziiUI.DF:CreateButton(promptFrame, nil, 70, 30, choice2Text or L["No"], nil, nil, nil, nil, nil, nil, QuaziiUI.ODT)
        choice2Button.text_overlay:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize-2)
		choice2Button:SetPoint("BOTTOMLEFT", promptFrame, "BOTTOMLEFT", 5, 5)
		promptFrame.button_choice2 = choice2Button

		choice1Button:SetClickFunction(function()
			local my_func = choice1Button.true_function
			if (my_func) then
				local okey, errormessage = pcall(my_func, true)
				if (not okey) then
					print("error:", errormessage)
				end
				promptFrame:Hide()
			end
		end)

		choice2Button:SetClickFunction(function()
			local my_func = choice2Button.false_function
			if (my_func) then
				local okey, errormessage = pcall(my_func, true)
				if (not okey) then
					print("error:", errormessage)
				end
				promptFrame:Hide()
			end
		end)

		promptFrame:Hide()
		QuaziiUI.DF.prompt_panel = promptFrame
	end

	assert(type(choice1Callback) == "function" and type(choice2Callback) == "function", "ShowPromptPanel expects two functions.")

	if (dontOverride) then
		if (QuaziiUI.DF.prompt_panel:IsShown()) then
			return
		end
	end


	QuaziiUI.DF.prompt_panel:SetWidth(width or 400)


	QuaziiUI.DF.prompt_panel.promptName = promptName
    QuaziiUI.DF.prompt_panel.TitleLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize-2)
	QuaziiUI.DF.prompt_panel.prompt:SetText(message)
	QuaziiUI.DF.prompt_panel.button_choice1.true_function = choice1Callback
	QuaziiUI.DF.prompt_panel.button_choice2.false_function = choice2Callback

	QuaziiUI.DF.prompt_panel:Show()
end