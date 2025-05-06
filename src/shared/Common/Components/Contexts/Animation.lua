--!native
--!strict
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local React = require(Packages:WaitForChild("React"))

return React.createContext({} :: React.Binding<number>)
