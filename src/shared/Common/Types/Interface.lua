--!native
--!strict

export type InterfaceContext = {
	name: string,
	zindex: number?,
	ignoreInset: boolean?,
	disableScale: boolean?, -- does not reduce overhead because of annoying issue with useEffect grr
}

export type Interface<T> = {
	func: (props: T) -> any,
	context: InterfaceContext,
}

export type InterfaceProps = { interfaceId: string }

return {}
