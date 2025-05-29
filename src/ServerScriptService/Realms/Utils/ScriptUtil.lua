local ScriptUtil = {}

function ScriptUtil:DeepCopy(tbl)
    local newTbl = {}
	for index, value in tbl do
		if type(value) == "table" then
			newTbl[index] = self:DeepCopy(value)
		else
			newTbl[index] = value
		end
	end
	return newTbl
end

function ScriptUtil:Reconcile(target, template)
	for k, v in pairs(template) do
		if type(k) == "string" then
			if target[k] == nil then
				if type(v) == "table" then
					target[k] = self:DeepCopy(v)
				else
					target[k] = v
				end
			elseif type(target[k]) == "table" and type(v) == "table" then
				self:Reconcile(target[k], v)
			end
		end
	end
end

return ScriptUtil