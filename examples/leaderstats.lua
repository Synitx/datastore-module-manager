local manager = require(game.ReplicatedStorage.Manager)
local template = {
    Level = 1,
    Coins = 0,
    Inventory = {}
}

function setupLeaderstats(player)
    local folder = Instance.new("Folder",player)
    folder.Name = "leaderstats"
    
    for i,v in pairs({Level = 1, Coins = 0}) do
        local val = Instance.new("NumberValue",folder)
        val.Name = i
        val.Value = v
    end
    
    return folder
end

game.Players.PlayerAdded:Connect(function(plr)
    local data = manager.new({
        name = 'PlayerDataTest',
        scope = 'Player',
        key = plr.UserId,
        template = template
    })
    
    local leaderstats = setupLeaderstats(plr)
    
    data.onError:Connect(function(err)
        warn(err)
    end)
    data.onSave:Connect(function(key,value)
        print(`Successfully saved key {key} with the value of {value}!`)
    end)
    data.onIncrement:Connect(function(key,incrementedValue)
        print(`Successfully incremented value for key {key}, total value: {incrementedValue}`)
    end)
    
    local playerLevel = data.get('Level')
    if (playerLevel) then
        leaderstats.Level.Value = playerLevel
    end
    local playerCoins = data.get('Coins')
    if (playerCoins) then
        leaderstats.Coins.Value = playerCoins
    end
    leaderstats.Level:GetPropertyChangedSignal("Value"):Connect(function()
        data.save('Level',leaderstats.Level.Value)
    end)
    leaderstats.Coins:GetPropertyChangedSignal("Value"):Connect(function()
        data.save('Coins',leaderstats.Coins.Value)
    end)
end)

game.Players.PlayerRemoving:Connect(function(plr)
    manager.close({name='PlayerDataTest',scope='Player',key=plr.UserId}):Then(function(state)
        print(`Is Data saved for {plr.Name}? : {state}`)
    end):Catch(warn)
end)
