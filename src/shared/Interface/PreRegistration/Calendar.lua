--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local CalendarContext = require(script.Parent.CalendarContext)
local Rewards = require(ReplicatedStorage.Shared.Common.Types.API.Rewards)
local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)
local React = require(Packages:WaitForChild("React"))

local Colors = require("../../Common/Utility/Colors")

local t = require("../../Common/Utility/Translation").t

local Item = require("./CalendarItem")

local Quark = require(game.ReplicatedStorage.CoreLibs.Quark)
local Service = Quark.GetService("Rewards")
local useQuery = require("../../Common/Hooks/useQuery")

type PossibleProps = {}

local Calendar = function(props: PossibleProps)
	local rwLoading, _, rewards = useQuery(Service.getRewards :: () -> Rewards.RewardsResponse)
	local lcLoading, _, data, refetch = useQuery(Service.getCanClaim :: () -> Rewards.LastClaimResponse)

	local canClaim, setCanClaim = React.useState(false)
	local day, setDay = React.useState(0)
	local nextClaimAt, setNextClaimAt = React.useState(nil :: DateTime?)

	React.useEffect(function()
		if data then
			print(data)
			setCanClaim(data.can_claim)
			setDay(data.day)
			setNextClaimAt(DateTime.fromIsoDate(data.next_claim_at))
		end
	end, { data })

	local function onClaim()
		setCanClaim(false)
		setDay(function(prevDay)
			return prevDay + 1
		end)
	end

	local items = React.useMemo(function()
		if rewards == nil then
			return {}
		end

		local items = {}
		for i = 1, 31 do
			items["Cal_" .. i] = React.createElement(Item, { day = i, onClaim = onClaim })
		end
		return items
	end, { rewards })

	React.useEffect(function()
		local timeElapsed = 0
		local event = RunService.Heartbeat:Connect(function()
			-- write a refresh system that will refetch last claim data every 30 seconds
			timeElapsed += RunService.Heartbeat:Wait()
			if timeElapsed >= 30 then
				timeElapsed = 0
				refetch()
			end
		end)

		return function()
			event:Disconnect()
		end
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(2, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Colors.Background.Primary,
		ZIndex = 3,
	}, {
		["Padding"] = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 40),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 40),
		}),
		["Sort"] = React.createElement("UIGridLayout", {
			CellSize = UDim2.new(0, 110, 0, 145),
			CellPadding = UDim2.fromOffset(20, 20),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirectionMaxCells = 7,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		["Provider"] = rwLoading or lcLoading and React.createElement("TextLabel", {
			Text = t("ui.register.loading_rewards"),
			Size = UDim2.new(1, 0, 0, 30),
		}) or React.createElement(CalendarContext.Provider, {
			value = {
				rewards = rewards or {},
				claim_count = day,
				available_to_claim = canClaim,
				next_claim_at = nextClaimAt,
			},
		}, {
			["Items"] = if not items
				then React.createElement("TextLabel", {
					Text = t("ui.register.loading_rewards"),
					Size = UDim2.new(1, 0, 0, 30),
				})
				else React.createElement(React.Fragment, nil, items :: any),
		}),
		InterfaceManager.ViewportScale(),
	})
end

return Calendar
