local State = {}

function State:Idle(current)
    --print("Idle:", current)
end

function State:Moving(current)
    print("Moving:", current)
end

function State:Attacking(current)
    print("Attacking:", current)
end

function State:Stunned(current)
    print("Stunned:", current)
end

function State:Focusing(current)
    print("Focusing:", current)
end

function State:Chasing(current)
    print("Chasing:", current)
end

return State
