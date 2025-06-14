--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local Text = require("./Basic/Text")
local Colors = require("../Utility/Colors")
local TransparencyContext = require("./Contexts/Transparency")

return function(props: {
	AnchorPoint: Vector2?,
	Position: UDim2?,
	AutomaticSize: Enum.AutomaticSize?,
	Size: (UDim2 | React.Binding<UDim2>)?,
	onClick: (() -> ())?,
	Text: {
		Content: string,
		Size: (number | React.Binding<number>)?,
	}?,
	LayoutOrder: number?,
	children: any,
	ZIndex: number?,
})
	local Transparency = React.useContext(TransparencyContext)

	local hovered, playHoverAnimation = ReactFlow.useTween({ info = TweenInfo.new(0.3), start = 0, target = 1 })

	local function isHovered(hovering: boolean)
		playHoverAnimation({ target = if hovering then 1 else 0 })
	end

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "rbxassetid://90818589136566",
		ImageColor3 = hovered:map(function(a0: number)
			return Colors.Main.ButtonPrimary:Lerp(Color3.new(1, 1, 1), a0 * 0.4)
		end),
		ScaleType = Enum.ScaleType.Slice,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		SliceCenter = Rect.new(173, 173, 173, 173),
		SliceScale = 0.3,
		ZIndex = props.ZIndex,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		ImageTransparency = Transparency,
		[React.Event.MouseButton1Down] = props.onClick,
		[React.Event.MouseEnter] = function()
			isHovered(true)
		end,
		[React.Event.MouseLeave] = function()
			isHovered(false)
		end,
	}, {
		["Text"] = if props.Text
			then React.createElement(Text, {
				TextSize = props.Text.Size,
				Text = props.Text.Content,
				Weight = "Bold",
				Size = UDim2.fromScale(1, 1),
				Color = Color3.fromHex("1B1B1B"),
				ZIndex = props.ZIndex,
			})
			else nil,

		["Children"] = if props.children then React.createElement(React.Fragment, nil, props.children) else nil,
	})
end
