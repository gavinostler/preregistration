--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

export type CalendarContext = {
	rewards: { { item_id: number, quantity: number } },
	claim_count: number,
	available_to_claim: boolean,

	next_claim_at: DateTime,
}

return React.createContext({
	rewards = {},
	claim_count = 0,
	available_to_claim = true,
	next_claim_at = DateTime.now(),
} :: CalendarContext)
