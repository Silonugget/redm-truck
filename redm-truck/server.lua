local audioHandles = {}

RegisterServerEvent('startEngineAudio')
AddEventHandler('startEngineAudio', function(primaryNetId, secondaryNetId)
    local startOptions = { url = "f15078start.mp3", volume = 29, filter = false, loop = false }
    audioHandles[primaryNetId] = exports.pmms:startByNetworkId(primaryNetId, startOptions)
end)

RegisterServerEvent('startIdleAudio')
AddEventHandler('startIdleAudio', function(secondaryNetId)
    local idleOptions = { url = "f15078idle.mp3", volume = 11, filter = false, loop = true }
    audioHandles[secondaryNetId] = exports.pmms:startByNetworkId(secondaryNetId, idleOptions)
end)

RegisterServerEvent('stopEngineAudio')
AddEventHandler('stopEngineAudio', function(primaryNetId, secondaryNetId)
    if audioHandles[primaryNetId] then
        exports.pmms:stop(audioHandles[primaryNetId])
    end
    if audioHandles[secondaryNetId] then
        exports.pmms:stop(audioHandles[secondaryNetId])
    end
end)

RegisterServerEvent('startRevAudio')
AddEventHandler('startRevAudio', function(primaryNetId)
    local revOptions = { url = "f15078rev.mp3", volume = 25, filter = false }
    audioHandles[primaryNetId] = exports.pmms:startByNetworkId(primaryNetId, revOptions)
end)

RegisterServerEvent('startAccelAudio')
AddEventHandler('startAccelAudio', function(primaryNetId)
    local accelOptions = { url = "f15078accel.mp3", volume = 15, filter = false, loop = false }
    audioHandles[primaryNetId] = exports.pmms:startByNetworkId(primaryNetId, accelOptions)
end)

RegisterServerEvent('startStopAudio')
AddEventHandler('startStopAudio', function(primaryNetId)
    local accelOptions = { url = "f15078stop.mp3", volume = 45, filter = false, loop = false }
    audioHandles[primaryNetId] = exports.pmms:startByNetworkId(primaryNetId, accelOptions)
end)

RegisterServerEvent('startDecelAudio')
AddEventHandler('startDecelAudio', function(primaryNetId)
    local accelOptions = { url = "f15078decel.mp3", volume = 25, filter = false, loop = false }
    audioHandles[primaryNetId] = exports.pmms:startByNetworkId(primaryNetId, accelOptions)
end)


