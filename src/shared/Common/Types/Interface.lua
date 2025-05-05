--!native
--!strict

export type InterfaceContext = {
	name: string,
	zindex: number?,
	ignoreInset: boolean?,
}

export type Interface<T> = {
	func: (props: T) -> any,
	context: InterfaceContext,
}

export type InterfaceProps = { interfaceId: string }

return {}
