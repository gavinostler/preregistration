local NumbersUtility = {}

function NumbersUtility.comma_value(amount: number | string)
	local formatted = amount
	while true do
		local k
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

return NumbersUtility
