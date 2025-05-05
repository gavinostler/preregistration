--!native
--!strict

type CacheItem<T> = {
	value: T,
	__timeout: number,
}

type CacheMode = "TTL" | "SE"

local NovusCache = {} :: NovusCacheImpl<any>
NovusCache.__index = NovusCache

local NovusS = { __caches = {} :: { [string]: NovusCache<any> } } :: {
	__caches: { [string]: NovusCache<any> },
	createCache: <T>(
		name: string,
		options: { cleanupInterval: number?, timeout: number?, cacheMode: CacheMode? }?
	) -> NovusCache<T>,
	getCache: <T>(name: string) -> NovusCache<T>?,
	__cleanupLoop: (name: string) -> (),
}

-- Creates a cache #### NEEDS DOCS ####
function NovusS.createCache<T>(
	name: string,
	options: { cleanupInterval: number?, timeout: number?, cacheMode: CacheMode? }?
): NovusCache<T>
	if not options then
		options = {} :: { cleanupInterval: number?, timeout: number?, cacheMode: CacheMode? }
	end
	assert(options)

	local newCache = setmetatable(
		{
			__cache = {} :: { [string]: CacheItem<T> },
			__timeout = options.timeout or 900, -- 15 minutes
			__cleanupInterval = options.cleanupInterval or 30,
			__cacheMode = options.cacheMode or "SE",
			__cleanupThread = nil, -- will be set after
			set = NovusCache.set,
			get = NovusCache.get,
			delete = NovusCache.delete,
			deletePartialKey = NovusCache.deletePartialKey,
			bget = NovusCache.bget,
		} :: NovusCacheImpl<T>,
		NovusCache :: NovusCacheImpl<T>
	) :: any

	newCache.__cleanupThread = task.spawn(NovusS.__cleanupLoop, name)
	NovusS.__caches[name] = newCache :: NovusCache<T>

	return NovusS.__caches[name]
end

function NovusS.__cleanupLoop(name: string)
	local cache = NovusS.getCache(name)

	if not cache then
		return
	end

	while task.wait(cache.__cleanupInterval) do
		local currentTime = os.time()
		for key, item in cache.__cache do
			if currentTime > item.__timeout then
				cache:delete(key)
			end
		end
	end
end

function NovusS.getCache<T>(name: string): NovusCache<T>?
	return NovusS.__caches[name] :: NovusCache<T>?
end

-- Cache
function NovusCache.delete<T>(self: NovusCache<T>, key: any): nil
	assert(self, "You must call .createCache with the name of your cache to use delete.")
	assert(key, "Failed to supply a key.")

	self.__cache[key] = nil

	return nil
end

function NovusCache.deletePartialKey<T>(self: NovusCache<T>, keyPartial: string): nil
	assert(self, "You must call .createCache with the name of your cache to use delete.")
	assert(keyPartial, "Failed to supply a key.")

	local marked = {}

	for key, _ in self.__cache do
		if key:sub(1, keyPartial:len()) :: string == keyPartial then
			table.insert(marked, key)
		end
	end

	for _, key in marked do
		self:delete(key)
	end

	return nil
end

--[[
Sets data in the cache.
	Options:
		notExists - Will only set if the value does not already exist. Will return nil if the value already exists.
		expiry - Expires in x seconds, overwriting the setting value.
]]
function NovusCache.set<T>(
	self: NovusCache<T>,
	key: any,
	value: T,
	options: {
		notExists: boolean?,
		expiry: number?,
	}?
): boolean?
	assert(self, "You must call .createCache with the name of your cache to use set.")
	assert(key, "Failed to supply a key.")
	assert(value, "Failed to supply a value.")
	local options_repl: {
		notExists: boolean?,
		expiry: number?,
	} = if options == nil then {} else options

	if options_repl.notExists == true and self.__cache[key] ~= nil then
		return nil
	end

	local timeout = (if options_repl.expiry ~= nil then options_repl.expiry :: number else self.__timeout)

	self.__cache[key] = {
		value = value,
		__timeout = os.time() + timeout,
	}

	return true
end

function NovusCache.get<T>(self: NovusCache<T>, key: any): T?
	assert(self, "You must call .createCache with the name of your cache to use get.")
	assert(key, "Failed to supply a key.")

	if not self.__cache[key] then
		return nil
	end

	if self.__cacheMode == "SE" then
		self.__cache[key].__timeout += self.__timeout
	end

	return self.__cache[key].value
end

function NovusCache.bget<T>(self: NovusCache<T>, keys: { any }): { T? }
	assert(self, "You must call .createCache with the name of your cache to use get.")
	assert(keys, "Failed to supply keys.")

	local list = {}

	for _, key in keys do
		table.insert(list, self:get(key))
	end

	return list
end

export type NovusS = typeof(NovusS)

export type NovusCacheImpl<T> = {

	__index: any,

	__cache: { [string]: CacheItem<T> },
	__cleanupInterval: number,
	__timeout: number,
	__cacheMode: CacheMode,
	__cleanupThread: thread?,

	--[[
	Sets data in the cache.
		Options:
			notExists - Will only set if the value does not already exist. Will return nil if the value already exists.
			expiry - Expires in x seconds, overwriting the setting value.
	]]
	set: (
		self: NovusCache<T>,
		key: any,
		value: T,
		options: {
			notExists: boolean,
			expiry: number,
		}?
	) -> boolean?,
	get: (self: NovusCache<T>, key: any) -> T?,
	bget: (self: NovusCache<T>, keys: { any }) -> { T? },
	delete: (self: NovusCache<T>, key: any) -> nil,
	deletePartialKey: (self: NovusCache<T>, key: any) -> nil,
}

export type NovusCache<T> = typeof(setmetatable({} :: NovusCacheImpl<T>, {} :: NovusCacheImpl<T>))

return NovusS
