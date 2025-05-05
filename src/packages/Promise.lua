--!strict
-- Partial types for Promise

local Promise = require(game.ReplicatedStorage.Packages.Promise) :: any

export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"

export type Promise = {
	andThen: (
		self: Promise,
		successHandler: (...any) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> Promise,
	andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> any,
	andThenReturn: (self: Promise, ...any) -> Promise,

	await: (self: Promise) -> (boolean, ...any),
	awaitStatus: (self: Promise) -> (Status, ...any),

	cancel: (self: Promise) -> (),
	catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
	expect: (self: Promise) -> ...any,

	finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
	finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
	finallyReturn: (self: Promise, ...any) -> Promise,

	getStatus: (self: Promise) -> Status,
	now: (self: Promise, rejectionValue: any?) -> Promise,
	tap: (self: Promise, tapHandler: (...any) -> ...any) -> Promise,
	timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}

export type TypedPromise<T...> = {
	andThen: (
		self: TypedPromise<T...>,
		successHandler: (T...) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> TypedPromise<T...>,
	andThenCall: <TArgs...>(self: TypedPromise<T...>, callback: (TArgs...) -> ...any, TArgs...) -> TypedPromise<T...>,
	andThenReturn: (self: TypedPromise<T...>, ...any) -> TypedPromise<T...>,

	await: (self: TypedPromise<T...>) -> (boolean, T...),
	awaitStatus: (self: TypedPromise<T...>) -> (Status, T...),

	cancel: (self: TypedPromise<T...>) -> (),
	catch: (self: TypedPromise<T...>, failureHandler: (...any) -> ...any) -> TypedPromise<T...>,
	expect: (self: TypedPromise<T...>) -> T...,

	finally: (self: TypedPromise<T...>, finallyHandler: (status: Status) -> ...any) -> TypedPromise<T...>,
	finallyCall: <TArgs...>(self: TypedPromise<T...>, callback: (TArgs...) -> ...any, TArgs...) -> TypedPromise<T...>,
	finallyReturn: (self: TypedPromise<T...>, ...any) -> TypedPromise<T...>,

	getStatus: (self: TypedPromise<T...>) -> Status,
	now: (self: TypedPromise<T...>, rejectionValue: any?) -> TypedPromise<T...>,
	tap: (self: TypedPromise<T...>, tapHandler: (T...) -> ...any) -> TypedPromise<T...>,
	timeout: (self: TypedPromise<T...>, seconds: number, rejectionValue: any?) -> TypedPromise<T...>,
}

export type TypedPromiseReject<Q..., T...> = {
	andThen: (
		self: TypedPromise<T...>,
		successHandler: (T...) -> ...any,
		failureHandler: ((Q...) -> ...any)?
	) -> TypedPromise<T...>,
	andThenCall: <TArgs...>(self: TypedPromise<T...>, callback: (TArgs...) -> ...any, TArgs...) -> TypedPromise<T...>,
	andThenReturn: (self: TypedPromise<T...>, ...any) -> TypedPromise<T...>,

	await: (self: TypedPromise<T...>) -> (boolean, T...),
	awaitStatus: (self: TypedPromise<T...>) -> (Status, T...),

	cancel: (self: TypedPromise<T...>) -> (),
	catch: (self: TypedPromise<T...>, failureHandler: (Q...) -> ...any) -> TypedPromise<T...>,
	expect: (self: TypedPromise<T...>) -> T...,

	finally: (self: TypedPromise<T...>, finallyHandler: (status: Status) -> ...any) -> TypedPromise<T...>,
	finallyCall: <TArgs...>(self: TypedPromise<T...>, callback: (TArgs...) -> ...any, TArgs...) -> TypedPromise<T...>,
	finallyReturn: (self: TypedPromise<T...>, ...any) -> TypedPromise<T...>,

	getStatus: (self: TypedPromise<T...>) -> Status,
	now: (self: TypedPromise<T...>, rejectionValue: any?) -> TypedPromise<T...>,
	tap: (self: TypedPromise<T...>, tapHandler: (T...) -> ...any) -> TypedPromise<T...>,
	timeout: (self: TypedPromise<T...>, seconds: number, rejectionValue: any?) -> TypedPromise<T...>,
}

type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ...any) -> SignalConnection,
}

type SignalConnection = {
	Disconnect: (self: SignalConnection) -> ...any,
	[any]: any,
}

return Promise :: {
	Error: any,

	all: <T>(promises: { TypedPromise<T> }) -> TypedPromise<{ T }>,
	allSettled: <T>(promise: { TypedPromise<T> }) -> TypedPromise<{ Status }>,
	any: <T>(promise: { TypedPromise<T> }) -> TypedPromise<T>,
	defer: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> TypedPromise<TReturn...>,
	delay: (seconds: number) -> TypedPromise<number>,
	each: <T, TReturn>(
		list: { T | TypedPromise<T> },
		predicate: (value: T, index: number) -> TReturn | TypedPromise<TReturn>
	) -> TypedPromise<{ TReturn }>,
	fold: <T, TReturn>(
		list: { T | TypedPromise<T> },
		reducer: (accumulator: TReturn, value: T, index: number) -> TReturn | TypedPromise<TReturn>
	) -> TypedPromise<TReturn>,
	fromEvent: <TReturn...>(
		event: Signal<TReturn...>,
		predicate: ((TReturn...) -> boolean)?
	) -> TypedPromise<TReturn...>,
	is: (object: any) -> boolean,
	new: <TReturn..., EReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (EReturn...) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> TypedPromiseReject<EReturn..., TReturn...>,
	onUnhandledRejection: (callback: (promise: TypedPromise<any>, ...any) -> ()) -> () -> (),
	promisify: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn...) -> (TArgs...) -> TypedPromise<TReturn...>,
	race: <T>(promises: { TypedPromise<T> }) -> TypedPromise<T>,
	reject: (...any) -> TypedPromise<...any>,
	resolve: <TReturn...>(TReturn...) -> TypedPromise<TReturn...>,
	retry: <TArgs..., TReturn...>(
		callback: (TArgs...) -> TypedPromise<TReturn...>,
		times: number,
		TArgs...
	) -> TypedPromise<TReturn...>,
	retryWithDelay: <TArgs..., TReturn...>(
		callback: (TArgs...) -> TypedPromise<TReturn...>,
		times: number,
		seconds: number,
		TArgs...
	) -> TypedPromise<TReturn...>,
	some: <T>(promise: { TypedPromise<T> }, count: number) -> TypedPromise<{ T }>,
	try: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn..., TArgs...) -> TypedPromise<TReturn...>,
}
