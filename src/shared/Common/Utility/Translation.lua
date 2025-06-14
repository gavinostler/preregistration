--!native
--!strict

local Translation = {}
local LocalizationService = game:GetService("LocalizationService")

local REGEX = "()(%b{})"
local TranslationFolder = game.ReplicatedStorage.Shared.Common.Translation

function Translation.loadTranslationMap()
	local locale = LocalizationService.SystemLocaleId:split("-")[1]
	local translationFile = TranslationFolder:FindFirstChild(locale)
	if not translationFile then
		-- Fallback to English if the locale file is not found
		warn("No translation file found for locale: " .. tostring(locale))
		translationFile = TranslationFolder:FindFirstChild("en")
	end

	Translation.map = require(translationFile) :: { [string]: string }
end

function Translation.t(key: string, ...): string
	if not Translation.map then
		Translation.loadTranslationMap()
	end

	if not Translation.map[key] then
		return key
	end

	local args: { string } = { ... }

	local result = Translation.map[key]:gsub(
		REGEX,
		function(pos: string, tag: string)
			local numpos = tonumber(pos) :: number
			if numpos == 1 or key:sub(numpos + 1, numpos + 1) ~= "{" then
				return table.remove(args, 1) :: string
			end

			return tag
		end :: (string) -> string -- way to get rid of type error lol
	)
	if #args > 0 then
		warn("Not all arguments were used in translation for key: " .. key)
	end
	return result
end

return Translation
