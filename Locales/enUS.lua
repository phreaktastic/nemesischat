local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale("NemesisChat", "enUS", true)
if not L then return end

-- @TODO: Add localized strings -- this was neglected for far too long
L["SoundDropdown"] = "Sound Selection"
L["SoundDropdownDesc"] = "Select a sound to play"
L["SoundPreview"] = "Preview Sound"
-- etc...

-- Make it globally accessible
_G.NCL = LibStub("AceLocale-3.0"):GetLocale(addonName)
