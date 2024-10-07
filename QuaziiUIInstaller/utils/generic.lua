---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]

-- Panel Functions
function QUI:Show() QUI.frames.main:Show() end -- Makes the installer UI visible
function QUI:Hide() QUI.frames.main:Hide() end -- Makes the installer UI hidden