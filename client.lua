savedvehicle = nil
key = 51
ped = PlayerPedId(-1)


doors = {
    [0] = "Front Left",
    [1] = "Front Right" ,
    [2] = "Back Left",
    [3] = "Back Right",
    [4] = "Hood" ,
    [5] = "Trunk",  
    [6] = "Back" , 
    [7] = "Back 2"  
}
index = {
    door = 0
}

cardoors = {}
for k, v in pairs (doors) do 
    cardoors[k] = v

end
RMenu.Add('vehmenu', 'main', RageUI.CreateMenu("Vehicle Menu", "~b~Vehicle Menu", nil, nil))


RageUI.CreateWhile(1.0, RMenu:Get('vehmenu', 'main'), key, function()
    
    RageUI.IsVisible(RMenu:Get('vehmenu', 'main'), true, true, true, function()
        tglEngine()
        doorList()
        tglDoorLocks() 
        savedvehiclebtn()
    end, function()
    end)
end)
engineStatus = {
    [1] = true
}
function tglEngine() 
    RageUI.Button("Toggle Engine" , "Turn Engine on or off", {}, true, function(Hovered, Active, Selected)
        if (Selected) then
            if engineStatus[1] then
                if savedvehicle ~= nil then 
                    SetVehicleEngineOn(savedvehicle, false ,true, true)
                    engineStatus[1] = false
                    notify("~r~Engine Off")
                else
                    SetVehicleEngineOn(GetVehiclePedIsIn(ped, false), false ,true, true)
                    engineStatus[1] = false
                    notify("~r~Engine Off")
                end
                
            
            else
                if savedvehicle ~= nil then 
                    SetVehicleEngineOn(savedvehicle, true ,true, true)
                    engineStatus[1] = true
                    notify("~g~Engine On")
                else
                    SetVehicleEngineOn(GetVehiclePedIsIn(ped, false), true ,true, true)
                    engineStatus[1] = true
                    notify("~g~Engine On")
                end
            end 
            
        end

    end)
end

lockStatus = {
    [1] = false
}
function tglDoorLocks() 
    RageUI.Button("Toggle Door Locks" , nil, {}, true, function(Hovered, Active, Selected)
        if Selected then
            if lockStatus[1] then
                if savedvehicle ~= nil then 
                    SetVehicleDoorsLocked(savedvehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(savedvehicle, false)
                    SetVehicleDoorsLockedForPlayer(savedvehicle, PlayerId(), false)
                    lockStatus[1] = false
                    notify("~g~Doors Unlocked")
                else
                    SetVehicleDoorsLocked(GetVehiclePedIsIn(ped, false), 1)
                    SetVehicleDoorsLockedForAllPlayers(GetVehiclePedIsIn(ped, false), false)
                    SetVehicleDoorsLockedForPlayer(GetVehiclePedIsIn(ped, false), PlayerId(), false)
                    lockStatus[1] = false
                    notify("~g~Doors Unlocked")
                    
                end

            else
                if savedvehicle ~= nil then 
                    SetVehicleDoorsLocked(savedvehicle, 2)
                    SetVehicleDoorsLockedForAllPlayers(savedvehicle, true)
                    SetVehicleDoorsLockedForPlayer(savedvehicle, PlayerId(), true)
                    lockStatus[1] = true
                    notify("~r~Doors Locked")
                else
                    SetVehicleDoorsLocked(GetVehiclePedIsIn(ped, false), 2)
                    SetVehicleDoorsLockedForAllPlayers(GetVehiclePedIsIn(ped, false), true)
                    SetVehicleDoorsLockedForPlayer(GetVehiclePedIsIn(ped, false), PlayerId(), true)
                    
                    savedvehicle = GetVehiclePedIsIn(ped, false)
                    lockStatus[1] = true
                    
                end
            end 
        end

    end)


end
doorStatus = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false
}
function doorList() 
    RageUI.List("Toggle Door", cardoors, index.door, nil, {}, true, function(Hovered, Active, Selected, Index)
        if (Selected) then
            if doorStatus[Index] then
                if savedvehicle ~= nil then 
                    SetVehicleDoorShut(savedvehicle,Index, false, false)
                    doorStatus[Index] = false
                else
                    SetVehicleDoorShut(GetVehiclePedIsIn(ped, false),Index, false, false)
                    doorStatus[Index] = false
                end
                
            
            else
                if savedvehicle ~= nil then 
                    SetVehicleDoorOpen(savedvehicle,Index, false, false)
                    doorStatus[Index] = true
                else
                    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false),Index, false, false)
                    doorStatus[Index] = true
                end
            end 
            
        end
        if (Active) then 
            index.door = Index;
        end
        
    end)

end

function savedvehiclebtn()
    RageUI.Button("Save Current Vehicle" , nil, {}, true, function(Hovered, Active, Selected)
        if Selected then
            if IsPedInAnyVehicle(ped, true) then 
                savedvehicle = GetVehiclePedIsIn(ped, false)
                notify("Vehicle Saved!")

            else
                notify("~r~You are not in a vehicle.")
            end
        end

    end) 

end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

Citizen.CreateThread(function() 
    while true do 
        if savedvehicle ~= nil and IsPedInAnyVehicle(ped, true)then 
            if savedvehicle ~= GetVehiclePedIsIn(ped, false) then 
                savedvehicle = nil
                
            end
        end 
        Wait(30000)
    end

end)

