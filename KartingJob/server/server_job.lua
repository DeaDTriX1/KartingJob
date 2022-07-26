ESX = nil
local Jobs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'Karting', 'Alerte Karting', true, true)

TriggerEvent('esx_society:registerSociety', 'Karting', 'Karting', 'society_Karting', 'society_Karting', 'society_Karting', {type = 'public'})

ESX.RegisterServerCallback('fKarting:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Karting', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('fKarting:getStockItem')
AddEventHandler('fKarting:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Karting', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showAdvancedNotification', _source, 'Coffre', '~o~Informations~s~', 'Vous avez retiré ~r~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)

ESX.RegisterServerCallback('fKarting:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('fKarting:putStockItems')
AddEventHandler('fKarting:putStockItems', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Karting', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez déposé ~g~'..inventoryItem.label.." x"..count, 'CHAR_MP_FM_CONTACT', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_MP_FM_CONTACT', 9)
		end
	end)
end)

RegisterServerEvent('fKarting:Ouvert')
AddEventHandler('fKarting:Ouvert', function()
	local name = GetPlayerName(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Karting', '~y~Informations', 'Le Karting est désormais ouvert!', 'CHAR_KARTING', 2)
	end
	sendToDiscordWithSpecialURL("Karting", "Annonce de  "..name, 'Le Karting est actuellement OUVERT !', 1942002, Config2.webhookDiscordouvert)
end)

RegisterServerEvent('fKarting:Fermer')
AddEventHandler('fKarting:Fermer', function()
	local name = GetPlayerName(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Karting', '~y~Informations', 'Le Karting est fermé!', 'CHAR_KARTING', 2)
	end
	sendToDiscordWithSpecialURL("Karting", "Annonce de  "..name, 'Le Karting est actuellement FERMER !', 1942002, Config2.webhookDiscordfermer)
end)

RegisterServerEvent('fKarting:Perso')
AddEventHandler('fKarting:Perso', function(msg)
	local name = GetPlayerName(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Karting', '~y~Annonce', msg, 'CHAR_KARTING', 8)
    end
    sendToDiscordWithSpecialURL("Karting", "Annonce de  "..name,  msg, 1942002, Config2.webhookDiscordperso)
end)


RegisterServerEvent("D-Mecano:Facture")
AddEventHandler("D-Mecano:Facture", function(name,montant)
	local name = GetPlayerName(source)
	sendToDiscordWithSpecialURL("Karting", "Facture de " ..name, montant, 1942002, Config2.webhookDiscordfacture)
end)



function sendToDiscordWithSpecialURL(name,message,des,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			['description']=des,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = name, avatar_url = "https://help.twitter.com/content/dam/help-twitter/brand/logo.png", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end