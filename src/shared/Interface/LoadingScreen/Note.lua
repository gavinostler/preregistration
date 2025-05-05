--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local Colors = require("../../Common/Utility/Colors")

local Note = function(props: { position: number })
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 30, props.position, 0),
		Size = UDim2.fromOffset(30, 55),
		AnchorPoint = Vector2.new(0.4),
	}, {
		["Image"] = React.createElement("ImageLabel", {
			Image = "rbxtemp://410",
			ImageColor3 = Colors.Main.Gold,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, props.position, 0),
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0, 0.8),
		}),
	})
end

return Note
