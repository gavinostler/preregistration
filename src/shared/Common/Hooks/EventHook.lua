--!native
--!strict

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

return function<T>(event: RBXScriptSignal<T>, callback: (...T) -> ())
	React.useEffect(function()
		local e = event:Connect(callback)
		return function()
			return e:Disconnect()
		end
	end, {})
end
