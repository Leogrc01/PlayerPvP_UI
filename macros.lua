-- macros.lua - Version avec fenêtre interactive

local f = CreateFrame("Frame", "PvPMacrosFrame", UIParent, "BackdropTemplate")
f:SetSize(400, 300)
f:SetPoint("CENTER")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetClampedToScreen(true)

-- Apparence
f:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
f:SetBackdropColor(0,0,0,0.9)
f:Hide()

-- Titre avec zone de déplacement
local header = CreateFrame("Frame", nil, f)
header:SetPoint("TOP", 0, 10)
header:SetSize(300, 30)
header:EnableMouse(true)
header:RegisterForDrag("LeftButton")
header:SetScript("OnDragStart", function() f:StartMoving() end)
header:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("CENTER")
title:SetText("Macros Chaman Élémentaire")

-- Bouton Fermer
local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetSize(32, 32)
closeBtn:SetScript("OnClick", function() f:Hide() end)

-- Poignée de redimensionnement
local resizeHandle = CreateFrame("Button", nil, f)
resizeHandle:SetPoint("BOTTOMRIGHT", -5, 5)
resizeHandle:SetSize(16, 16)
resizeHandle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeHandle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
resizeHandle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

resizeHandle:SetScript("OnMouseDown", function(self)
    f:StartSizing("BOTTOMRIGHT")
end)

resizeHandle:SetScript("OnMouseUp", function(self)
    f:StopMovingOrSizing()
end)

-- ScrollFrame
local scrollFrame = CreateFrame("ScrollFrame", "PlayerPvPScrollFrame", f, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -40)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(360, 1) -- Taille initiale, sera ajustée dynamiquement
scrollFrame:SetScrollChild(scrollContent)

local scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
scrollBar:ClearAllPoints()
scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -12, -16)
scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", -12, 16)

-- Données des macros
local elementalMacros = {
    {
        name = "Focus Hex",
        icon = 237579,
        macro = "#showtooltip Hex\n/cast [@focus] Hex"
    },
    {
        name = "Focus Wind Shear",
        icon = 6238561,
        macro = "#showtooltip\n/cast [@focus] Wind Shear"
    },
    {
        name = "Wind Shear",
        icon = 6238561,
        macro = "#showtooltip\n/cast Wind Shear"
    },
    {
        name = "Focus Earthgrab",
        icon = 136100,
        macro = "#showtooltip Earthgrab Totem\n/cast [@focus] Earthgrab Totem"
    },
    {
        name = "Arena1 Earthgrab",
        icon = 136100,
        macro = "#showtooltip Earthgrab Totem\n/cast [@arena1] Earthgrab Totem"
    },
    {
        name = "Purge Souris",
        icon = 136075,
        macro = "#showtooltip Purge\n/cast [@mouseover,harm] Purge"
    },
    {
        name = "Purge Focus",
        icon = 136075,
        macro = "#showtooltip Purge\n/cast [@focus,harm] Purge"
    },
    {
        name = "Prim Wave/Swiftness",
        icon = 6035320,
        macro = "#showtooltip Primordial Wave\n/cast Ancestral Swiftness\n/cast Primordial Wave"
    },
    {
        name = "Earth Elemental",
        icon = 136024,
        macro = "#showtooltip Earth Elemental\n/target [@self]\n/cast Earth Elemental\n/targetlasttarget"
    },
    {
        name = "Focus Lasso",
        icon = 1385911,
        macro = "#showtooltip Lightning Lasso\n/cast [@focus] Lightning Lasso"
    }
    
}

-- Fonction pour créer les macros
local function CreateMacroButtons()
    local totalHeight = 0
    local spacing = 5
    local buttonHeight = 25
    
    for i, m in ipairs(elementalMacros) do
        local btn = CreateFrame("Button", "MacroBtn"..i, scrollContent, "UIPanelButtonTemplate")
        btn:SetSize(340, buttonHeight)
        btn:SetPoint("TOPLEFT", 5, -totalHeight)
        
        -- Icône
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(20, 20)
        icon:SetPoint("LEFT", 5, 0)
        icon:SetTexture(m.icon)
        
        -- Texte
        btn:SetText(m.name)
        btn:GetFontString():SetPoint("LEFT", icon, "RIGHT", 5, 0)
        
        -- Action
        btn:SetScript("OnClick", function()
            if C_AddOns and C_AddOns.LoadAddOn then
                C_AddOns.LoadAddOn("Blizzard_MacroUI")
            else
                LoadAddOn("Blizzard_MacroUI")
            end
            MacroFrame_Show()
            CreateMacro(m.name, m.icon, m.macro, 1)
        end)

        totalHeight = totalHeight + buttonHeight + spacing
    end
    
    -- Ajuste la hauteur du contenu en fonction du nombre de boutons
    scrollContent:SetHeight(totalHeight)
end

CreateMacroButtons()

-- Commandes Slash
SLASH_PMACROS1 = "/pmacros"
SlashCmdList["PMACROS"] = function()
    local specID = GetSpecialization()
    if specID == 1 then
        f:Show()
    else
        print("|cffff0000Vous devez être en spécialisation Élémentaire|r")
    end
end

-- Version courte
SLASH_EMACROS1 = "/pm"
SlashCmdList["EMACROS"] = SlashCmdList["PMACROS"]