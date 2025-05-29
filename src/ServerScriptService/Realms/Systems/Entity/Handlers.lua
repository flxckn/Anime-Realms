local Handlers = {}
Handlers.State = {}

function Handlers.State:Idle(entity, current)
    print("Idle:", current)
end

function Handlers.State:Moving(entity, current)
    print("Moving:", current)
end

function Handlers.State:Attacking(entity, current)
    print("Attacking:", current)
end

function Handlers.State:Stunned(entity, current)
    print("Stunned:", current)
end

function Handlers.State:Focusing(entity, current)
    print("Focusing:", current)
end

function Handlers.State:Chasing(entity, current)
    print("Chasing:", current)
end

return Handlers