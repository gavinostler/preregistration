--!native
--!strict
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local useQuery = require(ReplicatedStorage.Shared.Common.Hooks.useQuery)
local General = require(ReplicatedStorage.Shared.Common.Types.API.General)
local Rewards = require(ReplicatedStorage.Shared.Common.Types.API.Rewards)
local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)
local Modal = require(ReplicatedStorage.Shared.Interface.Modal)
local React = require(Packages:WaitForChild("React"))

local Colors = require("../../Common/Utility/Colors")
local Text = require("../../Common/Components/Basic/Text")

local t = require("../../Common/Utility/Translation").t
local Context = require("./CalendarContext")

local Quark = require(game.ReplicatedStorage.CoreLibs.Quark)
local Service = Quark.GetService("Rewards")

type PossibleProps = {
	day: number,
	onClaim: () -> (),
}

local rewards = {
	[1] = "rbxassetid://91425343097829",
	[4] = "rbxassetid://72542184949165",
	[2] = "rbxassetid://94141814604714",
	[3] = "rbxassetid://103266540396327",
}

local Calendar = function(props: PossibleProps)
	local ctx = React.useContext(Context)

	if not ctx.rewards[1] then
		return
	end

	local function handleClaim()
		if ctx.available_to_claim and ctx.claim_count + 1 == props.day then
			Service.claimReward():andThen(function(d: Rewards.ClaimRewardResponse)
				InterfaceManager:displayInterface(Modal, {
					Text = t("ui.register.claimed"),
					Buttons = {
						{
							Text = t("common.ok"),
						},
					},
				})
				props.onClaim()
			end, function(err: General.APIResponse)
				if err.type == "EVENT_NOT_STARTED" then
					InterfaceManager:displayInterface(Modal, {
						Text = t(
							"ui.register.event_not_started",
							DateTime.fromIsoDate(err.starts_at)
								:FormatLocalTime("LLLL", LocalizationService.SystemLocaleId)
						),
						Buttons = {
							{
								Text = t("common.ok"),
							},
						},
					})
					return
				end
				InterfaceManager:displayInterface(Modal, {
					Text = t("ui.register.claim_error"),
					Buttons = {
						{
							Text = t("common.ok"),
						},
					},
				})
			end)
		elseif not ctx.available_to_claim and ctx.claim_count + 1 == props.day then
			InterfaceManager:displayInterface(Modal, {
				Text = t(
					"ui.register.cannot_claim",
					ctx.next_claim_at:FormatLocalTime("LT", LocalizationService.SystemLocaleId)
				),
				Buttons = {
					{
						Text = t("common.ok"),
					},
				},
			})
		elseif ctx.claim_count + 1 > props.day then
			InterfaceManager:displayInterface(Modal, {
				Text = t("ui.register.already_claimed"),
				Buttons = {
					{
						Text = t("common.ok"),
					},
				},
			})
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = props.day,
		ZIndex = 3,
	}, {
		["Blur"] = if ctx.available_to_claim and ctx.claim_count + 1 == props.day
			then React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://75080233675741",
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(1, 20, 1, 20),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 2,
			})
			else nil,
		["ClaimedOverlay"] = React.createElement("ImageButton", {
			Image = "rbxassetid://95873530772072",
			BackgroundTransparency = 1,
			ImageColor3 = if props.day <= ctx.claim_count then Color3.new(0.5, 0.5, 0.5) else Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = props.day,
			ZIndex = 3,
			[React.Event.MouseButton1Down] = handleClaim,
		}, {

			["RewardImage"] = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = rewards[ctx.rewards[props.day].item_id],
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(0.6, 0, 0.6, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				ImageColor3 = if props.day <= ctx.claim_count then Color3.new(0.5, 0.5, 0.5) else Color3.new(1, 1, 1),
				Position = UDim2.new(0.5, 0, 0.5, -15),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 2,
			}),

			["Text"] = React.createElement(Text, {
				Text = `x{ctx.rewards[props.day].quantity}`,

				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 0, 1, -30),
				AnchorPoint = Vector2.new(0, 1),
			}),

			["SecondaryFrame"] = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "rbxassetid://93226223826028",
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(1, -2, 0, 30),
				Position = UDim2.new(0.5, 0, 1, -1),
				AnchorPoint = Vector2.new(0.5, 1),
				ImageColor3 = Colors.Background.Accent,
				ZIndex = 3,
			}, {
				["Text"] = React.createElement(Text, {
					Text = `Day {props.day}`,

					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
				}),
			}),
		}),
	})
end

return Calendar
