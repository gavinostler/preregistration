--!native
--!strict

local RunService = game:GetService("RunService")
local env = {}

env.USE_LOCAL_API = RunService:IsStudio() and false -- Use local API in Studio, otherwise use production API

env.CELESBIT_API_KEY = if env.USE_LOCAL_API
	then "2a9c0e2935854011b10015ae61c7be67.2cdffc0ea0e24895b4a284c4f13878b3"
	else "247e283bd6ae49d2bedb6246ed0919b1.0a5da3daf5b447e89bd1f1281ffd53e9"
env.CELESBIT_HOST = if env.USE_LOCAL_API then "http://celesbit.local" else "https://celesbit.dev"

return env
