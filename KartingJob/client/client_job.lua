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

function Menuf6Karting()
    local fKartingf6 = RageUI.CreateMenu("", "Interactions")
    local fKartingf6Sub = RageUI.CreateSubMenu(fKartingf6, "", "Annonces")
    fKartingf6:SetRectangleBanner(150, 0, 0)
    fKartingf6Sub:SetRectangleBanner(150, 0, 0)
    RageUI.Visible(fKartingf6, not RageUI.Visible(fKartingf6))
    while fKartingf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(fKartingf6, true, true, true, function()

                RageUI.Separator("~y~↓ Facture ↓")

                RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_Karting', ('Benny\'s'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                            TriggerServerEvent('D-Mecano:Facture', GetPlayerName(PlayerPedId()), montant)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)


                RageUI.Separator("~y~↓ Annonce ↓")

                RageUI.ButtonWithStyle("Passer une annonce", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, fKartingf6Sub)

                RageUI.Separator("~y~↓ Action sur les kart ↓")

                RageUI.ButtonWithStyle("Réparer le véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        GetCloseVehi()
                    if Selected then
                        local playerPed = PlayerPedId()
                        local vehicle   = ESX.Game.GetVehicleInDirection()
                        local coords    = GetEntityCoords(playerPed)

                        if IsPedSittingInAnyVehicle(playerPed) then
                            ESX.ShowNotification('Veuillez descendre de la voiture.')
                            return
                        end

                        if DoesEntityExist(vehicle) then
                            isBusy = true
                            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                            Citizen.CreateThread(function()
                                Citizen.Wait(20000)

                                SetVehicleFixed(vehicle)
                                SetVehicleDeformationFixed(vehicle)
                                SetVehicleUndriveable(vehicle, false)
                                SetVehicleEngineOn(vehicle, true, true)
                                ClearPedTasksImmediately(playerPed)

                                ESX.ShowNotification('Le véhicule est réparer')
                                isBusy = false
                            end)
                        else
                            ESX.ShowNotification('Aucun véhicule à proximiter')
                        end
                    end
                    end
                end)

                RageUI.ButtonWithStyle("Nettoyer le véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Active then
                        GetCloseVehi()
                    if Selected then
                        local playerPed = PlayerPedId()
                        local vehicle   = ESX.Game.GetVehicleInDirection()
                        local coords    = GetEntityCoords(playerPed)

                        if IsPedSittingInAnyVehicle(playerPed) then
                            ESX.ShowNotification('Veuillez sortir de la voiture?')
                            return
                        end

                        if DoesEntityExist(vehicle) then
                            isBusy = true
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                            Citizen.CreateThread(function()
                                Citizen.Wait(10000)

                                SetVehicleDirtLevel(vehicle, 0)
                                ClearPedTasksImmediately(playerPed)

                                ESX.ShowNotification('Voiture néttoyé')
                                isBusy = false
                            end)
                        else
                            ESX.ShowNotification('Aucun véhicule trouvée')
                        end

                    end
                end
            end)


                end, function() 
                end)

                RageUI.IsVisible(fKartingf6Sub, true, true, true, function()
                RageUI.ButtonWithStyle("Annonces d'ouverture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        TriggerServerEvent('fKarting:Ouvert')
                    end
                end)
        
                RageUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('fKarting:Fermer')
                    end
                end)
        
                RageUI.ButtonWithStyle("Personnalisé", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyboardInput("Message", "", 100)
                        TriggerServerEvent('fKarting:Perso', msg)
                    end
                end)

                end, function() 
                end)

    
                if not RageUI.Visible(fKartingf6) and not RageUI.Visible(fKartingf6Sub) then
                    fKartingf6 = RMenu:DeleteType("Karting", true)
        end
    end
end


Keys.Register('F6', 'Karting', 'Ouvrir le menu Karting', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'Karting' then
        Menuf6Karting()
    end
end)