-- wait for InteractionFunctions to exist
while not InteractionsFunctions do
	Wait(1)
end

function loadanimdict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(1)
	end
end

-- Cuff

InteractionsFunctions["cuff"] = function()
	closestplayer = framework_GetClosestPlayer()

	if framework_GetClosestPlayer() == -1 or framework_GetClosestPlayer() == nil then
		EditableFunctions.Notify(Locale("no_players_nearby"))
		return
	end
	TriggerServerEvent("ludaro_manager:startArrest", GetPlayerServerId(closestplayer))
end

RegisterNetEvent("ludaro_manager:police:cuffPerson", function(target)
	ped = GetPlayerPed(GetPlayerFromServerId(target))
	AttachEntityToEntity(ped, PlayerPedId(), 11816,  -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
	loadanimdict('mp_arresting')
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
	ClearPedTasks(PlayerPedId())
	TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
end)

RegisterNetEvent("ludaro_manager:user:getCuffed", function(target)
	ped = GetPlayerPed(GetPlayerFromServerId(target))
	AttachEntityToEntity(PlayerPedId(), ped, 11816,  -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
	loadanimdict('mp_arresting')
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
	ClearPedTasks(PlayerPedId())
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(ped, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
end)

-- Uncuff

RegisterNetEvent("ludaro_manager:police:uncuffPerson", function(id)
	if id == nil or -1 then
		return 
	end
	local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
	local playerPed = PlayerPedId()

	RequestAnimDict('mp_arresting')

	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(targetPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
	TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
	Wait(5000)
	DetachEntity(targetPed, false, true)
	ClearPedTasks(PlayerPedId())
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent("ludaro_manager:user:getUncuffed", function(id)
	if id == nil or -1 then
		return 
	end
	local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
	local playerPed = PlayerPedId()

	RequestAnimDict('mp_arresting')

	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
	TaskPlayAnim(targetPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
	Wait(5000)
	DetachEntity(PlayerPedId(), false, true)
	ClearPedTasks(PlayerPedId())
	ClearPedTasksImmediately(PlayerPedId())
end)
