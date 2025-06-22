--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local Signal = require(ReplicatedStorage.Packages.signal)
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages:WaitForChild("React"))

local InterfaceTypes = require("../Common/Types/Interface")
local DEBUG = not RunService:IsRunning()

type InterfaceManager = {
	_root: ReactRoblox.RootType,
	_rootFolder: Folder,
	_display: { [string]: React.ReactElement<any, any> | React.Element<any> },
	_closeFunctions: { [string]: () -> () },
	_preserveState: { [string]: React.Element<any> },
	_uiUnique: number,

	_xscale: number,
	_yscale: number,
	_scaleHook: Signal.Signal<number, number>,
	_viewportConnection: RBXScriptConnection,

	_updateScale: (self: InterfaceManager, viewportSize: Vector2) -> (),
	_render: (self: InterfaceManager) -> (),

	init: (self: InterfaceManager) -> (),
	defaultInterface: (props: InterfaceTypes.InterfaceContext & { children: any }) -> React.ReactElement<any, any>,
	displayInterface: <T>(self: InterfaceManager, interface: InterfaceTypes.Interface<T>, options: T?) -> string,
	hideInterface: (self: InterfaceManager, interfaceId: string) -> (),
	closeInterface: (self: InterfaceManager, interfaceId: string) -> (),
	setCloseFunction: (self: InterfaceManager, interfaceId: string, f: () -> ()) -> (),

	ViewportScale: (scaleType: ("x" | "y")?) -> React.ReactElement<any, any>,
	ViewportScaleBinding: (scaleType: ("x" | "y")?) -> React.Binding<number>,
}

local InterfaceManager = {
	_uiUnique = 0,
	_display = {},
	_closeFunctions = {},
	_preserveState = {},
	_scaleHook = Signal.new(),
	_xscale = 1,
	_yscale = 1,
} :: InterfaceManager

function InterfaceManager.init(self: InterfaceManager): ()
	local rootFolderParent = if DEBUG then Instance.new("Folder", game.CoreGui) else game.Players.LocalPlayer.PlayerGui
	self._rootFolder = Instance.new("Folder", rootFolderParent)
	self._rootFolder.Name = "root"
	self._root = ReactRoblox.createRoot(rootFolderParent)

	local cam = workspace.CurrentCamera or workspace.Camera

	self._viewportConnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function(...: any)
		self:_updateScale(cam.ViewportSize)
	end)

	self:_updateScale(cam.ViewportSize)
end

function InterfaceManager._updateScale(self: InterfaceManager, viewportSize): ()
	if not viewportSize then
		warn("Something weird happened")
	end

	if viewportSize.X == 1 or viewportSize.Y == 1 then
		return
	end

	self._xscale = viewportSize.X / 1920
	self._yscale = viewportSize.Y / 1080

	self._scaleHook:Fire(self._xscale, self._yscale)
end

function InterfaceManager._render(self: InterfaceManager): ()
	assert(self._root, "Root must exist")

	self._root:render(table.clone(self._display) :: { [string]: React.Element<any> })
end

function InterfaceManager.displayInterface<T>(
	self: InterfaceManager,
	interface: InterfaceTypes.Interface<T>,
	options: T?
): string
	InterfaceManager._uiUnique += 1
	local uniqueName = `{interface.context.name}_{InterfaceManager._uiUnique}`
	local props = interface.context :: InterfaceTypes.InterfaceContext & { children: any? }
	local interfaceProps = (if options == nil then {} else options) :: T & { interfaceId: string }
	interfaceProps.interfaceId = uniqueName

	self._display[uniqueName] = React.createElement(self.defaultInterface, props, {
		React.createElement(interface.func, interfaceProps),
	})
	self:_render()
	return uniqueName
end

function InterfaceManager.setCloseFunction(self: InterfaceManager, interfaceId: string, f: () -> ())
	if not interfaceId and DEBUG then
		return
	end
	assert(interfaceId, "Interface ID must be provided")

	self._closeFunctions[interfaceId] = f
end

function InterfaceManager.hideInterface(self: InterfaceManager, interfaceId: string) end

function InterfaceManager.closeInterface(self: InterfaceManager, interfaceId: string)
	if self._closeFunctions[interfaceId] then
		self._closeFunctions[interfaceId]()
	end
	self._display[interfaceId] = nil
	self._closeFunctions[interfaceId] = nil
	self:_render()
end

function InterfaceManager.ViewportScale(type: ("x" | "y")?)
	local s = InterfaceManager.ViewportScaleBinding(type)
	return React.createElement("UIScale", {
		Scale = s,
	})
end

function InterfaceManager.ViewportScaleBinding(type: ("x" | "y")?)
	local s, setScale = React.useBinding(InterfaceManager._xscale)

	React.useEffect(function()
		local event = InterfaceManager._scaleHook:Connect(function(xscale: number, yscale)
			setScale(if type == "x" then xscale elseif type == "y" then yscale else math.min(xscale, yscale))
		end)

		return function()
			event:Disconnect()
		end
	end, {})
	return s
end

function InterfaceManager.defaultInterface(
	props: InterfaceTypes.InterfaceContext & { children: { [string]: React.ReactElement<any, any> } }
)
	local wrapperProps = {}
	if props.zindex ~= nil then
		wrapperProps.DisplayOrder = props.zindex
	end
	if props.ignoreInset ~= nil then
		wrapperProps.IgnoreGuiInset = props.ignoreInset
	end
	wrapperProps.ResetOnSpawn = false
	wrapperProps.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	if not props.disableScale then
		props.children["_UISCALE"] = InterfaceManager.ViewportScale()
	end

	return React.createElement("ScreenGui", wrapperProps, props.children :: any)
end

return InterfaceManager
