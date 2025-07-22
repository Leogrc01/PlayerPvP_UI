local config = PlayerPvP_UI_Config or { showHonorBadges = true }

-- Table des icônes par niveau d'honneur
local function GetHonorBadgeIconFileID(level)
    if level >= 500 then return 1713481
    elseif level >= 400 then return 1713480
    elseif level >= 300 then return 1713479
    elseif level >= 250 then return 1713478
    elseif level >= 200 then return 1596907
    elseif level >= 175 then return 1596906
    elseif level >= 150 then return 1596905
    elseif level >= 125 then return 1596904
    elseif level >= 100 then return 1596902
    elseif level >= 90 then return 1596901
    elseif level >= 80 then return 1596900
    elseif level >= 70 then return 1596899
    elseif level >= 60 then return 1596892
    elseif level >= 50 then return 1523631
    elseif level >= 40 then return 1523630
    elseif level >= 30 then return 1523629
    elseif level >= 25 then return 1523628
    elseif level >= 20 then return 1455894
    elseif level >= 15 then return 1455893
    elseif level >= 10 then return 1455892
    else return 1455891
    end
end

-- Liste des badges attachés par nameplate
local badgeFrames = {}

-- Crée un badge pour un nameplate donné
local function CreateBadgeForNameplate(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if not nameplate then return end

    -- Déjà créé ?
    if badgeFrames[unit] then return end

    local badge = CreateFrame("Frame", nil, nameplate)
    badge:SetSize(20, 20)

    local texture = badge:CreateTexture(nil, "OVERLAY")
    texture:SetAllPoints()
    badge.texture = texture

    badge:SetPoint("RIGHT", nameplate.UnitFrame.healthBar, "LEFT", -5, 0)
    badgeFrames[unit] = badge
end

-- Met à jour l’icône du badge
local function UpdateBadgeForUnit(unit)
    local honorLevel = UnitHonorLevel(unit)
    local badge = badgeFrames[unit]
    if not badge or not honorLevel then return end

    local iconID = GetHonorBadgeIconFileID(honorLevel)
    if iconID then
        badge.texture:SetTexture(iconID)
        badge:Show()
    else
        badge:Hide()
    end
end

-- Supprime un badge quand le nameplate disparaît
local function RemoveBadge(unit)
    local badge = badgeFrames[unit]
    if badge then
        badge:Hide()
        badge:SetParent(nil)
        badgeFrames[unit] = nil
    end
end

-- Événement principal
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

eventFrame:SetScript("OnEvent", function(_, event, unit)
    if not config.showHonorBadges then return end
    if event == "NAME_PLATE_UNIT_ADDED" and UnitIsPlayer(unit) then
        CreateBadgeForNameplate(unit)
        UpdateBadgeForUnit(unit)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        RemoveBadge(unit)
    end
end)
