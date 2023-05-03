local floor,sqrt = math.floor, math.sqrt
script.Parent.ProximityPrompt.Triggered:Connect(function(plr)
    local val = plr.leaderstats["Coins"].Value
    local level = plr.leaderstats["Level"].Value
    plr.leaderstats["Level"].Value = level + floor(sqrt(val/100))
    plr.leaderstats["Coins"].Value = 0
end)
