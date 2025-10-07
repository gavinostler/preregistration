--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local InterfaceManager = require(ReplicatedStorage.Shared.Controllers.InterfaceManager)
local React = require(Packages:WaitForChild("React"))

local Colors = require("../../Common/Utility/Colors")
local Button = require("../../Common/Components/Button")

local t = require("../../Common/Utility/Translation").t

type PossibleProps = {
	scrollTo: (s: number) -> (),
}

local TestInterface = function(props: PossibleProps)
	local sy = InterfaceManager.ViewportScaleBinding("y")
	local sx = InterfaceManager.ViewportScaleBinding("x")

	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Colors.Background.Primary,
		BorderSizePixel = 0,
		Size = sy:map(function(a0: number)
			return UDim2.new(1, 0, 0, 60 * math.max(a0, 0.75))
		end),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		ZIndex = 3,
	}, {

		["Layout"] = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0.025, 0),
		}),
		["PD"] = React.createElement("Frame", {
			Size = UDim2.new(5.52 * 0.65, 0, 0.65, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			ZIndex = 3,
		}, {
			["Logo"] = React.createElement("ImageLabel", {
				Image = "rbxassetid://70834101153612",
				BackgroundColor3 = Color3.new(1, 1, 1),
				ScaleType = Enum.ScaleType.Fit,
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(5.52, 0, 1, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				ZIndex = 3,
			}),
		}),

		["Preregister Button"] = React.createElement(Button, {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0, 0),
			Size = sx:map(function(x: number)
				return UDim2.new(0, math.max(x, 0.75) * 200, 0.65, 0)
			end),
			Text = {
				Content = t("ui.register.button"),
				Size = sy:map(function(x: number)
					return math.max(0.75, x) * 24
				end),
			},
			onClick = function()
				props.scrollTo(0)
			end,
			ZIndex = 3,
		}),

		-- ["Other Rewards"] = React.createElement(Button, {
		-- 	LayoutOrder = 3,
		-- 	AnchorPoint = Vector2.new(0, 0),
		-- 	Size = sx:map(function(x: number)
		-- 		return UDim2.new(0, math.max(x, 0.75) * 200, 0.65, 0)
		-- 	end),
		-- 	Text = {
		-- 		Content = t("ui.register.other_rewards"),
		-- 		Size = sy:map(function(x: number)
		-- 			return math.max(0.75, x) * 24
		-- 		end),
		-- 	},
		-- 	onClick = function()
		-- 		props.scrollTo(0.5)
		-- 	end,
		-- 	ZIndex = 3,
		-- }),
	})
end

return TestInterface
