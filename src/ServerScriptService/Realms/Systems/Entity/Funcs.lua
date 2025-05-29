local CollectionService = game:GetService("CollectionService")

local Properties, States = require(script.Parent.Properties), require(script.Parent.States)
local CoreHandler, StateHandler = require(script.Parent.CoreHandler), require(script.Parent.StateHandler)
local ScriptUtil = require(script.Parent.Parent.Parent.Utils.ScriptUtil)

local Funcs = {}
local EntityFuncs = {}
local activeEntities = {}

EntityFuncs.__index = EntityFuncs

function EntityFuncs:SetState(state)
    for _state, val in self.States do
        if _state == state then
            self.States[state] = true
            self[state](self, true)
        elseif val then
            self.States[_state] = false
            self[_state](self, false)
        end
    end

    self.CurrentState = state
end

function EntityFuncs:GetState()
    return self.CurrentState
end

function EntityFuncs:Deconstruct()
    activeEntities[self.ID] = nil
end

function Funcs:Init(Entity)
    function Entity:Construct(entity)
        local active = setmetatable({}, EntityFuncs)

        active.ActiveEntities = activeEntities
        active.Instance = entity
        active.States = table.clone(States)

        ScriptUtil:Reconcile(active, CoreHandler)
        ScriptUtil:Reconcile(active, StateHandler)

        if Properties[entity.Name] then
            active.Properties = table.clone(Properties[entity.Name])
        else
            active.Properties = table.clone(Properties.Default)
        end

        active:Initialize()
        table.insert(activeEntities, active)
    end
    
    for _, entity in CollectionService:GetTagged("Entity") do
        Entity:Construct(entity)
    end

    CollectionService:GetInstanceAddedSignal("Entity"):Connect(function(entity)
        Entity:Construct(entity)
    end)
end

return Funcs
