ESX = nil
--luci

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('m3:duty:server:dutyOn')
AddEventHandler('m3:duty:server:dutyOn', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == 'offpolice' then
        xPlayer.setJob('police', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Mesaiye girdin!'})
        TriggerEvent('m3:dispatch:client:onDuty', src)
        dclog(xPlayer, 'adlı polis ** mesaiye girdi.' )
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Mesaiye girdin!'})
        dclog(xPlayer, 'adlı doktor ** mesaiye girdi.' )
    elseif job == 'offsheriff' then
        xPlayer.setJob('sheriff', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Mesaiye girdin!'})
        TriggerEvent('m3:dispatch:client:onDuty', src)
        dclog(xPlayer, 'adlı şerif ** mesaiye girdi.' )
    end
end)

RegisterServerEvent('m3:duty:server:dutyOff')
AddEventHandler('m3:duty:server:dutyOff', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == 'offpolice' or job == 'offambulance' or job == 'offsheriff' then 
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'Zaten mesaide değilsin!'})
        return
    end

    if job == 'police' or job == 'ambulance' or job == 'sheriff' then
        xPlayer.setJob('off'..job, grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Mesaiden çıktın!'})
        dclog(xPlayer, 'adlı devlet memuru ** mesaiden çıktı.' )
    end
end)

--AddEventHandler('esx:playerLoaded', function(source)
--	local src = source
--   local xPlayer = ESX.GetPlayerFromId(src)
--    local job = xPlayer.job.name
--    local grade = xPlayer.job.grade

--    if job == 'police' or job == 'ambulance' or job == 'sheriff' then
--        xPlayer.setJob('off'..job, grade)
--    end
--end)


function dclog(xPlayer, text)
	local playerName = Sanitize(xPlayer.getName())
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = Config.WebhookName,
	  ["avatar_url"] = Config.WebhookAvatarUrl,
	  ["embeds"] = {{
		["author"] = {
		  ["name"] = playerName .. ' - ' .. xPlayer.identifier
		},
		["color"] = 1942002,
		["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
	  }}
	}
	data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end