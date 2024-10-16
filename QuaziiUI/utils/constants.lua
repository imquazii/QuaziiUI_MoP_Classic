---@type table<string, string>
QuaziiUI.L = LibStub("AceLocale-3.0"):GetLocale("QuaziiUI")
---@type table
QuaziiUI.ODT = QuaziiUI.DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
---@type boolean


---@type number
QuaziiUI.versionNumber = tonumber(C_AddOns.GetAddOnMetadata(QuaziiUI:GetName(), "Version")) or 0 -- Get Addon Version from .toc and convert to number
---@type string
QuaziiUI.versionString = QuaziiUI.VersionToString(QuaziiUI.versionNumber)

---@type table
QuaziiUI.frames = {} -- Frames holder object

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

-- Define Text Sizes
---@type integer
QuaziiUI.PageHeaderSize = 24
---@type integer
QuaziiUI.PageTextSize = 18

---@type integer
QuaziiUI.TableHeaderSize = 17
---@type integer
QuaziiUI.TableTextSize = 15
