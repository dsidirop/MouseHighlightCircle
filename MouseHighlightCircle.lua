-- MouseHighlightCircle.lua

local _tostring = tostring
local _tonumber = tonumber

local _strgsub = string.gsub
local _strupper = string.upper
local _strlower = string.lower
local _strmatch = string.match

local _namedColors = { --@formatter:off
    RED              = { 1.00, 0.000, 0.000 }, -- Pure red (#FF0000)
    BLUE             = { 0.00, 0.000, 1.000 }, -- Pure blue (#0000FF)
    GOLD             = { 1.00, 0.820, 0.000 }, -- WoW NORMAL_FONT_COLOR (#FFD100)
    GRAY             = { 0.50, 0.500, 0.500 }, -- Medium gray (#808080)
    CYAN             = { 0.00, 1.000, 1.000 }, -- Pure cyan (#00FFFF)
    LIME             = { 0.75, 1.000, 0.000 }, -- Bright lime green (#BFFF00)
    PINK             = { 1.00, 0.753, 0.796 }, -- Soft pink (#FFC0CB)
    TEAL             = { 0.00, 0.502, 0.502 }, -- Teal, blue-green mix (#008080)
    NAVY             = { 0.00, 0.000, 0.500 }, -- Deep navy blue (#000080)
    OLIVE            = { 0.50, 0.500, 0.000 }, -- Olive green (#808000)
    GREEN            = { 0.00, 1.000, 0.000 }, -- Pure green (#00FF00)
    WHITE            = { 1.00, 1.000, 1.000 }, -- Pure white (#FFFFFF)
    BLACK            = { 0.00, 0.000, 0.000 }, -- Pure black (#000000)
    VIOLET           = { 0.93, 0.510, 0.933 }, -- Vibrant violet (#EE82EE)
    ORANGE           = { 1.00, 0.498, 0.243 }, -- WoW orange font approximation (#FF7F3F)
    PURPLE           = { 0.50, 0.000, 1.000 }, -- Bright purple (#8000FF)
    SILVER           = { 0.75, 0.753, 0.753 }, -- Light silver (#C0C0C0)
    YELLOW           = { 1.00, 1.000, 0.000 }, -- Pure yellow (#FFFF00)
    MAROON           = { 0.50, 0.000, 0.000 }, -- Deep red (#800000)
    MAGENTA          = { 1.00, 0.000, 1.000 }, -- Pure magenta (#FF00FF)
    CRIMSON          = { 0.86, 0.078, 0.235 }, -- Rich red (#DC143C)
    TOMATO           = { 1.00, 0.388, 0.278 }, -- Bright tomato red (#FF6347)
    DARK_GRAY        = { 0.25, 0.250, 0.250 }, -- Darker gray (#404040)
    DARK_GOLD        = { 0.80, 0.600, 0.000 }, -- Darker gold, rich tone (#CC9900)
    DARK_CYAN        = { 0.00, 0.545, 0.545 }, -- Dark cyan (#008B8B)
    FIREBRICK        = { 0.70, 0.133, 0.133 }, -- Deep brick red (#B22222)
    SLATE_BLUE       = { 0.42, 0.353, 0.804 }, -- Slate blue (#6A5ACD)
    SLATE_GRAY       = { 0.44, 0.500, 0.565 }, -- Slate gray (#708090)
    STEEL_BLUE       = { 0.27, 0.509, 0.706 }, -- Steel blue (#4682B4)
    CHARTREUSE       = { 0.50, 1.000, 0.000 }, -- Bright chartreuse (#7FFF00)
    LIGHT_BLUE       = { 0.68, 0.847, 0.902 }, -- Light blue, sky-like (#ADD8E6)
    LIGHT_GOLD       = { 1.00, 0.930, 0.400 }, -- Lighter gold, soft glow (#FFED66)
    DARK_GREEN       = { 0.00, 0.392, 0.000 }, -- Dark green (#006400)
    LIGHT_CYAN       = { 0.88, 1.000, 1.000 }, -- Pale cyan (#E0FFFF)
    ROYAL_BLUE       = { 0.25, 0.411, 0.882 }, -- Rich blue (#4169E1)
    CORNFLOWER       = { 0.39, 0.584, 0.929 }, -- Cornflower blue (#6495ED)
    DARK_OLIVE       = { 0.33, 0.420, 0.184 }, -- Dark olive green (#556B2F)
    DARK_ORANGE      = { 1.00, 0.300, 0.000 }, -- Darker orange, warning style (#FF4C00)
    PALE_ORANGE      = { 1.00, 0.800, 0.600 }, -- Pale orange, subtle shade (#FFCC99)
    DARK_VIOLET      = { 0.58, 0.000, 0.827 }, -- Deep violet (#9400D3)
    LIGHT_GREEN      = { 0.56, 0.933, 0.565 }, -- Light green (#90EE90)
    LIGHT_ORANGE     = { 1.00, 0.650, 0.300 }, -- Lighter orange, softer tone (#FFA64C)
    HUNTER_GREEN     = { 0.67, 0.830, 0.450 }, -- WoW Hunter class color (#ABD473)
    DRUID_ORANGE     = { 1.00, 0.490, 0.040 }, -- WoW Druid class color (#FF7C0A)
    DARK_MAGENTA     = { 0.55, 0.000, 0.550 }, -- Dark magenta (#8B008B)
    SADDLE_BROWN     = { 0.55, 0.271, 0.075 }, -- Dark brown (#8B4513)
    FOREST_GREEN     = { 0.13, 0.545, 0.133 }, -- Deep forest green (#228B22)
    SPRING_GREEN     = { 0.00, 1.000, 0.498 }, -- Vibrant spring green (#00FF7F)
    DEEP_SKY_BLUE    = { 0.00, 0.749, 1.000 }, -- Bright sky blue (#00BFFF)
    MEDIUM_VIOLET    = { 0.73, 0.333, 0.827 }, -- Medium violet (#BB33D3)
    DARK_SLATE_GRAY  = { 0.18, 0.310, 0.310 }, -- Dark slate gray (#2F4F4F)
    VERY_DARK_ORANGE = { 0.80, 0.200, 0.000 }, -- Very dark orange, deep tone (#CC3300)
} --@formatter:on

local _settings = {
    Reticle = {
        Color = _namedColors.GOLD,
        Alpha = 0.7,
        Diameter = 32,
    },
}

local function _print(msg, r, g, b, id)
    DEFAULT_CHAT_FRAME:AddMessage(
            "[|cff33ff99MHC|r] " .. msg,
            r ~= nil and r or _namedColors.LIGHT_GREEN[1],
            g ~= nil and g or _namedColors.LIGHT_GREEN[2],
            b ~= nil and b or _namedColors.LIGHT_GREEN[3],
            id
    )
end

local function _strtrim(input)
    return _strmatch(input or "", '^%s*(.*%S)') or ''
end

local frame = CreateFrame("Frame", "MouseHighlightCircleFrame", UIParent)
frame:Hide() --                     will be shown at the end of the initialization
frame:SetFrameStrata("TOOLTIP") --  if we need the overlay to be above any and all ui elements    should be what most users want on 4k monitors

local circle = frame:CreateTexture(nil, "OVERLAY")
circle:Hide() -- will be shown at the end of the initialization

local overlayImage = "Interface\\AddOns\\MouseHighlightCircle\\pixelring.tga"

-- set ring texture (pixelated, white edge, transparent center)
circle:SetTexture(overlayImage)

-- if the texture is not found _print an error and use a placeholder texture
if not circle:GetTexture() then
    _print("Mouse-overlay image was not found on disk - make sure the file '" .. overlayImage .. "' exists in the filesystem.")
    circle:SetTexture(_settings.Reticle.Color[1], _settings.Reticle.Color[2], _settings.Reticle.Color[3], _settings.Reticle.Alpha) -- temporarily a white square (for debugging)
    circle:SetWidth(32)
    circle:SetHeight(32)
end

-- adjust texture dimensions and position
circle:SetWidth(_settings.Reticle.Diameter)
circle:SetHeight(_settings.Reticle.Diameter)
circle:SetVertexColor(_settings.Reticle.Color[1], _settings.Reticle.Color[2], _settings.Reticle.Color[3], _settings.Reticle.Alpha)

-- track mouse movements
local _lastX, _lastY, _uiScale = -999999, -999999, nil
frame:SetScript("OnUpdate", function()
    local x, y = GetCursorPosition()
    if x == nil or y == nil or (abs(x - _lastX) <= 1 and abs(y - _lastY) <= 1) then
        return -- mouse hasnt moved that much   do nothing
    end

    if _uiScale == nil then
        _uiScale = UIParent:GetEffectiveScale() -- snipe once
        if _uiScale == nil or _uiScale <= 0 then
            _uiScale = 1 -- failsafe
            _print("[WARNING] GetEffectiveScale() returned unusable value '" .. _tostring(_uiScale or "nil") .. "' - assuming ui-scale=1 and hoping for the best but please report this incident and what you did to cause it.")
        end
    end

    _lastX, _lastY = x, y -- order
    x = x / _uiScale -- order
    y = y / _uiScale -- order

    -- circle:ClearAllPoints() -- doesnt seem to be truly necessary in this particular case
    circle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y) -- place the ring around the mouse cursor
end)


frame:SetScript("OnEvent", function()
    local eventSnapshot = event
    
    -- _print("Event: " .. _tostring(eventSnapshot or "nil"))
    
    if eventSnapshot == "PLAYER_LOGIN" then
        -- initialize or reset variables that might change on relog
        _uiScale = nil -- force re-sniping of ui-scale on next mouse-move
        _print("Loaded - type |cff33ff99/mhc|r for a list of supported commands.")
    end
end)
frame:RegisterEvent("PLAYER_LOGIN")

-- add slash commands (optional, for settings)
SLASH_MHC1 = "/mhc"
SlashCmdList["MHC"] = function(msg)
    local msgLowercased = _strlower(_strtrim(msg or ""))

    if msgLowercased == "hide" or msgLowercased == "off" then
        frame:Hide()
        _print("Reticle Off")
        return
    end

    if msgLowercased == "show" or msgLowercased == "on" then
        frame:Show()
        _print("Reticle On")
        return
    end

    local desiredReticleDiameterInPixelsStringified, isSetSizeCommand = _strgsub(msg, "^%s*size%s+(%S*)%s*$", "%1")
    if isSetSizeCommand ~= nil and isSetSizeCommand > 0 then
        local newReticleDiameter = _tonumber(desiredReticleDiameterInPixelsStringified)
        if newReticleDiameter == nil or newReticleDiameter <= 0 then
            _print("Invalid size value '" .. _tostring(desiredReticleDiameterInPixelsStringified or "nil") .. "' - please provide a positive number.")
            return
        end

        circle:SetWidth(newReticleDiameter)
        circle:SetHeight(newReticleDiameter)
        _print("Reticle size set to '" .. _tostring(newReticleDiameter) .. "' pixels.")
        return
    end

    local desiredStrata, isSetStrataCommand = _strgsub(msg, "^%s*strata%s+(%S*)%s*$", "%1")
    if isSetStrataCommand ~= nil and isSetStrataCommand > 0 then
        desiredStrata = _strupper(_strtrim(desiredStrata or ""))
        if desiredStrata ~= "BACKGROUND" -- lowest
                and desiredStrata ~= "LOW"
                and desiredStrata ~= "MEDIUM"
                and desiredStrata ~= "HIGH"
                and desiredStrata ~= "DIALOG"
                and desiredStrata ~= "FULLSCREEN"
                and desiredStrata ~= "FULLSCREEN_DIALOG"
                and desiredStrata ~= "TOOLTIP" then
            -- highest
            _print("Invalid strata value '" .. _tostring(desiredStrata or "nil") .. "' - must be one of: background, low, medium, high, dialog, fullscreen, fullscreen_dialog, tooltip")
            return
        end

        frame:SetFrameStrata(desiredStrata)
        _print("Reticle strata set to '" .. _tostring(desiredStrata) .. "'.")
        return
    end

    local desiredNamedColor, isSetColorCommand = _strgsub(msg, "^%s*color%s+(%S*).*$", "%1")
    if isSetColorCommand ~= nil and isSetColorCommand > 0 then
        local colorRgbArray = _namedColors[_strupper(_strtrim(desiredNamedColor or ""))]
        if colorRgbArray == nil then
            _print("Unsupported named-color '" .. _tostring(desiredNamedColor or "nil") .. "' - must be one of the supported color names")
            return
        end
        
        _settings.Reticle.Color = colorRgbArray -- update the current settings

        local desiredColorAlpha        
        local desiredColorAlphaString, hasColorAlpha = _strgsub(msg, "^%s*color%s+(%S+)%s+(%S+)%s*$", "%2")
        
        _print("** hasColorAlpha: " .. _tostring(hasColorAlpha or "nil") .. ", desiredColorAlphaString=" .. _tostring(desiredColorAlphaString or "nil")) -- debug
        
        if hasColorAlpha ~= nil and hasColorAlpha > 0 then -- optional alpha value
            desiredColorAlpha = _tonumber(_strtrim(desiredColorAlphaString or ""))
            if desiredColorAlpha == nil or desiredColorAlpha < 0 or desiredColorAlpha > 100 then
                _print("Invalid alpha value '" .. _tostring(desiredColorAlpha or "nil") .. "' - must be between [0, 100]")
                return
            end

            desiredColorAlpha = desiredColorAlpha / 100 -- convert to [0.0, 1.0] range
            _settings.Reticle.Alpha = desiredColorAlpha -- and update the current settings
        end
        
        circle:SetVertexColor(colorRgbArray[1], colorRgbArray[2], colorRgbArray[3], desiredColorAlpha)
        
        _print("Reticle color set to '" .. _tostring(desiredNamedColor) .. "'" .. (hasColorAlpha ~= nil and hasColorAlpha > 0 and (" with alpha " .. _tostring(desiredColorAlpha)) or ""))
        return
    end

    if msg ~= "" then
        _print("Unknown command '" .. msg .. "'.")
        _print("Available commands:")
    end

    _print("  /mhc on   - Show the reticle")
    _print("  /mhc show - Same as 'on'")

    _print("  /mhc off  - Hide the reticle")
    _print("  /mhc hide - Same as 'off'")

    _print("  /mhc size   <pixels> - Set the diameter of the reticle")
    _print("  /mhc strata <strata> - Set the frame strata of the reticle (background, low, medium, high, dialog, fullscreen, fullscreen_dialog, tooltip)")
    _print("  /mhc color  <color> [<alpha>] - Set the color of the reticle (e.g. red, blue, dark_gold, etc) with an optional alpha value (0-100)")

end

SlashCmdList["MOUSE_HIGHLIGHT_CIRCLE"] = SlashCmdList["MHC"] -- alias for those who prefer longer commands for the sake of clarity
SLASH_MOUSE_HIGHLIGHT_CIRCLE1 = "/mouse_highlight_circle"

frame:Show()
circle:Show()
