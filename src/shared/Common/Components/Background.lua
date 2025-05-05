--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local TransparencyContext = require("./Contexts/Transparency")

type props = {
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Size: UDim2?,
	AutomaticSize: Enum.AutomaticSize?,
	children: any,
}

return function(props: props)
	local Transparency = React.useContext(TransparencyContext)

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "rbxassetid://94796467678935",
		ScaleType = Enum.ScaleType.Slice,
		Size = props.Size,
		SliceCenter = Rect.new(130, 130, 894, 894),
		SliceScale = 0.25,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		AutomaticSize = props.AutomaticSize,
		ImageTransparency = Transparency,
	}, props.children)
end
