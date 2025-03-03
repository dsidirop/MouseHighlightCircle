-- MouseHighlightCircle.lua

-- Addon başlatıldığında çalıştır
local frame = CreateFrame("Frame", "MouseHighlightCircleFrame", UIParent)
local circle = frame:CreateTexture(nil, "OVERLAY")

-- Halka texture’ını ayarla (pikselli, beyaz kenar, şeffaf orta)
circle:SetTexture("Interface\\AddOns\\MouseHighlightCircle\\pixelring.tga") -- Özel pikselli halka texture’ı

-- Eğer texture bulunamazsa, bir hata mesajı göster
if not circle:GetTexture() then
    print("MouseHighlightCircle: pixelring.tga bulunamadı. Lütfen dosyayı Interface\\AddOns\\MouseHighlightCircle\\ klasörüne yerleştirin.")
    circle:SetTexture(1, 1, 1, 0.7) -- Geçici olarak beyaz bir kare (hata ayıklama için)
    circle:SetWidth(32)
    circle:SetHeight(32)
end

-- Texture boyutlarını ve konumunu ayarla
circle:SetWidth(32) -- Dış çap
circle:SetHeight(32) -- Dış çap
circle:SetVertexColor(1, 1, 1, 0.7) -- Yarı saydam beyaz

-- Fare hareketlerini takip et
frame:SetScript("OnUpdate", function(self, elapsed)
    local x, y = GetCursorPosition()
    local uiScale = UIParent:GetEffectiveScale()
    x = x / uiScale
    y = y / uiScale

    -- Halkayı fare pozisyonuna yerleştir
    circle:ClearAllPoints()
    circle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end)

-- Addon yüklendiğinde halkayı göster
frame:Show()
circle:Show()

-- Slash komutları ekle (isteğe bağlı, ayarlar için)
SLASH_MHC1 = "/mhc"
SlashCmdList["MHC"] = function(msg)
    if msg == "hide" then
        circle:Hide()
        print("MouseHighlightCircle hidden.")
    elseif msg == "show" then
        circle:Show()
        print("MouseHighlightCircle shown.")
    else
        print("/mhc show - Show circle")
        print("/mhc hide - Hide circle")
    end
end
