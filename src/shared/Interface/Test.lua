--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages.ReactFlow)

local InterfaceTypes = require("../Common/Types/Interface")
local Background = require("../Common/Components/Background")
local EventHook = require("../Common/Hooks/EventHook")

type PossibleProps = InterfaceTypes.InterfaceProps

local TestInterface = function(props: PossibleProps)
	local function generateNewSize()
		return UDim2.new(0, math.random(100, 700), 0, math.random(100, 700))
	end

	local oldSize, setOldSize = React.useState(generateNewSize())
	local currentSize, setNewSize = React.useState(oldSize)
	local sizeAnimation, playSizeAnimation, stopSizeAnimation = ReactFlow.useTween({
		info = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
		start = 0,
		target = 1,
	})

	EventHook(game:GetService("UserInputService").InputEnded, function(input)
		if input.KeyCode == Enum.KeyCode.V then
			local a0 = sizeAnimation:getValue()
			stopSizeAnimation()
			playSizeAnimation({ start = 0, target = 1 })
			setOldSize(
				UDim2.new(
					0,
					(currentSize.X.Offset - oldSize.X.Offset) * a0 + oldSize.X.Offset,
					0,
					(currentSize.Y.Offset - oldSize.Y.Offset) * a0 + oldSize.Y.Offset
				)
			)
			setNewSize(generateNewSize())
		end
	end)

	return React.createElement(Background, {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = sizeAnimation:map(function(a0: number)
			return UDim2.new(
				0,
				(currentSize.X.Offset - oldSize.X.Offset) * a0 + oldSize.X.Offset,
				0,
				(currentSize.Y.Offset - oldSize.Y.Offset) * a0 + oldSize.Y.Offset
			)
		end),
	})
end

local Interface = {
	context = {
		name = script.Name,
		ignoreInset = true,
		zindex = 999,
	} :: InterfaceTypes.InterfaceContext,
	func = TestInterface,
} :: InterfaceTypes.Interface<PossibleProps>

return Interface
