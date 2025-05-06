--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local Colors = require("../../Common/Utility/Colors")
local TransparencyContext = require("../../Common/Components/Contexts/Transparency")

local Note = function(props: { start: number, position: number, dead: boolean? })
	local Transparency = React.useContext(TransparencyContext)
	local animations, playAnimation = ReactFlow.useGroupAnimation({
		enable = ReactFlow.useSequenceAnimation({
			{
				timestamp = 0,
				transparency = ReactFlow.Tween({
					start = 1,
					target = 0,
					info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				}),
				move = ReactFlow.Tween({
					start = 1,
					target = 0,
					info = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				}),
			},
			{
				timestamp = 0.1,
				glow = ReactFlow.Tween({
					start = 1,
					target = 0,
					info = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				}),
			},
			{
				timestamp = 0.4,
				glow = ReactFlow.Tween({
					start = 0,
					target = 1,
					info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				}),
			},
		}),
		disable = ReactFlow.useAnimation({}),
	}, {
		glow = 1,
		transparency = 1,
		move = 1,
	})

	local rand = React.useMemo(function()
		return Vector2.new(math.random(-30, 30), math.random(-100, 100))
	end, {})
	local randrot = React.useMemo(function()
		return math.random(-15, 15)
	end, {})

	React.useEffect(function()
		if props.dead then
			return
		end
		playAnimation("enable")
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = props.start,
		Position = UDim2.new(0, 30, 0, 0),
		Size = UDim2.fromOffset(30, 55),
		AnchorPoint = Vector2.new(0.4),
	}, {
		["Image"] = React.createElement("ImageLabel", {
			Image = "rbxassetid://108538911498270",
			ImageColor3 = Colors.Main.Gold,
			BackgroundTransparency = 1,
			ImageTransparency = React.joinBindings({
				transparency = animations.transparency,
				global = Transparency :: React.Binding<number>,
			}):map(function(a: { transparency: number, global: number })
				return 1 - ((1 - a.global) * (1 - a.transparency))
			end),
			Rotation = animations.move:map(function(a0: number)
				return a0 * randrot
			end),
			Position = animations.move:map(function(a0: number)
				return UDim2.new(0, 0 + a0 ^ 2 * rand.X, props.position, 0 + a0 ^ 2 * rand.Y)
			end),
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0, 0.8),
		}),

		["GlowImage"] = React.createElement("ImageLabel", {
			Image = "rbxassetid://108538911498270",
			ImageColor3 = Colors.Main.ButtonPrimary,
			ZIndex = 2,
			BackgroundTransparency = 1,
			ImageTransparency = animations.glow:map(function(a0: number)
				return 1 - (1 - a0) * 0.75
			end),
			Rotation = animations.move:map(function(a0: number)
				return a0 * randrot
			end),
			Position = animations.move:map(function(a0: number)
				return UDim2.new(0, 0 + a0 ^ 2 * rand.X, props.position, 0 + a0 ^ 2 * rand.Y)
			end),
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0, 0.8),
		}),
	})
end

return Note
