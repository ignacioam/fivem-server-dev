model = nil
resourceName = nil
canspawn = true
hash = nil
disablethis = false
blips = {}
PlayerBlip = nil
ShowHelpText = true
ShowHelpText_ADV = false
lastVehicle = nil
VehicleTable = {}
oldVehiclein = nil


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-------------------------------------------- COMMANDS ------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


RegisterCommand('restartcars', function(source, args)
    resourceName = args[1]
    if resourceName ~= nil then
        if not cooldown then
            cooldown = true
            disablethis = true
            TriggerServerEvent('cd_cartest:restartCars', resourceName, model)
            Wait(5000)
            cooldown = false
        else
            ShowNotification('Wait until the script has restarted')
        end
    else
        ShowNotification('No saved script to restart')
    end
end)

RegisterCommand('cars', function(source, args)
    local ped = GetPlayerPed(-1)
    model = args[1]
    if model ~= nil then
        if not IsPedInAnyVehicle(ped, true) then
            TriggerEvent('cd_cartest:spawnnAcar', model)
        else
            TriggerEvent('cd_cartest:DeleteVehicle2', GetVehiclePedIsUsing(ped))
            Wait(1000)
            TriggerEvent('cd_cartest:spawnnAcar', model)
        end
    else
        ShowNotification('No saved vehicle to spawn in')
    end
end)


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------- MAIN THREAD ----------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------



RegisterNetEvent('cd_cartest:spawnnAcar')
AddEventHandler('cd_cartest:spawnnAcar', function(model)
    if canspawn then
        if model then
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            TriggerEvent('cd_cartest:SpawnVehicle2',model, coords, heading, true, 'CODESIGN', 100, true, true)
        else
            ShowNotification('The model is nill')
        end
    else
        ShowNotification('Wait for the chat message before spawning in cars')
    end
end)

Citizen.CreateThread(function()
    for _, id in ipairs(GetActivePlayers()) do
        PlayerBlip = AddBlipForEntity(GetPlayerPed(id))
        SetBlipSprite(PlayerBlip, 1)
        SetBlipScale(PlayerBlip, 1.0)
        SetBlipColour(PlayerBlip, math.random(0,85))
        ShowHeadingIndicatorOnBlip(PlayerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(' '..GetPlayerName(id))
        EndTextCommandSetBlipName(PlayerBlip)
        table.insert(blips, PlayerBlip)
    end

    while true do
        Citizen.Wait(5)
        local playerPed = GetPlayerPed(-1)
        local vehiclein = GetVehiclePedIsUsing(playerPed)

        if oldVehiclein == nil then
            table.insert(VehicleTable, vehiclein)
            oldVehiclein = vehiclein
        end
        if vehiclein ~= oldVehiclein and vehiclein ~= 0 then
            table.insert(VehicleTable, vehiclein)
        end

        oldVehiclein = vehiclein

        if IsControlJustReleased(0, 47) then--G
            if ShowHelpText then
                local coordA = GetEntityCoords(playerPed, 1)
                local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
                local vehicleinfront = getVehicleInDirection(coordA, coordB)
                if IsPedInAnyVehicle(playerPed) then
                    if DoesEntityExist(vehiclein) then
                        TriggerEvent('cd_cartest:DeleteVehicle2', vehiclein)
                        ShowNotification('Vehicle deleted')
                    else
                        ShowNotification('No vehicle nearby')
                    end
                elseif DoesEntityExist(vehicleinfront) then
                    TriggerEvent('cd_cartest:DeleteVehicle2', vehicleinfront)
                    ShowNotification('Vehicle deleted')
                end
            end


        elseif IsControlJustReleased(0, 174) then--LEFT ARROW
            if ShowHelpText then
                if IsPedInAnyVehicle(playerPed, true) then
                    SetEntityCoords(vehiclein, 2017.90,2575.72,54.02)
                    SetEntityHeading(vehiclein, 315.85)
                    ShowNotification('TP to highway')
                else
                    SetEntityCoords(playerPed, 2017.90,2575.72,54.02)
                    SetEntityHeading(playerPed, 315.85)
                    ShowNotification('TP to highway')
                end
            end


        elseif IsControlJustReleased(0, 175) then--RIGHT ARROW
            if ShowHelpText then
                if IsPedInAnyVehicle(playerPed, true) then
                    SetEntityCoords(vehiclein, 232.56,-850.60,29.39)
                    SetEntityHeading(vehiclein, 252.48)
                    ShowNotification('TP to legion')
                else
                    SetEntityCoords(playerPed, 232.56,-850.60,29.39)
                    SetEntityHeading(playerPed, 252.48)
                    ShowNotification('TP to legion')
                end
            end


        elseif IsControlJustReleased(0, 173) then--DOWN ARROW
            if ShowHelpText then
                SetVehicleMaxMods(vehiclein)
                SetVehicleFixed(vehiclein)
                SetVehicleDirtLevel(vehiclein)
                WashDecalsFromVehicle(vehiclein, 1.0)
                SetVehicleOnGroundProperly(vehiclein)
                ShowNotification('Vehicle repaired, cleaned and fully maxed')
            end


        elseif IsControlJustReleased(0, 27) then--UP ARROW
            if ShowHelpText then
                if not IsPedInAnyVehicle(playerPed, true) then
                    model = model
                    if model ~= nil then
                        TriggerEvent('cd_cartest:spawnnAcar', model)
                    else
                        ShowNotification('No saved vehicle to spawn in')
                    end
                else
                    ShowNotification('You are already in a vehicle')
                end
            end

        elseif IsControlJustReleased(0, 201) then--ENTER
            if ShowHelpText then
                if IsPedInAnyVehicle(playerPed, true) then
                    SetEntityCoords(vehiclein, -1242.03, -2118.08, 13.49)
                    SetEntityHeading(vehiclein, 109.51)
                    ShowNotification('TP to airport')
                else
                    SetEntityCoords(playerPed, -1242.03, -2118.08, 13.49)
                    SetEntityHeading(playerPed, 109.51)
                    ShowNotification('TP to airport')
                end
            end

        elseif IsControlJustReleased(0, 96) then--NUMPAD +
            if ShowHelpText then
                resourceName = resourceName
                if resourceName ~= nil then
                    if not cooldown then
                        cooldown = true
                        disablethis = true
                        TriggerServerEvent('cd_cartest:restartCars', resourceName, model)
                        Wait(5000)
                        cooldown = false
                    else
                        ShowNotification('Wait until the script has restarted')
                    end
                else
                    ShowNotification('SYSTEM : No saved resource to restart')
                end
            end

        elseif IsControlJustReleased(0, 178) then--DELETE
            ShowHelpText = not ShowHelpText
            ShowHelpText_ADV = false

        elseif IsControlJustReleased(0, 121) then--INSERT
            if ShowHelpText then
                ShowHelpText_ADV = not ShowHelpText_ADV
            end

        elseif IsControlJustReleased(0, 177) then--BACKSPACE
            if ShowHelpText then
                TriggerServerEvent('vSync:ChangeWeather', 'EXTRASUNNY', false)
                TriggerServerEvent('vSync:ChangeTime', 13, 00)
                ShowNotification('Time and weather set to : EXTRASUNNY 13:00')
            end
        end
        
        if ShowHelpText and not ShowHelpText_ADV then
            Draw2DText(0.94, 0.40, "~b~[INS]~w~ - Enable Adv Help Text")
            Draw2DText(0.94, 0.44, "~b~[DEL]~w~ - Disable Visibility")
            Draw2DText(0.94, 0.50, "~b~/cars~w~ [modelname]")
            Draw2DText(0.94, 0.54, "~b~[G]~w~ - Delete Vehicle")
            Draw2DText(0.94, 0.58, "~b~[UP]~w~ - Spawn Last Vehicle")
            Draw2DText(0.94, 0.62, "~b~[DOWN]~w~ - Repair Vehicle")
            Draw2DText(0.94, 0.66, "~b~[LEFT]~w~ - TP to Highway")
            Draw2DText(0.94, 0.70, "~b~[RIGHT]~w~ - TP to Legion")
            Draw2DText(0.94, 0.74, "~b~[ENTER]~w~ - TP to Airport")
        elseif ShowHelpText and ShowHelpText_ADV then
            Draw2DText(0.94, 0.26, "~b~/restartcars~w~ [resourcename]")
            Draw2DText(0.94, 0.30, "~b~[NUMPAD+]~w~ - Restart Last Script")
            Draw2DText(0.94, 0.34, "~b~[BACKSPACE]~w~ - Reset Time")
            Draw2DText(0.94, 0.40, "~b~[INS]~w~ - Disable Adv Help Text")
            Draw2DText(0.94, 0.44, "~b~[DEL]~w~ - Disable Visibility")
            Draw2DText(0.94, 0.50, "~b~/cars~w~ [modelname]")
            Draw2DText(0.94, 0.54, "~b~[G]~w~ - Delete Vehicle")
            Draw2DText(0.94, 0.58, "~b~[UP]~w~ - Spawn Last Vehicle")
            Draw2DText(0.94, 0.62, "~b~[DOWN]~w~ - Repair Vehicle")
            Draw2DText(0.94, 0.66, "~b~[LEFT]~w~ - TP to Highway")
            Draw2DText(0.94, 0.70, "~b~[RIGHT]~w~ - TP to Legion")
            Draw2DText(0.94, 0.74, "~b~[ENTER]~w~ - TP to Airport")
        elseif not ShowHelpText then
            Draw2DText(0.94, 0.44, "~b~[DEL]~w~ - Enable Visibility")
        end
    end
end)


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------- PLAYER BLIPS ---------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        local count = 0
        local playerlist = GetActivePlayers()
        for i = 1, #playerlist do
            count = count + 1
        end

        if lastCount == nil then
            lastCount = count
        end

        if count ~= lastCount then
            TriggerServerEvent('cd_cartest:RefreshBlips')
        end
        lastCount = count
    end
end)

RegisterNetEvent('cd_cartest:RefreshBlips')
AddEventHandler('cd_cartest:RefreshBlips', function()
    ShowNotification('Refreshed player blips')
    for _, PlayerBlip in ipairs(blips) do
        if DoesBlipExist(PlayerBlip) then
            RemoveBlip(PlayerBlip)
        end
    end
    Wait(1000)
    for _, id in ipairs(GetActivePlayers()) do
        PlayerBlip = AddBlipForEntity(GetPlayerPed(id))
        SetBlipSprite(PlayerBlip, 1)
        SetBlipScale(PlayerBlip, 1.0)
        SetBlipColour(PlayerBlip, math.random(0,85))
        ShowHeadingIndicatorOnBlip(PlayerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(' '..GetPlayerName(id))
        EndTextCommandSetBlipName(PlayerBlip)
        table.insert(blips, PlayerBlip)
    end
end)


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
--------------------------------------- MANAGING VEHICLES --------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


RegisterNetEvent('cd_cartest:deleteplayercars')
AddEventHandler('cd_cartest:deleteplayercars', function()
    local playerPed = GetPlayerPed(-1)
    local vehiclein = GetVehiclePedIsIn(playerPed, false)

    if IsPedInAnyVehicle(playerPed) then
        TriggerEvent('cd_cartest:DeleteVehicle2', vehiclein)
    end
    Wait(100)
    if DoesEntityExist(lastVehicle) then
        TriggerEvent('cd_cartest:DeleteVehicle2', lastVehicle)
    end
    Wait(100)
    if VehicleTable ~= nil then
        for _, VehID in ipairs(VehicleTable) do
            if DoesEntityExist(VehID) then
                TriggerEvent('cd_cartest:DeleteVehicle2', VehID)
            end
        end
    end
    Wait(100)
    local gameVehicles = GetVehicles()
    for i = 1, #gameVehicles do
        local vehicles = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            TriggerEvent('cd_cartest:DeleteVehicle2', vehicles)
        end
    end
    VehicleTable = nil
    Wait(100)
    VehicleTable = {}
end)

RegisterNetEvent('cd_cartest:disablecars')
AddEventHandler('cd_cartest:disablecars', function()
    canspawn = false
    TriggerEvent('cd_cartest:pleasewait')
end)

RegisterNetEvent('cd_cartest:pleasewait')
AddEventHandler('cd_cartest:pleasewait', function()
    count = 500
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            count = count - 1
            if count <= 500 and count > 400 then
                DrawScreenText1('Please wait 5...')
            elseif count <= 400 and count > 300 then
                DrawScreenText1('Please wait 4...')
            elseif count <= 300 and count > 200 then
                DrawScreenText1('Please wait 3...')
            elseif count <= 200 and count > 100 then
                DrawScreenText1('Please wait 2...')
            elseif count <= 100 and count > 20 then
                DrawScreenText1('Please wait 1...')
            elseif count <= 20 and count > 0 then
                DrawScreenText1('You are sexy and you know it!')
            else
                break
            end
        end
    end)
end)

RegisterNetEvent('cd_cartest:enablecars')
AddEventHandler('cd_cartest:enablecars', function()
    canspawn = true
    if not disablethis then
        if ShowHelpText then
            TriggerEvent('cd_cartest:spawnnAcar', model)
            disablethis = false
        end
    end
end)

RegisterNetEvent('cd_cartest:DeleteVehicle2')
AddEventHandler('cd_cartest:DeleteVehicle2', function(vehicle, checkforvehicle)
    if vehicle ~= nil then
        if checkforvehicle then
            if not IsEntityAVehicle(vehicle) then
                ShowNotification('This entity is not a vehicle')
                return
            end
        else
            if not DoesEntityExist(vehicle) then
                ShowNotification('This entity does not exist')
                return
            end
        end

        NetworkRequestControlOfEntity(vehicle)
        local timeout = 0
        local finaltimer = 0
        local dots = "."
        while not NetworkHasControlOfEntity(vehicle) and timeout <= 400 do 
            Citizen.Wait(5)
            timeout = timeout + 1
            for k, v in pairs (TimerTable) do
                if timeout == v.time then
                    finaltimer = finaltimer + 1
                    dots = DotMe(dots)
                end
            end
            NetworkRequestControlOfEntity(vehicle)
            DrawScreenText2("Requesting Network Control of Entity "..finaltimer.."/20".." "..dots)
        end

        local timeout = 0
        local finaltimer = 0
        local dots = "."
        local netID = NetworkGetNetworkIdFromEntity(vehicle)
        while not NetworkHasControlOfNetworkId(netID) and timeout <= 400 do 
            Citizen.Wait(5)
            timeout = timeout + 1
            for k, v in pairs (TimerTable) do
                if timeout == v.time then
                    finaltimer = finaltimer + 1
                    dots = DotMe(dots)
                end
            end
            NetworkRequestControlOfNetworkId(netID)
            DrawScreenText2("Requesting Control of Network ID "..finaltimer.."/20".." "..dots)
        end

        if NetworkHasControlOfEntity(vehicle) then
            SetEntityAsMissionEntity(vehicle)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            NetworkFadeOutEntity(vehicle, true, true)
            Citizen.Wait(100)
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
            SetEntityAsNoLongerNeeded(vehicle)
            DeleteEntity(vehicle)
            DeleteVehicle(vehicle)
            print('VEHICLE DELETED')
        else
            TriggerServerEvent('cd_cartest:DeleteVehicleADV2', netID)
        end
    end
end)

RegisterNetEvent('cd_cartest:DeleteVehicleADV2')
AddEventHandler('cd_cartest:DeleteVehicleADV2', function(netID)
    local entID = NetworkGetEntityFromNetworkId(netID)
    if NetworkHasControlOfEntity(entID) then
        SetEntityAsNoLongerNeeded(entID)
        NetworkFadeOutEntity(entID, true, true)
        Citizen.Wait(100)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entID))
        DeleteEntity(entID)
        DeleteVehicle(entID)
        print('cd_cartest:DeleteVehicleADV2 - VEHICLE DELETED')
    else
        ShowNotification('Error - you do not have control of network entity. Try again')
    end
end)

RegisterNetEvent('cd_cartest:SpawnVehicle2')
AddEventHandler('cd_cartest:SpawnVehicle2', function(modelName, coords, heading, ownedcar, changeplate, fuel, incar, max)

    local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
    model = model
    if not IsModelValid(model) then
        return ShowNotification('This model does not exist ingame')
    end

    Citizen.CreateThread(function()
        if not HasModelLoaded(model) and IsModelInCdimage(model) then
            RequestModel(model)
            local timeout = 0
            local dots = "."
            while not HasModelLoaded(model) do
                timeout = timeout + 1
                for k, v in pairs (TimerTable2) do
                    if timeout == v.time then
                        dots = DotMe(dots)
                    end
                end
                Citizen.Wait(5)
                DrawScreenText2("Loading Model : "..GetDisplayNameFromVehicleModel(model).." "..dots)
            end
        end

        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
        lastVehicle = vehicle

        local timeout = 0
        local finaltimer = 0
        local dots = "."
        while not DoesEntityExist(vehicle) and timeout <= 400 do 
            Citizen.Wait(5)
            timeout = timeout + 1
            for k, v in pairs (TimerTable) do
                if timeout == v.time then
                    finaltimer = finaltimer + 1
                    dots = DotMe(dots)
                end
            end
            DrawScreenText2("Registering Entity "..finaltimer.."/20".." "..dots)
        end
        if not DoesEntityExist(vehicle) then
            TriggerEvent('cd_cartest:DeleteVehicle2', vehicle)
            ShowNotification('Could not register the entity - please try again')
        end

        NetworkFadeInEntity(vehicle, true, true)
        SetVehicleOnGroundProperly(vehicle)

        if ownedcar then
            local timeout = 0
            local finaltimer = 0
            local dots = "."
            while not NetworkHasControlOfEntity(vehicle) and timeout <= 400 do 
                Citizen.Wait(5)
                timeout = timeout + 1
                for k, v in pairs (TimerTable) do
                    if timeout == v.time then
                        finaltimer = finaltimer + 1
                        dots = DotMe(dots)
                    end
                end
                NetworkRequestControlOfEntity(vehicle)
                DrawScreenText2("Requesting Network Control "..finaltimer.."/20".." "..dots)
            end
            if not NetworkHasControlOfEntity(vehicle) then
                TriggerEvent('cd_cartest:DeleteVehicle2', vehicle)
                ShowNotification('Could not request network control - please try again')
            end

            local timeout = 0
            local finaltimer = 0
            local dots = "."
            while not NetworkGetEntityIsNetworked(vehicle) and timeout <= 400 do 
                Citizen.Wait(5)
                timeout = timeout + 1
                for k, v in pairs (TimerTable) do
                    if timeout == v.time then
                        finaltimer = finaltimer + 1
                        dots = DotMe(dots)
                    end
                end
                NetworkRegisterEntityAsNetworked(vehicle)
                DrawScreenText2("Registering Entity as Networked "..finaltimer.."/20".." "..dots)
            end
            if not NetworkGetEntityIsNetworked(vehicle) then
                TriggerEvent('cd_cartest:DeleteVehicle2', vehicle)
                ShowNotification('Could not register the entity as networked - please try again')
            end            

            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            local netid = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(netid, true)
            SetNetworkIdExistsOnAllMachines(netid, true)
            NetworkRequestControlOfEntity(vehicle)
        end
        
        SetModelAsNoLongerNeeded(vehicle)
        SetVehicleDirtLevel(vehicle)
        WashDecalsFromVehicle(vehicle, 1.0)
        SetVehicleExtraColours(vehicle, 0, 0)
        if changeplate ~= nil then
            local length = #changeplate
            local result = 8-length
            if result ~= 8 then
                aidsMaths(result)
                SetVehicleNumberPlateText(vehicle, changeplate..''..random)
            else
                SetVehicleNumberPlateText(vehicle, changeplate)
            end
        end

        if fuel ~= nil then
            DecorSetInt(vehicle, "_FUEL_LEVEL", math.ceil(100))
        else
            DecorSetInt(vehicle, "_FUEL_LEVEL", math.ceil(fuel))
        end
        if incar then
            SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
        end

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            Citizen.Wait(0)
        end

        SetVehRadioStation(vehicle, 'OFF')

        if max then
            Wait(500)
            SetVehicleMaxMods(vehicle)
        end
        SetModelAsNoLongerNeeded(model)
        ShowNotification('Spawned vehicle - '..model)
    end)
end)

function ShowNotification(message)
    SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(message)
    DrawNotification(false, true)
end