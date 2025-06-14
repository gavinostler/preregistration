--!native
--!strict
local RunService = game:GetService("RunService")

local RateLimiter = {
	Limits = {},
} :: {
	Limits: { [string]: number },
	limit: <Q, Z, R, D..., T...>(
		f: (self: Z, res: R, rej: (D...) -> (), user: Player, T...) -> ...Q,
		requestsPerMinute: number
	) -> (self: Z, res: R, rej: (D...) -> (), user: Player, T...) -> ...Q,
	start: () -> (),
}

function RateLimiter.limit<Q, Z, R, D..., T...>(
	f: (self: Z, res: R, rej: (D...) -> (), user: Player, T...) -> ...Q,
	requestsPerMinute: number
): (self: Z, res: R, rej: (D...) -> (), user: Player, T...) -> ...Q
	return function(self: Z, res: R, rej: (...any) -> (), user: Player, ...)
		local key = tostring(user.UserId) .. "." .. tostring(f)
		if RateLimiter.Limits[key] == nil then
			RateLimiter.Limits[key] = 0
		end

		if RateLimiter.Limits[key] > requestsPerMinute then
			return rej("RATE_LIMITED")
		end

		RateLimiter.Limits[key] += 1

		return f(self, res, rej, user, ...)
	end
end

function RateLimiter.start()
	local t = 0
	RunService.Heartbeat:Connect(function(a0: number)
		t += a0
		if t > 60 then
			t = 0
			RateLimiter.Limits = {}
		end
	end)
end

return RateLimiter
