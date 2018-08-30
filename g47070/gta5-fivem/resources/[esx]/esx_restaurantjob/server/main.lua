ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterServerEvent('esx_restaurantjob:feed')
AddEventHandler('esx_restaurantjob:feed', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(500)
	TriggerClientEvent('esx_restaurantjob:feed', target)
end)