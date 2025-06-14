--!native
--!strict

local Fonts = {}

Fonts.Default = Font.fromId(12187364147, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

Fonts.Regular = Fonts.Default
Fonts.Regular.Weight = Enum.FontWeight.SemiBold

Fonts.Bold = Fonts.Default
Fonts.Bold.Weight = Enum.FontWeight.SemiBold

export type AvailableWeights = "Bold" | "Regular"

return Fonts
