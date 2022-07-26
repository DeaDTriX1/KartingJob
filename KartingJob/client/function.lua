ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

        ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)  
--- BLIPS ---

Citizen.CreateThread(function()

    local blip = AddBlipForCoord(Karting.pos.blips.position.x, Karting.pos.blips.position.y, Karting.pos.blips.position.z)

    SetBlipSprite (blip, 147) -- Model du blip
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.80) -- Taille du blip
    SetBlipColour (blip, 1) -- Couleur du blip
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Karting') -- Nom du blip
    EndTextCommandSetBlipName(blip)
end)



function GetCloseVehi()
    local player = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 102, 0, 170, 0, 1, 2, 0, nil, nil, 0)
end


function CoffreKarting()
    local CKarting = RageUI.CreateMenu("Coffre", "Benny's")
    CKarting:SetRectangleBanner(150, 0, 0)
        RageUI.Visible(CKarting, not RageUI.Visible(CKarting))
            while CKarting do
            Citizen.Wait(0)
            RageUI.IsVisible(CKarting, true, true, true, function()

                RageUI.Separator("~y~↓ Objet ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            KartingRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            KartingDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)

                RageUI.Separator("~y~↓ Vêtements ↓")

                    RageUI.ButtonWithStyle("Uniforme",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vuniformeKarting()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Remettre sa tenue",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vcivil()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CKarting) then
            CKarting = RMenu:DeleteType("CKarting", true)
        end
    end
end


Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'Karting' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Karting.pos.coffre.position.x, Karting.pos.coffre.position.y, Karting.pos.coffre.position.z)
            if jobdist <= 20.0 and Karting.jeveuxmarker then
                Timer = 0
                DrawMarker(22, Karting.pos.coffre.position.x, Karting.pos.coffre.position.y, Karting.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 125, 0, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreKarting()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


-- Garage

function GarageKarting()
  local GKarting = RageUI.CreateMenu("Garage", "Benny's")
  GKarting:SetRectangleBanner(150, 0, 0)
    RageUI.Visible(GKarting, not RageUI.Visible(GKarting))
        while GKarting do
            Citizen.Wait(0)
                RageUI.IsVisible(GKarting, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(GKartingvoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarKarting(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GKarting) then
            GKarting = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'Karting' then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Karting.pos.garage.position.x, Karting.pos.garage.position.y, Karting.pos.garage.position.z)
            if dist3 <= 20.0 and Karting.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Karting.pos.garage.position.x, Karting.pos.garage.position.y, Karting.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 125, 0, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageKarting()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarKarting(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Karting.pos.spawnvoiture.position.x, Karting.pos.spawnvoiture.position.y, Karting.pos.spawnvoiture.position.z, Karting.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "Benny's"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end


itemstock = {}
function KartingRetirerobjet()
    local StockKarting = RageUI.CreateMenu("Coffre", "Benny's")
    StockKarting:SetRectangleBanner(150, 0, 0)
    ESX.TriggerServerCallback('fKarting:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(StockKarting, not RageUI.Visible(StockKarting))
        while StockKarting do
            Citizen.Wait(0)
                RageUI.IsVisible(StockKarting, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('fKarting:getStockItem', v.name, tonumber(count))
                                    KartingRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockKarting) then
            StockKarting = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function KartingDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Benny's")
    StockPlayer:SetRectangleBanner(150, 0, 0)
    ESX.TriggerServerCallback('fKarting:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('fKarting:putStockItems', item.name, tonumber(count))
                                            KartingDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

function vuniformeKarting()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Karting.tenue.male
        else
            uniformObject = Karting.tenue.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)end

function vcivil()
ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
TriggerEvent('skinchanger:loadSkin', skin)
end)
end


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
