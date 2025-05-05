--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local InterfaceTypes = require("../Common/Types/Interface")
local Background = require("../Common/Components/Background")
local Button = require("../Common/Components/Button")
local Text = require("../Common/Components/Basic/Text")
local OpenCloseHook = require("../Common/Hooks/OpenCloseHook")
local TransparencyContext = require("../Common/Components/Contexts/Transparency")

type PossibleProps = {
	Text: string,
	ButtonText: string,
} & InterfaceTypes.InterfaceProps

local TestInterface = function(props: PossibleProps)
	local placement, playPlacement, _ = ReactFlow.useTween({
		info = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
		start = 1,
		target = 0,
	})

	local closeMe = OpenCloseHook(props.interfaceId, function()
		playPlacement({ target = 0 })
	end, function()
		playPlacement({ target = 1 })
		task.wait(0.3)
	end)

	return React.createElement(TransparencyContext.Provider, { value = placement }, {
		["UI"] = React.createElement(Background, {
			Position = placement:map(function(a0: number)
				return UDim2.new(0.5, 0, 0.5, 50 * a0)
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(400, 100),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, {

			["Text"] = React.createElement(Text, {
				Text = props.Text
					or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
				Weight = "Bold",
				Wraps = true,
				Size = UDim2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 0,
			}),

			["Button"] = React.createElement(Button, {
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 150, 0, 30),
				Text = {
					Content = "Ok",
				},
				LayoutOrder = 1,

				onClick = closeMe,
			}),

			["UIListLayout"] = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
				Padding = UDim.new(0, 35 / 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			["UIPadding"] = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 35),
				PaddingBottom = UDim.new(0, 35),
				PaddingLeft = UDim.new(0, 35),
				PaddingRight = UDim.new(0, 35),
			}),
		}),
	})
end

local Interface = {
	context = {
		name = script.Name,
		ignoreInset = true,
		zindex = 1,
	} :: InterfaceTypes.InterfaceContext,
	func = TestInterface,
} :: InterfaceTypes.Interface<PossibleProps>

return Interface
