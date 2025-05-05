--!native
--!strict

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

--[[
    Returns a function that will construct a new hide/close hook.
]]
return function(onChange: (interfaceId: string) -> ())
	return function(interfaceId: string, open: (() -> ())?, close: (() -> ())?): () -> ()
		local shouldChange, setState = React.useState(false)

		React.useEffect(function()
			if shouldChange then
				task.spawn(function()
					if close then
						close()
					end
					onChange(interfaceId)
				end)
			elseif open then
				task.spawn(open)
			end
		end, { shouldChange })

		return function()
			setState(true)
		end
	end
end
