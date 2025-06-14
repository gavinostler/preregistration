--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

local FontUtility = require("../../Utility/Fonts")
local TransparencyContext = require("../Contexts/Transparency")

type props = {
	Text: string,
	TextSize: (number | React.Binding<number>)?,
	Color: Color3?,
	Wraps: boolean?,
	XAlignment: Enum.TextXAlignment?,
	YAlignment: Enum.TextYAlignment?,
	Weight: FontUtility.AvailableWeights?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Size: UDim2?,
	AutomaticSize: Enum.AutomaticSize?,
	LayoutOrder: number?,
	Transparency: number?,
	ZIndex: number?,
	children: any,
}

return function(props: props)
	local Transparency = props.Transparency or React.useContext(TransparencyContext)

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = props.Text,
		TextWrapped = props.Wraps or true,
		TextSize = props.TextSize or 18,
		Size = props.Size,
		FontFace = FontUtility[props.Weight or "Default"],
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		AutomaticSize = props.AutomaticSize,
		RichText = true,
		TextTransparency = Transparency,
		TextColor3 = props.Color or Color3.fromRGB(240, 240, 240),
		TextXAlignment = props.XAlignment,
		TextYAlignment = props.YAlignment or Enum.TextYAlignment.Center,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
	}, props.children)
end
