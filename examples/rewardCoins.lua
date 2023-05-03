script.Parent.ProximityPrompt.Triggered:Connect(function(plr)
    local val = plr.leaderstats["Coins"].Value
    plr.leaderstats["Coins"].Value = val+(math.random(1,10))
end)
