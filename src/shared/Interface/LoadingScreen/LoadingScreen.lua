--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local InterfaceTypes = require("../../Common/Types/Interface")
local Colors = require("../../Common/Utility/Colors")
local TransparencyContext = require("../../Common/Components/Contexts/Transparency")
local Note = require("./Note")

type PossibleProps = {
	Text: string,
	ButtonText: string,
}

local possibleNotePositions = { 0.125, 0.22, 0.3, 0.4, 0.5, 0.6, 0.68, 0.78, 0.875 }

local TestInterface = function(props: PossibleProps & InterfaceTypes.InterfaceProps)
	local notePositions = React.useMemo(function()
		local list = {}
		for i = 1, 10 do
			list[i] = possibleNotePositions[math.random(1, #possibleNotePositions)]
		end
		return list
	end, {})

	local notes = {}
	for i, value in notePositions do
		notes["Note_" .. i] = React.createElement(Note, {
			position = value,
		})
	end

	return React.createElement(TransparencyContext.Provider, { value = 0 }, {
		["UI"] = React.createElement("Frame", {
			BackgroundTransparency = 0,
			BackgroundColor3 = Colors.Background.Primary,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, {

			["Image"] = React.createElement("ImageLabel", {
				Image = "rbxtemp://409",
				ImageColor3 = Colors.Main.Gold,
				ImageTransparency = 0.5,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(500, 85),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(789, 1920, 1170, 1920),
			}, {
				React.createElement(React.Fragment, nil, notes :: any),

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
