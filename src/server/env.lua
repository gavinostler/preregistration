--!native
--!strict

local RunService = game:GetService("RunService")
local env = {}

env.USE_LOCAL_API = RunService:IsStudio() and true -- Use local API in Studio, otherwise use production API

-- past keys in the history no longer work, dont worry
env.CELESBIT_API_KEY = if env.USE_LOCAL_API then "noapikey" else "noapikey"
env.CELESBIT_HOST = if env.USE_LOCAL_API then "http://celesbit.local" else "https://celesbit.dev"

return env
