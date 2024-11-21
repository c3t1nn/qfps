local addonName, addon = ...
local qFPS = CreateFrame("Frame", "qFPSFrame", UIParent)

-- Default settings
local defaults = {
    enabled = true,
    point = "TOPRIGHT",
    xOfs = -100,
    yOfs = -15,
}

-- Frame setup
qFPS:SetWidth(120)
qFPS:SetHeight(20)
qFPS:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, -15)

-- Make frame movable
qFPS:EnableMouse(true)
qFPS:SetMovable(true)
qFPS:RegisterForDrag("LeftButton")
qFPS:SetScript("OnDragStart", function(self) self:StartMoving() end)
qFPS:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, xOfs, yOfs = self:GetPoint()
    qFPSDB.point = point
    qFPSDB.xOfs = xOfs
    qFPSDB.yOfs = yOfs
end)

-- Text display
local text = qFPS:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
text:SetPoint("CENTER")
text:SetTextColor(1, 0.82, 0) -- Vanilla WoW gold color

-- Main update function
local timeSinceLastUpdate = 0
local function UpdateDisplay()
    local fps = math.floor(GetFramerate())
    local _, _, latency = GetNetStats()
    
    text:SetText(fps .. " fps " .. latency .. " ms")
end

-- Event handlers
qFPS:SetScript("OnUpdate", function(self, elapsed)
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed
    if timeSinceLastUpdate >= 1.0 then
        UpdateDisplay()
        timeSinceLastUpdate = 0
    end
end)

-- Initialize
qFPS:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not qFPSDB then
            qFPSDB = CopyTable(defaults)
        else
            for k, v in pairs(defaults) do
                if qFPSDB[k] == nil then
                    qFPSDB[k] = v
                end
            end
        end
        
        qFPS:ClearAllPoints()
        qFPS:SetPoint(qFPSDB.point, UIParent, qFPSDB.point, qFPSDB.xOfs, qFPSDB.yOfs)
    end
end)
qFPS:RegisterEvent("PLAYER_LOGIN")

-- Slash commands
SLASH_QFPS1 = "/qfps"
SlashCmdList["QFPS"] = function(msg)
    if qFPS:IsShown() then
        qFPS:Hide()
    else
        qFPS:Show()
    end
end