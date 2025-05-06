--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local Promise = require(ReplicatedStorage.CoreLibs.Promise)
local React = require(Packages:WaitForChild("React"))
local ReactFlow = require(Packages:WaitForChild("ReactFlow"))

local InterfaceTypes = require("../../Common/Types/Interface")
local Colors = require("../../Common/Utility/Colors")
local TransparencyContext = require("../../Common/Components/Contexts/Transparency")
local Text = require("../../Common/Components/Basic/Text")
local Button = require("../../Common/Components/Button")
local InterfaceManager = require("../../Controllers/InterfaceManager")
local Modal = require("../Modal")
local NumberUtil = require("../../Utility/Numbers")

local Quark = require(game.ReplicatedStorage.CoreLibs.Quark)

local Service = Quark.GetService("Register")

type PossibleProps = {
	Text: string,
	ButtonText: string,
}

local TestInterface = function(props: PossibleProps & InterfaceTypes.InterfaceProps)
	local delayed, setDelayed = React.useState(false)

	local animations, playAnimation = ReactFlow.useGroupAnimation({
		show = ReactFlow.useSequenceAnimation({
			{
				timestamp = 0,
				transparency = ReactFlow.Tween({
					start = 1,
					target = 0,
					info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				}),
			},
		}),
		disable = ReactFlow.useAnimation({}),
	}, {
		glow = 1,
		transparency = 1,
		move = 1,
	})

	React.useEffect(function()
		playAnimation("show")
		task.delay(3, function()
			setDelayed(true)
		end)
	end, {})

	local userCount = React.useMemo(function()
		if delayed == false then
			return 0
		end
		local success: boolean, value: Quark.ServerResponse<number> = Service:getUserCount():await()
		if not success or not value.success then
			InterfaceManager:displayInterface(Modal, {
				Text = "We may be having some trouble with our servers, check back later!\nSTATUS CODE: " .. value.data,
			})
			return 0
		end
		return value.data :: number
	end, { delayed })

	local preregister = function()
		local id = InterfaceManager:displayInterface(Modal, {
			Text = "Working...",
		})
		local p = Service:preregister() :: Promise.TypedPromise<Quark.ServerResponse<string>>
		p:andThen(function (response)
			InterfaceManager:closeInterface(id)
			if not response.success then
				if response.data ~= "ROBLOX_ALREADY_REGISTERED" then
					return InterfaceManager:displayInterface(Modal, {
						Text = "We may be having some trouble with our servers, check back later!\nSTATUS CODE: " .. if response.data then response.data else "UNKNOWN_ERROR_REPORT",
						Buttons={
							{
								Text="Ok"
							}
						}
					})
				else
					return InterfaceManager:displayInterface(Modal, {
						Text = "You seem to have already registered for Poly Defense.",
						Buttons={
							{
								Text="Ok"
							}
						}
					})
				end
			end
			InterfaceManager:displayInterface(Modal, {
				Text = "You have successfully pre-registered for Poly Defense!",
				Buttons={
					{
						Text="Ok"
					}
				}
			})
		end, function (errorCode: string)
			InterfaceManager:displayInterface(Modal, {
				Text = "We may be having some trouble with our servers, check back later!\nSTATUS CODE: " .. errorCode,
			})
		end)

	end

	return React.createElement(TransparencyContext.Provider, { value = animations.transparency }, {

		["UI"] = React.createElement("Frame", {
			BackgroundTransparency = 0,
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
					Image = "rbxassetid://110840735106075",
					ScaleType = Enum.ScaleType.Crop,
					ImageTransparency = 0.5,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
				}, {

					["Text"] = React.createElement(Text, {
						Text = "Ready to compose some adventures together?",
						Wraps = true,
						Size = UDim2.new(0, 0),
						Position = UDim2.new(0, 0, 1, -50),
						AutomaticSize = Enum.AutomaticSize.XY,
						LayoutOrder = 1,
						TextSize = 48,
					}),

					["Button"] = React.createElement(Button, {
						LayoutOrder = 2,
						AnchorPoint = Vector2.new(0, 0),
						Size = UDim2.new(0, 280, 0, 50),
						Text = {
							Content = "Pre-Register",
							Size = 27,
						},

						onClick=preregister
					}),

					["Join"] = React.createElement(Text, {
						Text = `to join <font size="30" color="#{Colors.Main.Gold:ToHex()}">{NumberUtil.comma_value(
							userCount
						)}</font> other Roblox users!`,
						Wraps = true,
						Size = UDim2.new(0, 0),
						Position = UDim2.new(0, 0, 1, -50),
						AutomaticSize = Enum.AutomaticSize.XY,
						LayoutOrder = 3,
						TextSize = 24,
					}),

					["UIListLayout"] = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
				}),

				["PD"] = React.createElement("ImageLabel", {
					Image = "rbxassetid://101506952924779",
					BackgroundColor3 = Color3.new(1, 1, 1),
					ScaleType = Enum.ScaleType.Fit,
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(0, 220, 0, 40),
					AnchorPoint = Vector2.new(0,1),
					Position = UDim2.new(0, 10, 1, -10),
					ZIndex = 3,
				}),
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
