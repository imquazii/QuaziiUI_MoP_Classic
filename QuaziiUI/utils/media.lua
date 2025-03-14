-- QuaziiUI Media Registration
-- This file handles the registration of fonts and textures with LibSharedMedia

local LSM = LibStub("LibSharedMedia-3.0")

-- Media types from LibSharedMedia
local MediaType = LSM.MediaType
local FONT = MediaType.FONT
local STATUSBAR = MediaType.STATUSBAR
local BACKGROUND = MediaType.BACKGROUND
local BORDER = MediaType.BORDER
local SOUND = MediaType.SOUND

-- Register the Quazii font (used as the main UI font)
LSM:Register(FONT, "Quazii", QuaziiUI.FontFace)

-- Register the Quazii Logo texture
-- You can use this for backgrounds, statusbars, etc.
local logoTexturePath = QuaziiUI.logoPath
LSM:Register(BACKGROUND, "QuaziiLogo", logoTexturePath)

-- Register the Quazii texture
local quaziiTexturePath = "Interface\\AddOns\\QuaziiUI\\assets\\Quazii.tga"
LSM:Register(BACKGROUND, "Quazii", quaziiTexturePath)
LSM:Register(STATUSBAR, "Quazii", quaziiTexturePath)
LSM:Register(BORDER, "Quazii", quaziiTexturePath)

-- Function to check if our media is registered
function QuaziiUI:CheckMediaRegistration()
    local quaziiFontRegistered = LSM:IsValid(FONT, "Quazii")
    local logoTextureRegistered = LSM:IsValid(BACKGROUND, "QuaziiLogo")
    local quaziiTextureRegistered = LSM:IsValid(BACKGROUND, "Quazii")
    
    if quaziiFontRegistered and logoTextureRegistered and quaziiTextureRegistered then
        QuaziiUI:Print("Media registration successful!")
    else
        QuaziiUI:Print("Media registration failed:")
        if not quaziiFontRegistered then QuaziiUI:Print("- Quazii font not registered") end
        if not logoTextureRegistered then QuaziiUI:Print("- QuaziiLogo texture not registered") end
        if not quaziiTextureRegistered then QuaziiUI:Print("- Quazii texture not registered") end
    end
end

-- Register any additional fonts or textures here
-- Example:
-- LSM:Register(FONT, "MyCustomFont", "Interface\\AddOns\\QuaziiUI\\assets\\mycustomfont.ttf")
-- LSM:Register(STATUSBAR, "MyCustomTexture", "Interface\\AddOns\\QuaziiUI\\assets\\mycustomtexture.tga") 