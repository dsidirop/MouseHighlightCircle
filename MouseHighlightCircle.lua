-- MouseHighlightCircle.lua

local frame = CreateFrame("Frame", "MouseHighlightCircleFrame", UIParent)
frame:SetFrameStrata("HIGH")

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
frame:SetScript("OnUpdate", function(self, elapsed)
    local x, y = GetCursorPosition()
    local uiScale = UIParent:GetEffectiveScale()
    x = x / uiScale
    y = y / uiScale

    -- place the ring on the mouse position
    circle:ClearAllPoints()
    circle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
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
