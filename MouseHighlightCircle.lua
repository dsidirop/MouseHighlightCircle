-- MouseHighlightCircle.lua

local frame = CreateFrame("Frame", "MouseHighlightCircleFrame", UIParent)

frame:SetFrameStrata("TOOLTIP") -- if we need the overlay to be above any and all ui elements    should be what most users want on 4k monitors
-- frame:SetFrameStrata("HIGH") -- if we need the overlay to be above most UI elements but not above dialogs such as the pfui-configuration dialog

local circle = frame:CreateTexture(nil, "OVERLAY")

local overlayImage = "Interface\\AddOns\\MouseHighlightCircle\\pixelring.tga"

-- set ring texture (pixelated, white edge, transparent center)
circle:SetTexture(overlayImage)

-- if the texture is not found print an error and use a placeholder texture
if not circle:GetTexture() then
    print("MouseHighlightCircle: Mouse-overlay image was not found on disk - make sure the file '" .. overlayImage .. "' exists in the filesystem.")
    circle:SetTexture(1, 1, 1, 0.7) -- temporarily a white square (for debugging)
    circle:SetWidth(32)
    circle:SetHeight(32)
end

-- adjust texture dimensions and position
circle:SetWidth(32)
circle:SetHeight(32)
circle:SetVertexColor(1, 1, 1, 0.7) -- translucent white

-- track mouse movements
local _lastX, _lastY, _uiScale= -999999, -999999, nil
frame:SetScript("OnUpdate", function()
    local x, y = GetCursorPosition()
    if x == _lastX and y == _lastY then
        return -- mouse hasn't moved   do nothing
    end
    
    if _uiScale == nil then
        _uiScale = UIParent:GetEffectiveScale() -- snipe once
        if _uiScale == nil or _uiScale <= 0 then
            _uiScale = 1 -- failsafe
            print("[WARNING] [MouseHighlightCircle] GetEffectiveScale() returned unusable value '" .. tostring(_uiScale or "nil") .. "' - assuming ui-scale=1 and hoping for the best but please report this incident and what you did to cause it.")
        end
    end
    
    _lastX, _lastY = x, y -- order
    x = x / _uiScale -- order
    y = y / _uiScale -- order

    -- circle:ClearAllPoints() -- doesnt seem to be truly necessary in this particular case
    circle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y) -- place the ring around the mouse cursor
end)

-- show ring when addon is installed
frame:Show()
circle:Show()

-- add slash commands (optional, for settings)
SLASH_MHC1 = "/mhc"
SlashCmdList["MHC"] = function(msg)
    if msg == "hide" then
        frame:Hide()
        print("MouseHighlightCircle hidden.")
    elseif msg == "show" then
        frame:Show()
        print("MouseHighlightCircle shown.")
    else
        print("/mhc show - Show circle")
        print("/mhc hide - Hide circle")
    end
end
