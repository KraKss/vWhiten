ESX = nil
local menu = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local mainMenu = RageUI.CreateMenu("Blanchisseur", "Blanchissement") 
mainMenu.EnableMouse = true
mainMenu:DisplayPageCounter(false)

local SliderPannel = {
    Minimum = 0,
    Index = 1,
}

mainMenu.Closed = function() 
    SliderPannel.Index = 1 
    menu = false 
end

function openMenu()
    if menu then menu = false RageUI.Visible(mainMenu, false)
    else menu = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while menu do 
                RageUI.IsVisible(mainMenu, function()  
                    RageUI.Separator("Le blanchisseur prends ~b~"..Config.Percent.."%")   
                    RageUI.Separator("Votre Argent sale: ~r~"..ESX.PlayerData.accounts[2].money.." $")                   
                    if ESX.PlayerData.accounts[2].money >= 2 then
                        RageUI.Line(93, 182, 229, 255)  
                        RageUI.Button('Argent à blanchir', false , {RightLabel = "$"..SliderPannel.Index}, true , {})
                        RageUI.Button('Blanchir', false, {RightLabel = "$"..Round(SliderPannel.Index * Config.Percentage)}, true, {
                            onSelected = function() 
                                Progress = true
                                FreezeEntityPosition(PlayerPedId(), true)
                                mainMenu.Closable = false
                            end
                        })              
                        RageUI.SliderPanel(SliderPannel.Index, SliderPannel.Minimum, "~b~Quantité", ESX.PlayerData.accounts[2].money, {
                            onSliderChange = function(Index)
                                SliderPannel.Index = Index
                            end
                        }, 3)
                        
                        if Progress == true then
                            RageUI.PercentagePanel(Config.PercentagePannel, '~b~Blanchiment en cours', '', '', {}, 4)
                            if Config.PercentagePannel < 1.0 and SliderPannel.Index <= 1000 then
                                Config.PercentagePannel = Config.PercentagePannel + 0.008 -- durée du chargement en fonction du montant
                            elseif Config.PercentagePannel < 1.0 and SliderPannel.Index >= 1000 then
                                Config.PercentagePannel = Config.PercentagePannel + 0.0008
                            elseif Config.PercentagePannel < 1.0 and SliderPannel.Index >= 5000 then
                                Config.PercentagePannel = Config.PercentagePannel + 0.0003
                            elseif Config.PercentagePannel < 1.0 and SliderPannel.Index >= 10000 then
                                Config.PercentagePannel = Config.PercentagePannel + 0.00005
                            elseif Config.PercentagePannel < 1.0 and SliderPannel.Index >= 25000 then
                                Config.PercentagePannel = Config.PercentagePannel + 0.000004
                            else
                                local FinalPercentage = Round(SliderPannel.Index * Config.Percentage)
                                FreezeEntityPosition(PlayerPedId(), false)                                                        
                                TriggerServerEvent('kWhiten', FinalPercentage, SliderPannel.Index) 
                                Config.PercentagePannel = 0.0
                                Progress = false
                                mainMenu.Closable = true
                                mainMenu.Closed()
                            end
                        end  
                    end                
                end)                
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    local co = GetEntityCoords(PlayerPedId())
    local distPed = GetDistanceBetweenCoords(co, coPed, false)    
    local ped = "u_m_m_streetart_01" 
    RequestModel(ped)    
    while not HasModelLoaded(ped) do
        Citizen.Wait(100)
    end    
    local pedCreated = CreatePed(0, ped, -1166.90, 4926.04, 222.03, 263.57, false, false) 
    SetBlockingOfNonTemporaryEvents(pedCreated, true)
    SetEntityInvincible(pedCreated, true)
    FreezeEntityPosition(pedCreated, true)
end) 

function RefreshPlayerData()
    Citizen.CreateThread(function()
        ESX.PlayerData = ESX.GetPlayerData()
    end)
end

Citizen.CreateThread(function()
    while true do
    local wait = 1000
        for k,v in pairs(Config.position) do
            local co = GetEntityCoords(PlayerPedId())
            local dist = Vdist(co.x, co.y, co.z, v.x, v.y, v.z)
            
            if dist <= 2 then 
                wait = 0                 
                if IsControlJustPressed(1,51) then                      
                    RefreshPlayerData()
                    openMenu()
                end            
            else 
                RageUI.CloseAll()
            end 
        end
        
    Citizen.Wait(wait)
    end
end) 
