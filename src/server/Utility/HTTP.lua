--!native
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local promise = require(ReplicatedStorage.CoreLibs.Promise)
local env = require("../env")

local ApiTypes = require(ReplicatedStorage.Shared.Common.Types.API.General)

local m = {}

function m.makeRequest<T>(
	endpoint: string,
	options: {
		method: "GET" | "POST" | "DELETE",
		body: { [any]: any }?,
	}
)
	if string.sub(endpoint, 1, 1) ~= "/" then
		endpoint = `/{endpoint}`
	end

	return promise.new(function(resolve: (T) -> (), reject: (ApiTypes.APIResponse) -> ())
		local pcallsuccess, responseData = pcall(function()
			return http:RequestAsync({
				Url = env.CELESBIT_HOST .. "/api" .. endpoint,
				Method = options.method,
				Headers = {
					["Content-Type"] = "application/json",
					["Accept"] = "application/json",
					["Authorization"] = "ApiKey " .. env.CELESBIT_API_KEY,
				},
				Body = if options.method ~= "GET" and options.body then http:JSONEncode(options.body) else nil,
				Compress = Enum.HttpCompression.None,
			})
		end)

		if not pcallsuccess then
			return reject({
				statusCode = 0,
				type = "HTTP_FAIL",
			})
		end

		if responseData.Headers["content-type"] ~= "application/json" then
			return reject({
				statusCode = 0,
				type = "INVALID_JSON",
				rawBody = responseData.Body,
			})
		end

		local ok, dataOrErr: T | { [string]: any } = pcall(function()
			return http:JSONDecode(responseData.Body :: string)
		end)
		if not responseData.Success then
			if not dataOrErr or not ok then
				warn("[URGENT] makeRequest failed to decode response body: ", responseData.Body)
				return reject({
					statusCode = responseData.StatusCode,
					type = "UNKNOWN_ERROR",
				})
			end

			return reject(dataOrErr :: ApiTypes.APIResponse)
		end

		return resolve(dataOrErr :: T)
	end)
end

function m.makeRequestOld<T>(
	endpoint: string,
	options: {
		method: "GET" | "POST" | "DELETE",
		body: { [any]: any }?,
	}
)
	warn("makeRequestOld is deprecated, use makeRequest instead")
	if string.sub(endpoint, 1, 1) ~= "/" then
		endpoint = `/{endpoint}`
	end

	return promise.new(function(
		resolve,
		reject: (
			{
				code: number,
				status: string,
				message: { [string]: any }?,
				rawBody: string?,
			}
		) -> ()
	)
		local pcallsuccess, responseData = pcall(function()
			return http:RequestAsync({
				Url = env.CELESBIT_HOST .. "/api" .. endpoint,
				Method = options.method,
				Headers = {
					["Content-Type"] = "application/json",
					["Accept"] = "application/json",
					["Authorization"] = "ApiKey " .. env.CELESBIT_API_KEY,
				},
				Body = if options.method ~= "GET" and options.body then http:JSONEncode(options.body) else nil,
				Compress = Enum.HttpCompression.None,
			})
		end)

		if not pcallsuccess then
			return reject({
				code = 0,
				status = "HTTP_FAIL",
			})
		end

		if responseData.Headers["content-type"] ~= "application/json" then
			return reject({
				code = 0,
				status = "INVALID_JSON",
				rawBody = responseData.Body,
			})
		end

		local ok, dataOrErr: T | { [string]: any } = pcall(function()
			return http:JSONDecode(responseData.Body :: string)
		end)
		if not responseData.Success then
			return reject({
				code = responseData.StatusCode,
				status = (if ok
						and dataOrErr ~= nil
						and dataOrErr ~= ""
					then (dataOrErr :: { [string]: any })["error"]
					else "UNKNOWN_ERROR"),
				message = (
						if ok and dataOrErr ~= nil and dataOrErr ~= "" then dataOrErr else nil
					) :: { [string]: any }?,
				rawBody = responseData.Body,
			})
		end

		return resolve(dataOrErr :: T)
	end)
end

return m
