---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

QUI.L = LibStub("AceLocale-3.0"):GetLocale("QuaziiUI")

QUI.ODT = DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

QUI.version = tonumber(C_AddOns.GetAddOnMetadata(addonName, "Version")) -- Get Addon Version from .toc and convert to number

QUI.frames = {} -- Frames holder object


-- Define Basic Colors
QUI.highlightColorHex = "FF30D1FF" -- Quazii Blue
QUI.highlightColorRGB = {0.188, 0.819, 1} -- Quazii Blue in RGB, no Alpha
QUI.highlightColorRGBA = {0.188, 0.819, 1, 1} -- Quazii Blue in RGB with Alpha

QUI.textColorHex = "FFFAF9F6" -- Off White for Text color
QUI.textColorRGB = {1, 0.976, 0.964} -- Off White RGB no Alpha
QUI.textColorRGBA = {1, 0.976, 0.964, 1} -- Off White RGB with Alpha

-- Define Text Sizes
QUI.PageHeaderSize = 24
QUI.PageTextSize = 18

QUI.TableHeaderSize = 18
QUI.TableTextSize = 16