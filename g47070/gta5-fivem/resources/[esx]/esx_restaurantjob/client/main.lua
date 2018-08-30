local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}
local isFed = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local IsBusy					= false
ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx_restaurantjob:feed')
AddEventHandler('esx_restaurantjob:feed', function(_type)

local playerPed = GetPlayerPed(-1)
--local maxFood = GetEntityMaxhunger(playerPed)>
SetEntityHunger(playerPed,0)
ESX.ShowNotification(_U('Fed'))

end)

function OpenMobileRestaurantActionsMenu(){

	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default',GetCurrentResourceName(),'mobile_restaurant_actions',{
	
		title = 'Restaurant',
		align = 'top-left',
		elements = {
			{label = _U('restuarant_menu'), value='citizen_interaction'},
			
		}
	
	},function(data,menu)
		if data.current.value == 'citizen_interaction' then
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title = _U('restaurant_menu_title'),
			align = 'top-left',
			elements = {
				{label = _U('restaurant_menu_feed') value = 'feed'}
			
			}
		},function(data,menu)
			if IsBusy then return end 
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			local hunger = GetEntityHunger( closestPlayerPed )
			if hunger > 0 then
			local playerPed = GetPlayerPed(-1)
			isBusy = true
			ESX.ShowNotification(_U('Feeding Player'))
			TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_WAITER_FEED_CUSTOMER', 0, true)
			Citizen.Wait(10000)
			ClearPedTasks(playerPed)
			TriggerServerEvent('esx_restaurantjob:feed',GetPlayerServerId(closestPlayer) )
	end)
}