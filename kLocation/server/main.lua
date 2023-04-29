ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('kLocation:CheckLiquide', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() < price then 
		cb(false)
	else 
		xPlayer.removeMoney(price)
		cb(true)
	end
end)

ESX.RegisterServerCallback('kLocation:CheckBank', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('bank').money < price then 
		cb(false)
	else 
		xPlayer.removeAccountMoney('bank', price)
		cb(true)
	end
	
end)

RegisterServerEvent('kLocation:RetourLocation')
AddEventHandler('kLocation:RetourLocation', function(price)

    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(price)
    TriggerClientEvent("esx:showNotification", source, "Vous venez d'être rembourser de ~g~"..ESX.Math.GroupDigits(price).."$ !") 

end)

ESX.RegisterServerCallback('kLocation:PerteLocation', function(source, cb, price)

    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		TriggerClientEvent("esx:showNotification", source, "Vous venez de payer une caution de ~g~"..ESX.Math.GroupDigits(price).."$ !") 
		cb(true)

	elseif xPlayer.getMoney() <= price and xPlayer.getAccount('bank').money >= price then
		xPlayer.removeAccountMoney('bank', price)
		TriggerClientEvent("esx:showNotification", source, "Vous venez de payer une caution de ~g~"..ESX.Math.GroupDigits(price).."$ !") 
		cb(true)
	else 
		cb(false)
	end
end)

