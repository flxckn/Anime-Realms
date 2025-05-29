local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Core = {}
local positions = {}

for _, pos in workspace.Mobs.Positions:GetChildren() do
    table.insert(positions, {
        Position = pos.Position,
        CFrame = pos.CFrame,
        Active = false
    })
end

local function getOpenPosition()
    for key, pos in positions do
        if not pos.Active then
            return pos, key
        end
    end
end

function Core:Initialize()
    self:DisplayName(self.Instance.Name)
    self:DisplayHealth(self.Properties.Health)

    self:Spawn()
    self:SetState("Idle")

    self.ID = #self.Active + 1

    --[[task.delay(5, function()
        self:Despawn()
        self:Deconstruct()
    end)]]

    -- print(self.Instance.Name .. " constructed, data:", active)
end

function Core:Spawn()
    local pos, key = getOpenPosition()

    if pos then
        pos.Active = true
        self.CurrentPos = key

        self.Instance.Parent = workspace.Mobs
        self.Instance:PivotTo(pos.CFrame)
        
        task.spawn(function()
            self.Instance:MoveTo(pos.Position)
            task.wait(1)
            self.Instance:MoveTo(pos.Position)
        end)
    else
        warn("Could not find an inactive spawn location.")
    end
end

function Core:Despawn()
    if self.CurrentPos then
        --warn("Despawning.")
        positions[self.CurrentPos].Active = false
    
        self.CurrentPos = nil
        self.Instance:Destroy()
    end
end

function Core:DisplayName(name)

end

function Core:DisplayHealth(health)

end

function Core:UpdateHealth(health)

end

function Core:Pathfind(...)

end

return Core
