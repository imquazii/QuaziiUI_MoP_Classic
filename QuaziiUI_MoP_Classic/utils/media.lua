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
LSM:Register(FONT, "Quazii", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.ttf")

-- Register the Quazii Logo texture
-- You can use this for backgrounds, statusbars, etc.
local logoTexturePath = "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\quaziiLogo.tga"
LSM:Register(BACKGROUND, "QuaziiLogo", logoTexturePath)

-- Register the Quazii texture
local quaziiTexturePath = "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.tga"
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
-- LSM:Register(FONT, "MyCustomFont", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\mycustomfont.ttf")
-- LSM:Register(STATUSBAR, "MyCustomTexture", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\mycustomtexture.tga")

-- Media Registration
function QuaziiUI:RegisterMedia()
    local LSM = LibStub("LibSharedMedia-3.0", true)
    if not LSM then
        print("|cFF30D1FFQuaziiUI:|r LibSharedMedia-3.0 not found!")
        return
    end

    -- Register Font with LibSharedMedia
    LSM:Register("font", "Quazii", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.ttf")

    -- Register Textures
    LSM:Register("statusbar", "Quazii", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.tga")
    LSM:Register("background", "QuaziiLogo", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\quaziiLogo.tga")

    -- Register the Quazii font globally for all frames (including ElvUI)
    local fontPath = "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.ttf"
    local QuaziiFont = CreateFont("Quazii")
    QuaziiFont:SetFont(fontPath, 14, "")

    -- Verification
    local quaziiFont = LSM:Fetch("font", "Quazii")
    if not quaziiFont then
        print("|cFF30D1FFQuaziiUI:|r - Quazii font not registered")
    end

    local quaziiLogo = LSM:Fetch("background", "QuaziiLogo")
    if not quaziiLogo then
        print("|cFF30D1FFQuaziiUI:|r - QuaziiLogo texture not registered")
    end
end 