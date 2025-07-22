PlayerPvP_UI_Config = PlayerPvP_UI_Config or {
    showHonorBadges = true,
}

-- Create options panel
local options = CreateFrame("Frame", "PlayerPvPUIOptionsPanel")
options.name = "PlayerPvP_UI"

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("PlayerPvP_UI Options")

local honorBadgeCheckbox = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
honorBadgeCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
honorBadgeCheckbox.Text:SetText("Show Honor Badges on nameplates")
honorBadgeCheckbox:SetChecked(PlayerPvP_UI_Config.showHonorBadges)

honorBadgeCheckbox:SetScript("OnClick", function(self)
    PlayerPvP_UI_Config.showHonorBadges = self:GetChecked()
end)
