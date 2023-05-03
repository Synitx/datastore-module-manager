local manager = {}
local datastore = require(script.Datastore)
local Promise = require(script.Promise)

local template = {}
export type ManagerOptions = {
    name:string?,
    scope:string?,
    key:string?,
    template:{}?
}

export type ManagerCloseOptions = {
    name:string,
    key:string?,
    scope:string
}

local events = {
    onSave = Instance.new("BindableEvent"),
    onIncrement = Instance.new("BindableEvent"),
    onError = Instance.new("BindableEvent")
}

function manager.new(options:ManagerOptions)
    local name,scope,key,template = options.name,options.scope,options.key,options.template
    local data = datastore.new(name,scope,key)
    local errorType = data:Open(template)
    if errorType ~= nil then warn(`Failed to open datastore {name} for scope {scope}`) end
    local functions = {}
    functions.get = function(key:string?) : any?
        if not data.Value then
            return nil
        end
        local res = data.Value[key]
        if (res) then
            return res
        else
            return nil
        end
    end
    functions.save = function(key:string,value:string|{}|boolean|number)
        return Promise.new(function(resolve,reject)
            if (data.State ~= true) then
                events.onError:Fire('Error while saving data: Data state is not true!')
                return nil
            end
            if not value then
                events.onError:Fire('Error while saving: Value argument is required.')
                reject('Value argument is required.')
            else
                data.Value[key] = value
                events.onSave:Fire(key,value)
                resolve(data.Value[key])
            end
        end)
    end
    functions.increment = function(key:string,value:number)
        return Promise.new(function(resolve,reject)
            if (data.State ~= true) then
                events.onError:Fire('Error while saving data: Data state is not true!')
                return nil
            end
            local info = data.Value[key]
            if (not info) then
                data.Value[key] = value
                resolve(data.Value[key])
            end
            if (typeof(info) ~= "number") then
                events.onError:Fire(`Error while incrementing: {key} value must be a number.`)
                reject(`{key} value must be a number`)
            end
            data.Value[key] += value
            events.onIncrement:Fire(key,value)
            resolve(data.Value[key])
        end)
    end
    functions.onSave = events.onSave.Event
    functions.onIncrement = events.onIncrement.Event
    functions.onError = events.onError.Event
    return functions
end

function manager.close(options:ManagerCloseOptions)
    return Promise.new(function(resolve,reject)
        local foundedDataStore = datastore.find(options.name,options.scope,options.key)
        if not foundedDataStore then
            reject(`Manager Close: Datastore named {options.name} not found!`)
        end
        foundedDataStore:Destroy()
        resolve(true)
    end)
end

return manager
