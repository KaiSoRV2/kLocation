
ESX = exports["es_extended"]:getSharedObject()

local MainMenuOuvert = false 
local MainLocation = RageUI.CreateMenu('', 'Location')
local MenuVoiture = RageUI.CreateSubMenu(MainLocation, '', "Voiture Location")
local MenuBike = RageUI.CreateSubMenu(MainLocation, '', "Bike Location")
local MenuPaiement = RageUI.CreateSubMenu(MenuVoiture, '', "Mode Paiement")
MainLocation.Display.Header = true 
MainLocation.Closed = function()
    MainMenuOuvert = false 
end 

local ComptLocation = false


function Location(veh_spawn, veh_heading)

    local IndexList = 1

    if MainMenuOuvert then 
        MainMenuOuvert = false 
        RageUI.Visible(MainLocation, false)
        return 
    else 
        MainMenuOuvert = true 
        RageUI.Visible(MainLocation, true)
        CreateThread(function()
            while MainMenuOuvert do 
                RageUI.IsVisible(MainLocation, function()
                    
                    RageUI.Separator("↓ Location ↓")
                    if not ComptLocation then
                        RageUI.Button('Voiture Location', nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {}, MenuVoiture);
                        RageUI.Button('Bike Location', nil, {RightBadge = RageUI.BadgeStyle.Bike}, true, {}, MenuBike);

                    elseif ComptLocation then 
                        RageUI.Button('Retour Location', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function ()

                                local GetVeh = GetVehiclePedIsIn(PlayerPedId(), false) 
                                local HashVeh = GetEntityModel(GetVeh)
                                local Plaque = GetVehicleNumberPlateText(GetVeh)

                                if Plaque == "LOCATION" then 
                                    TriggerServerEvent('kLocation:RetourLocation', Config.Caution)
                                    DeleteEntity(GetVeh)
                                    RageUI.CloseAll()
                                    ComptLocation = false
                                else 
                                    ESX.ShowNotification("~r~Votre véhicule n'est pas une location !")
                                end
                            end
                        });
                        RageUI.Button('Perte du Véhicule', "Si vous avez perdu votre location, vous pouvez payer cette caution pour de accéder aux locations !", {RightLabel = "~r~"..ESX.Math.GroupDigits(Config.CautionPerteVehicule).."$"}, true, {
                            onSelected = function ()
                                ESX.TriggerServerCallback('kLocation:PerteLocation', function(HasEnough) 
                                    if HasEnough then 
                                        RageUI.CloseAll()
                                        ComptLocation = false
                                    else 
                                        ESX.ShowNotification("~r~Vous n'avez pas assez d'argent pour payer cette caution !")
                                    end 
                                end, Config.CautionPerteVehicule)
                            end
                        });
                    else 
                        ESX.ShowNotification("~r~Vous avez déjà une location en cours !")
                    end              
                end)

                RageUI.IsVisible(MenuVoiture, function()
                    RageUI.Separator("↓ Voiture Location ↓")
                    for k, v in pairs(Config.Veh.Car) do
                        RageUI.Button(v.label, nil, {RightLabel = "~r~"..ESX.Math.GroupDigits(v.price + Config.Caution).."$"}, true, {
                            onSelected = function()
                                price = v.price + Config.Caution
                                veh = v.veh 
                                label = v.label 
                            end
                        }, MenuPaiement)
                    end
                end)

                RageUI.IsVisible(MenuBike, function()
                    RageUI.Separator("↓ Bike Location ↓")
                    for k, v in pairs(Config.Veh.Bike) do
                        RageUI.Button(v.label, nil, {RightLabel = "~r~"..ESX.Math.GroupDigits(v.price + Config.Caution).."$"}, true, {
                            onSelected = function()
                                price = v.price + Config.Caution
                                veh = v.veh 
                                label = v.label 
                            end
                        }, MenuPaiement)
                    end
                end)

                RageUI.IsVisible(MenuPaiement, function()
                    RageUI.Separator("↓ Mode de Paiement ↓")
                        RageUI.List("Moyen de Paiement : ", {"Liquide", "Banque"}, IndexList, nil, {}, true, {
                            onListChange = function(Index, Item) -- Index - Indice sur lequel on est et Item = ce qu'on à mit à l'interieur
                                IndexList = Index
                            end,
                            onSelected = function(Index, Item)
                                if Index == 1 and Item == "Liquide" then 
                                    ESX.TriggerServerCallback('kLocation:CheckLiquide', function(HasEnoughLiquide) 
                                        if HasEnoughLiquide then 

                                            SpawnVehicule(veh, label, veh_spawn, veh_heading)
                                            RageUI.CloseAll()
                                            ComptLocation = true
                                        else 
                                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent sur vous !")
                                        end
                                    end, price)

                                elseif Index == 2 and Item == "Banque" then 
                                    ESX.TriggerServerCallback('kLocation:CheckBank', function(HasEnoughBank) 
                                        if HasEnoughBank then 

                                            SpawnVehicule(veh, label, veh_spawn, veh_heading)
                                            RageUI.CloseAll()
                                            ComptLocation = true
                                        else 
                                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent en banque !")
                                        end
                                    end, price)
                                end
                            end
                        })
                end)          
            Wait(0)
            end
        end)
    end 
end 


function SpawnVehicule(typevehicle, label, veh_spawn, veh_heading)

    RequestModel(typevehicle)
    while not HasModelLoaded(typevehicle) do
        Wait(1)
    end

    veh = CreateVehicle(typevehicle, veh_spawn, veh_heading, true, false)
    SetVehRadioStation(veh, 0)
    SetVehicleNumberPlateText(veh, "Location")
    RageUI.CloseAll()
    FreezeEntityPosition(PlayerPedId())
    ESX.ShowNotification("Vous venez de louer : ~b~"..label)
end


Citizen.CreateThread(function()
    for k, v in pairs(Config.Position) do 
        while not HasModelLoaded(Config.Blip.Ped.hash) do
            RequestModel(Config.Blip.Ped.hash)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(Config.Blip.Ped.hash), v.pos, v.HeadingPed, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, Config.Blip.Ped.hash, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
end)


Citizen.CreateThread(function()
    for k, v in pairs(Config.Position) do
        local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blip, Config.Blip.Type)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.Size)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Blip.Label)
        EndTextCommandSetBlipName(blip)
    end
end)


function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)      
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


Citizen.CreateThread(function()
	while true do
        local wait = 750
        local plyCoords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Config.Position) do 
            pos = v.pos 
            spawn_veh = v.spawnveh
            heading_veh = v.spawn_heading

            dist_ped = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos.x, pos.y, pos.z)

            if dist_ped <= Config.DistInteraction then 
                ped_pos = pos
                veh_spawn = spawn_veh 
                veh_heading = heading_veh 
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ped_pos.x, ped_pos.y, ped_pos.z)

                if dist <= Config.DistInteraction then 
                    wait = 0
                    Draw3DText(ped_pos.x, ped_pos.y, ped_pos.z-0.600, Config.Blip.Texte, 4, 0.1, 0.05)
		            if IsControlJustReleased(0, Config.InputKey) then
                        Location(veh_spawn, veh_heading)
                    end
                end 
            end 
	    end
    Citizen.Wait(wait)
    end
end)
