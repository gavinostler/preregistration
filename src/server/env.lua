local RunService = game:GetService("RunService")
local env = {}

env.CELESBIT_API_KEY = "2a9c0e2935854011b10015ae61c7be67.2cdffc0ea0e24895b4a284c4f13878b3"
env.CELESBIT_HOST = if RunService:IsStudio() then "http://celesbit.local" else "https://celesbit.dev"

return env
