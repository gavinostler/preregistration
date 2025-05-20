--!native
--!strict

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

return function<T>(
	objects: { [string | number]: T },
	time: number,
	dead: ((position: number) -> React.ReactElement<any, any>)?
): ({ [string | number]: T | React.ReactElement<any, any> }, () -> ())
	local currentList, setCurrentList = React.useState({} :: { [string | number]: T | React.ReactElement<any, any> })
	local isReady, setReady = React.useState(false)

	React.useEffect(function()
		if not isReady then
			return
		end
		task.spawn(function()
			local internal = {} :: { [string | number]: T | React.ReactElement<any, any> }
			local i = 1
			for _, obj in objects do
				internal["Object_" .. i] = obj
				local other = table.clone(internal)
				if dead ~= nil then
					local otherSize = 0
					for _, _ in other do
						otherSize += 1
					end

					for v = otherSize, #objects - 1 do
						other["dead_" .. v] = dead(v + 1)
					end
				end
				setCurrentList(other)
				task.wait(time)
				i += 1
			end
		end)
	end, { isReady })

	return currentList, function()
		setCurrentList({})
		setReady(true)
	end
end
