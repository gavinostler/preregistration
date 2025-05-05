--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages:WaitForChild("React"))

local InterfaceTypes = require("../Common/Types/Interface")

type InterfaceManager = {
	_root: ReactRoblox.RootType,
	_rootFolder: Folder,
	_display: { [string]: React.ReactElement<any, any> | React.Element<any> },
	_preserveState: { [string]: React.Element<any> },
	_uiUnique: number,

	_render: (self: InterfaceManager) -> (),

	init: (self: InterfaceManager) -> (),
	defaultInterface: (props: InterfaceTypes.InterfaceContext & { children: any? }) -> React.ReactElement<any, any>,
	displayInterface: <T>(self: InterfaceManager, interface: InterfaceTypes.Interface<T>, options: T?) -> string,
	hideInterface: (self: InterfaceManager, interfaceId: string) -> (),
	closeInterface: (self: InterfaceManager, interfaceId: string) -> (),
}

local InterfaceManager = {
	_uiUnique = 0,
	_display = {},
	_preserveState = {},
} :: InterfaceManager

function InterfaceManager.init(self: InterfaceManager): ()
	self._rootFolder = Instance.new("Folder", game.Players.LocalPlayer.PlayerGui)
	self._rootFolder.Name = "root"
	self._root = ReactRoblox.createRoot(game.Players.LocalPlayer.PlayerGui)
end

function InterfaceManager._render(self: InterfaceManager): ()
	assert(self._root, "Root must exist")

	self._root:render(self._display :: { [string]: React.Element<any> })
end

function InterfaceManager.displayInterface<T>(
	self: InterfaceManager,
	interface: InterfaceTypes.Interface<T>,
	options: T?
): string
	InterfaceManager._uiUnique += 1
	local uniqueName = `{interface.context.name}_{InterfaceManager._uiUnique}`
	local props = interface.context :: InterfaceTypes.InterfaceContext & { children: any? }

	self._display[uniqueName] = React.createElement(self.defaultInterface, props, {
		React.createElement(interface.func, { interfaceId = uniqueName } :: T & { interfaceId: string }),
	})
	self:_render()
	return uniqueName
end

function InterfaceManager.hideInterface(self: InterfaceManager, interfaceId: string) end

function InterfaceManager.defaultInterface(
	props: InterfaceTypes.InterfaceContext & { children: { React.Element<any> }? }
)
	local wrapperProps = {}
	if props.zindex ~= nil then
		wrapperProps.DisplayOrder = props.zindex
	end
	if props.ignoreInset ~= nil then
		wrapperProps.IgnoreGuiInset = props.ignoreInset
	end
	wrapperProps.ResetOnSpawn = false

	return React.createElement("ScreenGui", wrapperProps, props.children)
end

return InterfaceManager
