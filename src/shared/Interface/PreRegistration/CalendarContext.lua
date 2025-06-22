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
	rewards = {
		{
			item_id = 4,
			quantity = 100, -- day 1
		},
		{
			item_id = 1,
			quantity = 100,
		},
		{
			item_id = 4,
			quantity = 200, -- day 3
		},
		{
			item_id = 1,
			quantity = 150,
		},
		{
			item_id = 2,
			quantity = 1,
		},
		{
			item_id = 4,
			quantity = 300, -- day 6
		},
		{
			item_id = 3,
			quantity = 1,
		},
		{
			item_id = 1,
			quantity = 120,
		},
		{
			item_id = 4,
			quantity = 400, -- day 9
		},
		{
			item_id = 1,
			quantity = 200,
		},
		{
			item_id = 2,
			quantity = 1,
		},
		{
			item_id = 4,
			quantity = 500, -- day 12
		},
		{
			item_id = 1,
			quantity = 250,
		},
		{
			item_id = 3,
			quantity = 4,
		},
		{
			item_id = 4,
			quantity = 600, -- day 15
		},
		{
			item_id = 1,
			quantity = 300,
		},
		{
			item_id = 2,
			quantity = 2,
		},
		{
			item_id = 4,
			quantity = 650, -- day 18
		},
		{
			item_id = 1,
			quantity = 350,
		},
		{
			item_id = 4,
			quantity = 750, -- day 20
		},
		{
			item_id = 3,
			quantity = 4,
		},
		{
			item_id = 1,
			quantity = 400,
		},
		{
			item_id = 2,
			quantity = 2,
		},
		{
			item_id = 4,
			quantity = 850, -- day 24
		},
		{
			item_id = 1,
			quantity = 450,
		},
		{
			item_id = 4,
			quantity = 950, -- day 26
		},
		{
			item_id = 2,
			quantity = 3,
		},
		{
			item_id = 3,
			quantity = 4,
		},
		{
			item_id = 1,
			quantity = 500,
		},
		{
			item_id = 4,
			quantity = 1100, -- day 30
		},
		{
			item_id = 2,
			quantity = 4,
		},
	},
	claim_count = 0,
	available_to_claim = true,
	next_claim_at = DateTime.now(),
} :: CalendarContext)
