--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local General = require(ReplicatedStorage.Shared.Common.Types.API.General)
local React = require(Packages:WaitForChild("React"))

return function<T, Q>(
	query: (...Q) -> any,
	data: { skip: boolean, variables: { Q }? }?
): (boolean, General.APIResponse?, T?, () -> any)
	local isLoading, setIsLoading = React.useState(false)
	local responseData, setResponseData = React.useState({} :: { data: T?, err: General.APIResponse? })

	local function fetch()
		setIsLoading(true)

		return query(table.unpack(data and data.variables or {}))
			:andThen(function(result: T)
				setResponseData({ data = result, err = nil })
			end, function(err: General.APIResponse)
				setResponseData({ data = nil, err = err })
			end)
			:finally(function()
				setIsLoading(false)
			end)
	end

	React.useEffect(function()
		if not data or not data.skip then
			fetch()
		end
	end, { data and data.skip or false })

	return isLoading, responseData.err, responseData.data, fetch
end
