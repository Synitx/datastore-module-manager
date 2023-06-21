local manager = {}
local datastore = require(script.Datastore)

export type Signal = {
	Connect: (self: Signal, func: (...any) -> (), ...any) -> Connection,
	Once: (self: Signal, func: (...any) -> (), ...any) -> Connection,
	Wait: (self: Signal, ...any) -> ...any,
	Fire: (self: Signal, ...any) -> (),
	FastFire: (self: Signal, ...any) -> (),
	DisconnectAll: (self: Signal) -> (),
}

export type Connection = {
	Signal: Signal?,
	Disconnect: (self: Connection) -> (),
}

local events = {
	OnError = Instance.new("BindableEvent")
}

export type DataStoreObject = {
	get:(Key:string?)->(any?);
	set:(Key:string,Value:any) -> (any?),
	increment: (Key:string,Value:number?) -> (number),
	save: () -> (any?),
	close: ()->(boolean),
	saved: Signal
}

function manager.new(DataStoreName:string,Scope:string,Key:string?,Template:{}?) : DataStoreObject|nil
	local store = datastore.find(DataStoreName,Scope,Key)
	if (not store) then
		if (not Template) then return warn('Template is required') end
		store = datastore.new(DataStoreName,Scope,Key)
		while store.State == false do
			if store:Open(Template) ~= "Success" then
				events.OnError:Fire(`Unable to open data for key {Key}, retrying in 6 seconds..`)
				task.wait(6)
			end
		end
	end
	return {
		get = function(Key:string?)
			if not Key then
				return store
			end
			return store.Value[Key] or nil
		end,
		set = function(Key:string,Value:any)
			if (not Key) then
				events.OnError:Fire(`Key is required to set the data.`)
				return
			end
			if (not Value) then
				events.OnError:Fire(`Value is required to set the data.`)
				return
			end
			store.Value[Key] = Value
			return store.Value[Key]
		end,
		increment = function(Key:string,Value:number?)
			if not Value then
				Value = 1
			end
			if (typeof(store.Value[Key]) == "number") then
				events.OnError:Fire(`The value for key {Key} isn't a number!`)
				return
			end
			if (not store.Value[Key]) then
				store.Value[Key] = Value
				return store.Value[Key]
			end
			store.Value[Key] += Value
			return store.Value[Key]
		end,
		save = function()
			store:Save()
			return store.Value
		end,
		saved = store.Saved,
		close = function()
			if store ~= nil then
				store:Destroy()
				return true
			else
				return false
			end
		end,
	}
end

manager.onError = events.OnError.Event

return manager
