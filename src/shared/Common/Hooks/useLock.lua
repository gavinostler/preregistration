--!native
--!strict

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

return function(timeout: number?): (boolean, (f: () -> ()) -> () -> (), (locked: boolean) -> ())
	local locked, setLocked = React.useState(false)

	return locked,
		function(f: () -> ())
			return function()
				if locked then
					warn("Unable to acquire locked function")
					return
				end

				setLocked(true)
				f()
				setLocked(false)
			end
		end,
		setLocked
end
