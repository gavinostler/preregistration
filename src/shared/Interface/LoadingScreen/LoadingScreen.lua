--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local InterfaceTypes = require("../../Common/Types/Interface")
local Colors = require("../../Common/Utility/Colors")
local TransparencyContext = require("../../Common/Components/Contexts/Transparency")
local OpenInSuccession = require("../../Common/Hooks/OpenInSuccession")
local Text = require("../../Common/Components/Basic/Text")
local Note = require("./Note")

type PossibleProps = {
	Text: string,
	ButtonText: string,
}

local np = { 0.05, 0.22, 0.32, 0.45, 0.61, 0.775, 0.9, 1.05, 1.17 }

local melody = { np[8], np[6], np[7], np[5], np[7], np[6], np[4], np[6] }

local TestInterface = function(props: PossibleProps & InterfaceTypes.InterfaceProps)
	local allnotes = React.useMemo(function()
		local list = {}
		for i, v in melody do
			table.insert(
				list,
				React.createElement(Note, {
					start = i,
					position = v,
				})
			)
		end
		return list
	end, {})

	local notes, open = OpenInSuccession(allnotes, 0.1, function(position: number)
		return React.createElement(Note, {
			start = position,
			position = 0,
			dead = true,
		})
	end)

	local transparency, playTransparency = ReactFlow.useTween({
		info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		start = 0,
		target = 1,
	})

	local move, playMove = ReactFlow.useTween({
		info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		start = 0,
		target = 1,
	})

	React.useEffect(function()
		task.spawn(function()
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end
			task.wait(1)
			open()
			playMove({ target = 1 })
			task.wait(3)
			playTransparency({ target = 1 })
		end)
	end, {})

	return React.createElement(TransparencyContext.Provider, { value = transparency }, {

		["UI"] = React.createElement("Frame", {
			BackgroundTransparency = transparency,
			BackgroundColor3 = Colors.Background.Primary,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, {
			["UI"] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}, {

				["Image"] = React.createElement("ImageLabel", {
					Image = "rbxassetid://131148056592817",
					ImageColor3 = Colors.Main.Gold,
					ImageTransparency = transparency:map(function(a: number)
						return 1 - (0.5 * (1 - a))
					end),
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(500, 85),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(
						789 * 1024 / 1920,
						1920 * 1024 / 1920,
						1170 * 1024 / 1920,
						1920 * 1024 / 1920
					),
				}, {
					["Fragment"] = React.createElement(React.Fragment, nil, notes :: any),
					["Gradient"] = React.createElement("UIGradient", {
						Transparency = move:map(function(a0: number)
							return NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(a0 * (0.08 + 0.9 * a0), 0),
								NumberSequenceKeypoint.new(a0 * 0.98 + 0.01, 1),
								NumberSequenceKeypoint.new(1, 1),
							})
						end),
					}),

					["UIListLayout"] = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 35 / 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
				}),

				["UIListLayout"] = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
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
			["Text"] = React.createElement(Text, {
				Color = Colors.Main.Gold,
				Text = "Loading...",
				Wraps = true,
				Size = UDim2.new(1, 0),
				Position = UDim2.new(0, 0, 1, -50),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1,
				TextSize = 24,
				Transparency = transparency:map(function(a: number)
					return 1 - (0.75 * (1 - a))
				end),
			}),
		}),
	})
end

local Interface = {
	context = {
		name = script.Name,
		ignoreInset = true,
		zindex = 100,
	} :: InterfaceTypes.InterfaceContext,
	func = TestInterface,
} :: InterfaceTypes.Interface<PossibleProps>

return Interface
