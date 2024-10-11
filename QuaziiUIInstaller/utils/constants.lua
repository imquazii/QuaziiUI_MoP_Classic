local addonName = ...

QuaziiUI.L = LibStub("AceLocale-3.0"):GetLocale("QuaziiUI")

QuaziiUI.ODT = QuaziiUI.DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

QuaziiUI.versionNumber = tonumber(C_AddOns.GetAddOnMetadata(addonName, "Version")) -- Get Addon Version from .toc and convert to number
QuaziiUI.versionString = QuaziiUI.VersionToString(QuaziiUI.versionNumber)

QuaziiUI.frames = {} -- Frames holder object

-- Define Basic Colors
QuaziiUI.highlightColorHex = "FF30D1FF" -- Quazii Blue
QuaziiUI.highlightColorRGB = {0.188, 0.819, 1} -- Quazii Blue in RGB, no Alpha
QuaziiUI.highlightColorRGBA = {0.188, 0.819, 1, 1} -- Quazii Blue in RGB with Alpha

QuaziiUI.textColorHex = "FFFAF9F6" -- Off White for Text color
QuaziiUI.textColorRGB = {1, 0.976, 0.964} -- Off White RGB no Alpha
QuaziiUI.textColorRGBA = {1, 0.976, 0.964, 1} -- Off White RGB with Alpha

-- Define Text Sizes
QuaziiUI.PageHeaderSize = 24
QuaziiUI.PageTextSize = 18

QuaziiUI.TableHeaderSize = 17
QuaziiUI.TableTextSize = 15
