local module = require(game.ReplicatedStorage.Manager)
local template = {
	Coins = 0
}

module.onError:Connect(function(errorMessage)
	warn(errorMessage)
end)

game.Players.PlayerAdded:Connect(function(player)
	local datastore = module.new("Player",`Player_{player.UserId}`,nil,template)
	if (not datastore) then
		warn('Something is wrong!')
	end
	local value = datastore.get("Coins")
	
	local leaderstats = Instance.new("Folder",player)
	leaderstats.Name = "leaderstats"
	
	local coins = Instance.new("NumberValue",leaderstats)
	coins.Name = "Coins"
	coins.Value = value or 0
	
	datastore.saved:Connect(function(state)
		print(state)
	end)
	
	coins:GetPropertyChangedSignal("Value"):Connect(function()
		datastore.set("Coins",coins.Value)
	end)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local datastore = module.new("Player",`Player_{player.UserId}`)
	local isClosed = datastore.close()
	print(isClosed and `datastore closed for key Player_{player.UserId}` or `unable to close datastore for key Player_{player.UserId}`)
end)
