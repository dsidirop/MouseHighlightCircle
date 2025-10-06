-- MouseHighlightCircle.lua

local _tostring = tostring
local _tonumber = tonumber
local _strlower = string.lower
local _strmatch = string.match

local function _print(msg, r, g, b, id)
    DEFAULT_CHAT_FRAME:AddMessage(
            "[|cff33ff99MouseHighlightCircle|r] " .. msg,
            r ~= nil and r or 0.5,
            g ~= nil and g or 1.0,
            b ~= nil and b or 0.5,
            id
    )
end

local function _strtrim(input)
    return _strmatch(input or "", '^%s*(.*%S)') or ''
end

local frame = CreateFrame("Frame", "MouseHighlightCircleFrame", UIParent)

frame:SetFrameStrata("TOOLTIP") -- if we need the overlay to be above any and all ui elements    should be what most users want on 4k monitors
-- frame:SetFrameStrata("HIGH") -- if we need the overlay to be above most UI elements but not above dialogs such as the pfui-configuration dialog

local circle = frame:CreateTexture(nil, "OVERLAY")

local overlayImage = "Interface\\AddOns\\MouseHighlightCircle\\pixelring.tga"

-- set ring texture (pixelated, white edge, transparent center)
circle:SetTexture(overlayImage)

-- if the texture is not found _print an error and use a placeholder texture
if not circle:GetTexture() then
    _print("Mouse-overlay image was not found on disk - make sure the file '" .. overlayImage .. "' exists in the filesystem.")
    circle:SetTexture(1, 1, 1, 0.7) -- temporarily a white square (for debugging)
    circle:SetWidth(32)
    circle:SetHeight(32)
end

-- adjust texture dimensions and position
circle:SetWidth(32)
circle:SetHeight(32)
circle:SetVertexColor(1, 1, 1, 0.7) -- translucent white

-- track mouse movements
local _lastX, _lastY, _uiScale = -999999, -999999, nil
frame:SetScript("OnUpdate", function()
    local x, y = GetCursorPosition()
    if x == _lastX and y == _lastY then
        return -- mouse hasn't moved   do nothing
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

frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    local eventSnapshot = event

    if eventSnapshot == "PLAYER_LOGIN" then
        -- initialize or reset variables that might change on relog
        _uiScale = nil -- force re-sniping of ui-scale on next mouse-move
    end
end)

-- show ring when addon is installed
frame:Show()
circle:Show()

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

    local desiredReticleDiameterInPixelsStringified, matches = string.gsub(msg, "^%s*size%s+(%S*)%s*$", "%1")
    if matches > 0 then
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
    
    if msg ~= "" then
        _print("Unknown command '" .. msg .. "'.")
        _print("Available commands:")
    end

    _print("  /mhc on   - Show the reticle")
    _print("  /mhc show - Same as 'on'")

    _print("  /mhc off  - Hide the reticle")
    _print("  /mhc hide - Same as 'off'")

    _print("  /mhc size <pixels> - Set the diameter of the reticle")
end
