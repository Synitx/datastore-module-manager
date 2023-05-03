##Datastore Manager Module Documentation
This module provides a simple way to manage Roblox Datastore operations. It allows users to read, write, and increment values stored in a specific datastore with a given scope and key.

###Usage
new(options: ManagerOptions) -> Functions
This function creates a new datastore manager with the provided options.

Parameters:
options (required): A table that contains the following properties:
name (optional, default is "DataStore"): The name of the datastore to be managed.
scope (optional, default is "global"): The scope of the datastore to be managed.
key (optional): The key of the datastore to be managed.
template (optional): A template table for the datastore. If specified, it will be used to initialize the datastore with default values.
Returns:
This function returns a table with the following properties:

get(key: string?) -> any?: Returns the value associated with the specified key. If no key is provided, it returns the entire datastore.
save(key: string, value: string|{}|boolean|number) -> Promise: Saves a value associated with the specified key to the datastore.
increment(key: string, value: number) -> Promise: Increments the value associated with the specified key by the provided value.
onSave -> RBXScriptSignal: An event that fires when a value is saved to the datastore. The event returns the key and value that were saved.
onIncrement -> RBXScriptSignal: An event that fires when a value is incremented in the datastore. The event returns the key and value that were incremented.
onError -> RBXScriptSignal: An event that fires when an error occurs while saving or incrementing a value in the datastore. The event returns an error message.
close(options: ManagerCloseOptions) -> Promise
This function closes a previously opened datastore.

Parameters:
options (required): A table that contains the following properties:
name (required): The name of the datastore to be closed.
key (optional): The key of the datastore to be closed.
scope (optional, default is "global"): The scope of the datastore to be closed.
Returns:
This function returns a Promise that resolves with a boolean value of true if the datastore was successfully closed, and rejects with an error message if the datastore was not found.

Examples
> Saving a value to a datastore:
```lua
local manager = require(path.to.manager)

local dataManager = manager.new({
    name = "PlayerData",
    scope = "Player",
    key = player.UserId,
    template = {
        Coins = 0,
        Level = 1
    }
})

dataManager.save("Coins", 500)
```
> Reading a value from a datastore:
```lua
local manager = require(path.to.manager)

local dataManager = manager.new({
    name = "PlayerData",
    scope = "Player",
    key = player.UserId
})

local coins = dataManager.get("Coins")
```
> Incrementing a value in a datastore:
```lua
local manager = require(path.to.manager)

local dataManager = manager.new({
    name = "PlayerData",
    scope = "Player",
    key = player.UserId,
    template = {
        Coins = 0,
        Level = 1
    }
})

dataManager.increment("Coins", 100)
```
