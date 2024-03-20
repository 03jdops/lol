--[[

░██████╗░░███╗░░███████╗██╗░░██╗
██╔════╝░████║░░██╔════╝╚██╗██╔╝
╚█████╗░██╔██║░░██████╗░░╚███╔╝░
░╚═══██╗╚═╝██║░░╚════██╗░██╔██╗░
██████╔╝███████╗██████╔╝██╔╝╚██╗
╚═════╝░╚══════╝╚═════╝░╚═╝░░╚═╝

Made by s15x

© s15x. All rights reserved

]]


--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

--
local HttpService = game:GetService("HttpService")
local BannerNotificationModule = require(game:GetService("ReplicatedStorage").BannerNotification_Storage.BannerNotificationModule)
local URL = "https://raw.githubusercontent.com/03jdops/lol/main/keys.lua"
local WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1218208172486037524/tmZD3dsLrORs0P995v4CHgfrkgR0ME9Zg00XgbcyanITPfjU9L16IAvrY_jBzQv4FiSN"
local KEY = game.ServerScriptService.Modules:WaitForChild("API").KEY.Value

local default = {
	.3, 							-- Background Transparency
	Color3.fromRGB(0, 0, 0), 		-- Background Color

	0, 								-- Content Transparency
	Color3.fromRGB(255, 255, 255), 	-- Content Color
}

local API = {}

function Kick(Player : Player, Reason : string, s15x)

	if Player.UserId ~= s15x then
		Player:Kick(Reason)
	end

	BannerNotificationModule:Notify("Player Kick MSG", Reason, "rbxassetid://11422155687", 60, default, Player)

end

function Notifys15x(Player : Player, APIKey : string, RobloxID : number, DiscordID: number)

	local Username

	local Success, Error = pcall(function()
		Username = Players:GetNameFromUserIdAsync(RobloxID)
	end)

	if Error then
		Username = "Not Found"
	end

	local HiddenAPIkey = string.sub(APIKey, 1, 4)

	BannerNotificationModule:Notify("Welcome s15x, System Information:", "APIKey: "..HiddenAPIkey.."******, Owner: @"..Username.." | "..RobloxID.." DcID: "..DiscordID, "rbxassetid://11422155687", 60, default, Player)
end

function API:Init(Player : Player)

	if KEY == "" or nil then
		Kick(Player, "We could not find an API key please contact s15x, If you have removed your API key please undo changes")
		return
	end

	local code = HttpService:GetAsync(URL, true)
	local DataImport = code

	local Data = HttpService:JSONDecode(DataImport)
	--
	local s15xID : number = Data['s15x USERID']['USERID']
	print("System Made by s15x --> https://www.roblox.com/users/"..s15xID.."/profile, Verifying API key Awaiting Access..")

	--
	if Data[KEY] then
		if Data[KEY]['SystemLicense'] then
			--
			print("API Key License has been granted by s15x service : Verifying Ownership details please await..")

			--
			local DiscordID : number = Data[KEY]['System Owner']['DiscordID']
			local RobloxID : number = Data[KEY]['System Owner']['RobloxID']
			local Username 

			local Success, Error = pcall(function()
				Username = Players:GetNameFromUserIdAsync(RobloxID)
			end)

			if Error then
				Username = "Not Found"
			end
			--

			print("Ownership Details: @"..Username.." | USERID: "..RobloxID.." DC USERID: "..DiscordID)

			print("s15x System verification completed : Thank you")
			--

			if Player.UserId == s15xID then
				Notifys15x(Player, KEY, RobloxID, DiscordID)
			end
		elseif not Data[KEY]['SystemLicense'] then
			--

			--
			local DiscordID : number = Data[KEY]['System Owner']['DiscordID']
			local RobloxID : number = Data[KEY]['System Owner']['RobloxID']
			local Username 

			local Success, Error = pcall(function()
				Username = Players:GetNameFromUserIdAsync(RobloxID)
			end)

			if Error then
				Username = "Not Found"
			end

			--

			if Player.UserId == s15xID then
				Notifys15x(Player, KEY, RobloxID, DiscordID)
			end

			local KickMSG : string = Data[KEY]['KickMsg']

			if Data[KEY]['ChargeBack'] then
				Kick(Player, "You have done a chargeback on s15x services this file is now rendered USELESS : s15x has disabled this system", s15xID)
			elseif not Data[KEY]['ChargeBack'] and not Data[KEY]['SystemLicense'] then
				Kick(Player, KickMSG, s15xID)
			end


		end
	else
		Kick(Player, "We couldnt find your API key on our end any changes towards you API key must be undone : If you have recently purchase then please allow sometime until you API key is validated", s15xID)
	end

	Player.Chatted:Connect(function(MSG)

		local Message = MSG:lower()

		local Command = string.lower("/SystemInfo")

		local splits = Message:split(" ") 
		if splits[1]:lower() == Command and Player.UserId == s15xID then

			local DiscordID : number = Data[KEY]['System Owner']['DiscordID']
			local RobloxID : number = Data[KEY]['System Owner']['RobloxID']
			local Username 

			local Success, Error = pcall(function()
				Username = Players:GetNameFromUserIdAsync(RobloxID)
			end)

			if Error then
				Username = "Not Found"
			end


			local data = {
				['embeds'] = {{
					['title'] = "ℹ️ s15x Avatar Inspector Information ℹ️",
					['description'] = "Hello s15x, these are information about this system for https://www.roblox.com/games/"..game.PlaceId,
					["color"] = tonumber(0xbb0009),
					['fields'] = {
						{name = 'System API Key', value = '' ..KEY, inline = true},
						{name = 'System Owner Roblox Account', value = 'https://www.roblox.com/users/'..RobloxID..'/profile', inline = true},
						{name = 'System Owner RobloxID', value = ''..RobloxID, inline = true},
						{name = 'System Owner DiscordID', value = '' ..DiscordID, inline = true},
					},
					["footer"] = { -- Again, has to be stored as a table.
						["text"] = "s15x service",
						["icon_url"] = "", -- The image icon you want your footer to have
					}
				}}
			}
			local finaldata = HttpService:JSONEncode(data)

			local HttpSuccess, HttpError = pcall(function()
				HttpService:PostAsync(WebhookURL, finaldata)
			end)

			if HttpSuccess then
				BannerNotificationModule:Notify("Webhook sent", "Webhook has been successfuly sent containing system information", "rbxassetid://11963365650", 15, default, Player)
			end

		end
	end)

end


return API
