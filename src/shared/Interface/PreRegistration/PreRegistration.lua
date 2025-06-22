--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local Promise = require(ReplicatedStorage.CoreLibs.Promise)
local General = require(ReplicatedStorage.Shared.Common.Types.API.General)
local Preregister = require(ReplicatedStorage.Shared.Common.Types.API.Preregister)
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
local useLock = require("../../Common/Hooks/useLock")

local Quark = require(game.ReplicatedStorage.CoreLibs.Quark)
local Service = Quark.GetService("Register")

local t = require("../../Common/Utility/Translation").t

local TopBar = require("./UpperBar")
local Calendar = require("./Calendar")

type PossibleProps = {
	Text: string,
	ButtonText: string,
}

local TestInterface = function(props: PossibleProps & InterfaceTypes.InterfaceProps)
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

	local scrollPosition, playScrollPosition, _ = ReactFlow.useTween({
		info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		start = 0,
		target = 0,
	})
	local scrollRef = React.createRef()

	local sizeY = InterfaceManager.ViewportScaleBinding("y")

	local function scrollTo(percentage: number)
		-- assumption that viewport doesnt change during the animation
		if not scrollRef.current then
			return
		end

		playScrollPosition({
			start = scrollRef.current.CanvasPosition.Y / scrollRef.current.AbsoluteCanvasSize.Y,
			target = percentage,
		})
	end

	local isLocked, acquireLock, forceLock = useLock()

	React.useEffect(function()
		playAnimation("show")
	end, {})

	local userCount = React.useMemo(function()
		local success: boolean, data: Preregister.PreregisterCountResponse = Service:getUserCount():await()
		if not success or not data.count then
			local err = data :: General.APIResponse
			InterfaceManager:displayInterface(Modal, {
				Text = t("http.error", err.message or err.type),
			})
			return 0
		end
		return data.count :: number
	end, {})

	local preregister = function()
		if isLocked then
			return
		end
		forceLock(true)
		local id = InterfaceManager:displayInterface(Modal, {
			Text = t("ui.register.working"),
		})
		local p = Service:preregister() :: Promise.TypedPromise<Preregister.PreregisterResponse>
		p:andThen(function(response)
			InterfaceManager:displayInterface(Modal, {
				Text = t("ui.register.success"),
				Buttons = {
					{
						Text = t("common.ok"),
					},
				},
			})
		end, function(err: General.APIResponse)
			if err.type ~= "ROBLOX_ALREADY_REGISTERED" then
				return InterfaceManager:displayInterface(Modal, {
					Text = t("http.error", err.message or err.type),
					Buttons = {
						{
							Text = t("common.ok"),
						},
					},
				})
			end

			return InterfaceManager:displayInterface(Modal, {
				Text = t("ui.register.alreadyRegistered"),
				Buttons = {
					{
						Text = t("common.ok"),
					},
				},
			})
		end):finally(function()
			forceLock(false)
			InterfaceManager:closeInterface(id)
		end)
	end

	return React.createElement(TransparencyContext.Provider, { value = animations.transparency }, {

		["TopBar"] = React.createElement(TopBar, { scrollTo = scrollTo }),

		["UI"] = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarImageTransparency = 0.9,
			ScrollBarThickness = 10,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.fromScale(1, 1),
			CanvasPosition = React.joinBindings({ sp = scrollPosition, sy = sizeY }):map(function(joinedBinding: {
				sp: number,
				sy: number,
			})
				return Vector2.new(0, joinedBinding.sp * joinedBinding.sy * 1080 * 2)
			end),
			["ref"] = scrollRef,
		}, {
			["UpperMain"] = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = Colors.Background.Primary,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}, {
				["UI"] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 0.5),
				}, {

					["Image"] = React.createElement("ImageLabel", {
						Image = "rbxassetid://110840735106075",
						ScaleType = Enum.ScaleType.Crop,
						ImageTransparency = 0.6,
						BackgroundColor3 = Colors.Background.Primary,
						BackgroundTransparency = 0,
						Size = UDim2.new(1, 0, 1.05, 0),
					}, {
						["Graident"] = React.createElement("UIGradient", {
							Rotation = 90,
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(0.95, 0),
								NumberSequenceKeypoint.new(1, 1),
							}),
						}),

						["UI"] = React.createElement("Frame", {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							AutomaticSize = Enum.AutomaticSize.XY,
						}, {

							InterfaceManager.ViewportScale(),

							["Text"] = React.createElement(Text, {
								Text = t("ui.register.title"),
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
									Content = t("ui.register.button"),
									Size = 27,
								},

								onClick = acquireLock(preregister),
							}),

							["Join"] = React.createElement(Text, {
								Text = t(
									"ui.register.usercount",
									Colors.Main.Gold:ToHex(),
									NumberUtil.comma_value(userCount)
								),
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
					}),
				}),
				["UI2"] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 0.5),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
				}, {

					["UI"] = React.createElement(Calendar),
				}),
			}),
		}),
	})
end

local Interface = {
	context = {
		name = script.Name,
		ignoreInset = true,
		disableScale = true,
		zindex = 1,
	} :: InterfaceTypes.InterfaceContext,
	func = TestInterface,
} :: InterfaceTypes.Interface<PossibleProps>

return Interface
