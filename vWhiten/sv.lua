ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('kWhiten') 
AddEventHandler('kWhiten', function(Money, BlackMoney)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local GetBlackMoney = xPlayer.getAccount('black_money').money
    if Money <= GetBlackMoney then
        xPlayer.removeAccountMoney('black_money', BlackMoney)
        xPlayer.addMoney(Money)
        TriggerClientEvent('esx:showNotification', source, "J'ai blanchi ~r~"..BlackMoney.."$~s~ prends ~g~"..Money.."$ propre~s~ et balance pas au flics !")
    end
end)