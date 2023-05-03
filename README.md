# Datastore Manager Module

This module provides a set of functions to interact with Roblox Datastores.

## Usage

### `manager.new(options:ManagerOptions)`

Creates a new instance of the datastore manager with the specified options.

#### Parameters
- `options:ManagerOptions`: The options for the datastore manager.
    - `name:string?`: The name of the datastore.
    - `scope:string?`: The scope of the datastore.
    - `key:string?`: The key of the datastore.
    - `template:{}?`: The template of the datastore.

#### Returns
A table containing the following functions:
- `get(key:string?) : any?`: Returns the value for the specified key.
- `save(key:string,value:string|{}|boolean|number) : Promise`: Saves the value for the specified key.
- `increment(key:string,value:number) : Promise`: Increments the value for the specified key.
- `onSave : RBXScriptSignal`: Fired when data is saved.
- `onIncrement : RBXScriptSignal`: Fired when data is incremented.
- `onError : RBXScriptSignal`: Fired when an error occurs.

### `manager.close(options:ManagerCloseOptions) : Promise`

Closes the specified datastore.

#### Parameters
- `options:ManagerCloseOptions`: The options for closing the datastore.
    - `name:string`: The name of the datastore.
    - `scope:string?`: The scope of the datastore.
    - `key:string?`: The key of the datastore.

#### Returns
A Promise that resolves with `true` if the datastore is successfully closed.

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
