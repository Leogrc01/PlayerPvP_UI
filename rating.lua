-- Player variables
local playerclass, playerName = UnitClass("player"), UnitName("player")

-- Main frame creation
local frame = CreateFrame("Frame", "PlayerPvP_UIFrame", UIParent)
frame:SetSize(300, 120)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Title line
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
titleText:SetTextColor(1, 1, 0)
titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
titleText:SetText("Welcome " .. playerName .. " (" .. playerclass .. ")")

-- Text lines for each bracket
local text2v2 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text2v2:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
text2v2:SetTextColor(1, 1, 0)
text2v2:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)

local text3v3 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text3v3:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
text3v3:SetTextColor(1, 1, 0)
text3v3:SetPoint("TOPLEFT", text2v2, "BOTTOMLEFT", 0, -4)

local textSolo = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textSolo:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
textSolo:SetTextColor(1, 1, 0)
textSolo:SetPoint("TOPLEFT", text3v3, "BOTTOMLEFT", 0, -4)

-- Badge icons
local icon2v2 = frame:CreateTexture(nil, "OVERLAY")
icon2v2:SetSize(20, 20)
icon2v2:SetPoint("LEFT", text2v2, "RIGHT", 5, 0)

local icon3v3 = frame:CreateTexture(nil, "OVERLAY")
icon3v3:SetSize(20, 20)
icon3v3:SetPoint("LEFT", text3v3, "RIGHT", 5, 0)

local iconSolo = frame:CreateTexture(nil, "OVERLAY")
iconSolo:SetSize(20, 20)
iconSolo:SetPoint("LEFT", textSolo, "RIGHT", 5, 0)

-- Custom badge function
local function GetCustomBadgeByRating(rating)
    if not rating or type(rating) ~= "number" then return nil end
    if rating >= 2400 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\elite.png"
    elseif rating >= 2100 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\duelist.png"
    elseif rating >= 1800 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\rival.png"
    elseif rating >= 1400 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\competiteur.png"
    elseif rating >= 1000 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\combattant.png"
    elseif rating >= 1 then return "Interface\\AddOns\\PlayerPvP_UI\\Images\\unranked.png" end
    return nil
end

-- UI update function
local function UpdatePvPInfo()
    if not C_AddOns.IsAddOnLoaded("Blizzard_PVPUI") then
        C_AddOns.LoadAddOn("Blizzard_PVPUI")
    end

    local rating2v2 = tonumber((select(2, GetPersonalRatedInfo(1)))) or 0
    local rating3v3 = tonumber((select(2, GetPersonalRatedInfo(2)))) or 0

    text2v2:SetText("2v2: " .. (rating2v2 > 0 and rating2v2 or "Unranked"))
    text3v3:SetText("3v3: " .. (rating3v3 > 0 and rating3v3 or "Unranked"))
    textSolo:SetText("Solo Shuffle: Loading...")

    local badge2v2 = GetCustomBadgeByRating(rating2v2)
    if badge2v2 then icon2v2:SetTexture(badge2v2); icon2v2:Show() else icon2v2:Hide() end

    local badge3v3 = GetCustomBadgeByRating(rating3v3)
    if badge3v3 then icon3v3:SetTexture(badge3v3); icon3v3:Show() else icon3v3:Hide() end
end

-- Solo Shuffle rating update function
local function UpdateSoloShuffleLoop()
    local best = 0
    if C_PvP and C_PvP.GetRatedSoloShuffleSpecStats then
        local specs = C_PvP.GetRatedSoloShuffleSpecStats()
        if specs then
            for _, info in ipairs(specs) do
                if info.rating and info.rating > best then
                    best = info.rating
                end
            end
        end
    end

    local badgeSolo = GetCustomBadgeByRating(best)
    textSolo:SetText("Solo Shuffle: " .. (best > 0 and best or "Unranked"))
    if badgeSolo then iconSolo:SetTexture(badgeSolo); iconSolo:Show() else iconSolo:Hide() end
end

-- WoW events
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PVP_RATED_STATS_UPDATE")

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOGIN" then
        C_Timer.After(1, UpdatePvPInfo)
        C_Timer.After(2, UpdateSoloShuffleLoop)
    elseif event == "PVP_RATED_STATS_UPDATE" then
        UpdateSoloShuffleLoop()
    end
end)