-- QuaziiUI Media Registration
-- This file handles the registration of fonts and textures with LibSharedMedia

local LSM = LibStub("LibSharedMedia-3.0")

-- Register the Quazii font (used as the main UI font) immediately on file load
LSM:Register(LSM.MediaType.FONT, "Quazii", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.ttf")

-- Register the Quazii Logo texture
local logoTexturePath = "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\quaziiLogo.tga"
LSM:Register(LSM.MediaType.BACKGROUND, "QuaziiLogo", logoTexturePath)

-- Register the Quazii texture
local quaziiTexturePath = "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.tga"
LSM:Register(LSM.MediaType.BACKGROUND, "Quazii", quaziiTexturePath)
LSM:Register(LSM.MediaType.STATUSBAR, "Quazii", quaziiTexturePath)
LSM:Register(LSM.MediaType.BORDER, "Quazii", quaziiTexturePath)

-- Function to check if our media is registered
function QuaziiUI:CheckMediaRegistration()
    local quaziiFontRegistered = LSM:IsValid(LSM.MediaType.FONT, "Quazii")
    local logoTextureRegistered = LSM:IsValid(LSM.MediaType.BACKGROUND, "QuaziiLogo")
    local quaziiTextureRegistered = LSM:IsValid(LSM.MediaType.BACKGROUND, "Quazii")
    
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

-- Media Registration (optional re-registration)
function QuaziiUI:RegisterMedia()
    local LSM = LibStub("LibSharedMedia-3.0", true)
    if not LSM then
        print("|cFF30D1FFQuaziiUI:|r LibSharedMedia-3.0 not found!")
        return
    end
    -- These are now registered at file load, but you can re-register here if needed
    LSM:Register("font", "Quazii", "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\Quazii.ttf")
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