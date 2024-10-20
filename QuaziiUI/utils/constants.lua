---@type table<string, string>
QuaziiUI.L = LibStub("AceLocale-3.0"):GetLocale("QuaziiUI")
---@type table
QuaziiUI.ODT = QuaziiUI.DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
---@type boolean

---@type number
QuaziiUI.versionNumber = tonumber(C_AddOns.GetAddOnMetadata(QuaziiUI:GetName(), "Version")) or 0 -- Get Addon Version from .toc and convert to number
---@type string
QuaziiUI.versionString = QuaziiUI.VersionToString(QuaziiUI.versionNumber)
---@type string
QuaziiUI.assetPath = "Interface\\AddOns\\" .. QuaziiUI:GetName() .. "\\assets\\"

QuaziiUI.logoPath = QuaziiUI.assetPath .. "quaziiLogo.tga"

---@type table
QuaziiUI.frames = {} -- Frames holder object
---@type table<string>
QuaziiUI.supportedAddons = {
    "ElvUI",
    "WeakAuras",
    "MythicDungeonTools",
    "Details",
    "Plater",
    "BigWigs",
    "Cell",
    "OmniCD"
}

-- Define Basic Colors
---@type string
QuaziiUI.highlightColorHex = "FF30D1FF" -- Quazii Blue
---@type table
QuaziiUI.highlightColorRGB = {0.188, 0.819, 1} -- Quazii Blue in RGB, no Alpha
---@type table
QuaziiUI.highlightColorRGBA = {0.188, 0.819, 1, 1} -- Quazii Blue in RGB with Alpha

---@type string
QuaziiUI.textColorHex = "FFFAF9F6" -- Off White for Text color
---@type table
QuaziiUI.textColorRGB = {1, 0.976, 0.964} -- Off White RGB no Alpha
---@type table
QuaziiUI.textColorRGBA = {1, 0.976, 0.964, 1} -- Off White RGB with Alpha

-- Text Font Face
QuaziiUI.FontFace = QuaziiUI.assetPath .. "accidental_pres.ttf"

-- Define Text Sizes
---@type integer
QuaziiUI.PageHeaderSize = 24
---@type integer
QuaziiUI.PageTextSize = 18

if not (not ElvUI) then
    ---@type integer
    QuaziiUI.TableHeaderSize = 17
else
    ---@type integer
    QuaziiUI.TableHeaderSize = 12
end
---@type integer
QuaziiUI.TableTextSize = 15


-- UI Scales
QuaziiUI.smallScale = 0.64
QuaziiUI.mediumScale = 0.71
QuaziiUI.largeScale = 0.78