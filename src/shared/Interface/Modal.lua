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
local CloseFunctionHook = require("../Common/Hooks/CloseFunctionHook")
local TransparencyContext = require("../Common/Components/Contexts/Transparency")

type PossibleProps = {
	Text: string,
	Buttons: {
		{
			Text: string,
			Callback: (() -> ())?,
		}
	}?,
}

local TestInterface = function(props: PossibleProps & InterfaceTypes.InterfaceProps)
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

	CloseFunctionHook(props.interfaceId, closeMe)

	local buttons = React.useMemo(function()
		if props.Buttons == nil then
			return {}
		end

		local buttonList = {}
		for i, button in props.Buttons do
			buttonList["Button_" .. i] = React.createElement(Button, {
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(0, 150, 0, 30),
				Text = {
					Content = button.Text,
				},
				LayoutOrder = i,

				onClick = function()
					if button.Callback then
						button.Callback()
					end
					closeMe()
				end,
			}, {
				React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Shrink,
					ItemLineAlignment = Enum.ItemLineAlignment.Center,
				}),
			})
		end

		return buttonList
	end, { props.Buttons })

	return React.createElement(TransparencyContext.Provider, { value = placement }, {

		["UI"] = React.createElement(Background, {
			Position = placement:map(function(a0: number)
				return UDim2.new(0.5, 0, 0.5, 50 * a0)
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(400, 100),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, {
			["ScaleFix"] = React.createElement("UIScale", {
				Scale = 1.25,
			}), -- fix for stupidness

			["Text"] = React.createElement(Text, {
				Text = props.Text
					or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
				Weight = "Bold",
				Wraps = true,
				Size = UDim2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 0,
			}),

			["ButtonHolder"] = if buttons["Button_1"] == nil
				then nil
				else React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
				}, {
					React.createElement(React.Fragment, nil, buttons),
					["UIListLayout"] = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.None,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 20 / 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
				}),

			["UIListLayout"] = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 35 / 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
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
		zindex = 10,
	} :: InterfaceTypes.InterfaceContext,
	func = TestInterface,
} :: InterfaceTypes.Interface<PossibleProps>

return Interface
