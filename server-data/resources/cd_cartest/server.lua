RegisterServerEvent('cd_cartest:restartCars')
AddEventHandler('cd_cartest:restartCars', function(resourceName, model)
    local _source = source
    TriggerClientEvent('chat:addMessage', -1, {
    template = '<div class="chat-message ooc"> <div class="chat-message-header"> <class="chat-message-body"> <b>RESTART SCRIPT 1</p></b> Deleting all cars and restarting <b>'..resourceName..'</b>'})
    TriggerClientEvent('cd_cartest:deleteplayercars', -1)
    TriggerClientEvent('cd_cartest:disablecars', -1)
    Wait(3000)
    StopResource(resourceName)
    Citizen.Wait(100)
    StartResource(resourceName)
    TriggerClientEvent('cd_cartest:enablecars', -1)
    TriggerClientEvent('chat:addMessage', -1, {
    template = '<div class="chat-message system"> <div class="chat-message-header"> <class="chat-message-body"> <b>RESTART SCRIPT 2</p></b> <b>Restarted script :</b> '..resourceName..'</p> And all cars have been deleted'})
    if model then
        Wait(2000)
        TriggerClientEvent('cd_cartest:spawnnAcar', _source, model)
    end
end)

RegisterServerEvent('cd_cartest:RefreshBlips')
AddEventHandler('cd_cartest:RefreshBlips', function()
    local _source = source
    TriggerClientEvent('cd_cartest:RefreshBlips', _source)
end)