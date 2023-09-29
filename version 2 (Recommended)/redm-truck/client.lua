local truck = nil 

local function spawnTruck(c, engine)
    ExecuteCommand(Config.DeleteCommand)
	Citizen.Wait(10)
    local pc = GetEntityCoords(PlayerPedId())
    if c then 
      pc = c
    end
    local model, model2, wheelModel = GetHashKey("coach4"), GetHashKey("f15078"), GetHashKey("f15078wheel") -- change vehicle models here
    local attach = {-0.01, 0.5, -0.2, 0.0, 0.0, 0.0} 

    RequestModel(model)
    RequestModel(model2)
    RequestModel(wheelModel)
    
    while not HasModelLoaded(model) or not HasModelLoaded(model2) or not HasModelLoaded(wheelModel) do
      Citizen.Wait(5)
    end
	
	-- create vehicle based on hash key, set invisible and attach shell object
    local vehicle = CreateVehicle(model, pc.x + 2.0, pc.y, pc.z, (pc.h or 1.0), 1, 1, 0)
    Citizen.Wait(150)
    FreezeEntityPosition(vehicle, 1)
    SetEntityVisible(vehicle, 0)
    Citizen.Wait(150)
    local obj = CreateObject(model2, pc.x, pc.y, pc.z, 1, 1, 1)
    Citizen.Wait(300)
    AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0, 1, 1, 0, 0, 2)

   -- Initialization for rear wheels
    local rearWheels = {}
    local rearWheelOffsets = {
  { x = 0.95, y = -1.565, z = -0.41 },
  { x = -0.95, y = -1.565, z = -0.41 }
  }
  for _, offset in ipairs(rearWheelOffsets) do
  local x, y, z = table.unpack(GetEntityCoords(vehicle, false))
  local rearWheel = CreateObject(wheelModel, x + offset.x, y + offset.y, z + offset.z, 1, 1, 1)
  table.insert(rearWheels, rearWheel)
  local orientationAngle = (offset.x > 0) and 180.0 or 0.0  -- Flip if it's on the right side
  AttachEntityToEntity(rearWheel, vehicle, 0, offset.x, offset.y, offset.z, 0, 0, orientationAngle, 0, 1, 1, 0, 0, 2)
  end
  
   -- Initialization for front wheels
  local frontWheels = {}
  local frontWheelOffsets = {
  { x = 0.95, y = 1.82, z = -0.38 },
  { x = -0.95, y = 1.82, z = -0.38 }
  }
  for _, offset in ipairs(frontWheelOffsets) do
  local x, y, z = table.unpack(GetEntityCoords(vehicle, false))
  local frontWheel = CreateObject(wheelModel, x + offset.x, y + offset.y, z + offset.z, 1, 1, 1)
  table.insert(frontWheels, frontWheel)
  local orientationAngle = (offset.x > 0) and 180.0 or 0.0  -- Flip if it's on the right side
  AttachEntityToEntity(frontWheel, vehicle, 0, offset.x, offset.y, offset.z, 0, 0, orientationAngle, 0, 1, 1, 0, 0, 2)
  end

    -- Initialize rotation angle variable
  local currentRotationAngle = 0.0

    -- Initialize turning right and turning left variables
  local turningRight = false
  local turningLeft = false
  local currentTurnAngle = 0.0  -- The actual current turn angle
  local turnSmoothing = 20.0  -- The rate at which the turn angle changes (higher = faster)

    -- Update loop for turning front wheels based on keypress
  Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    
	  if truck then
      truck.intruck = IsPedInVehicle(PlayerPedId(), truck.vehicle, 1)

      if truck.intruck then
      if DoesEntityExist(vehicle) and frontWheels[1] and rearWheels[1] then	

      -- Check if "D" key is pressed or released
      if IsControlJustPressed(0, 0xB4E465B4) then
        turningLeft = true
      elseif IsControlJustReleased(0, 0xB4E465B4) then
        turningLeft = false
      end

      -- Check if "A" key is pressed or released
      if IsControlJustPressed(0, 0x7065027D) then
        turningRight = true
      elseif IsControlJustReleased(0, 0x7065027D) then
        turningRight = false
      end

      local vehicleSpeed = GetEntitySpeed(vehicle)  -- Get the speed of the vehicle
    -- Get the forward vector of the vehicle
   local forwardVector = GetEntityForwardVector(vehicle)

     -- Get the velocity vector of the vehicle
  local vx, vy, vz = table.unpack(GetEntityVelocity(vehicle))

     -- Calculate the dot product
  local dotProduct = forwardVector.x * vx + forwardVector.y * vy + forwardVector.z * vz

     -- Determine the direction multiplier based on the dot product
  local directionMultiplier = (dotProduct >= 0) and 1.0 or -1.0

    -- Modify the rotation speed increment based on the direction
  local rotSpeedIncrement = -3.0 * vehicleSpeed * directionMultiplier

      -- Decide the turn angle based on "D" and "A" keys
      local targetTurnAngle = 0.0
      if turningRight then
        targetTurnAngle = 30.0
      elseif turningLeft then
        targetTurnAngle = -30.0
      end
      
	        -- Smoothly interpolate towards the target turn angle
      currentTurnAngle = currentTurnAngle + (targetTurnAngle - currentTurnAngle) / turnSmoothing

      currentRotationAngle = currentRotationAngle + rotSpeedIncrement  -- Increment the current rotation angle
      
      for i, frontWheel in ipairs(frontWheels) do
        local offset = frontWheelOffsets[i]

        -- Determine orientation angle based on the side of the vehicle
        local orientationAngle = (offset.x > 0) and 180.0 or 0.0  -- Flip if it's on the right side

        -- Invert rotation angle if the wheel is on the right side
        local finalRotationAngle = (offset.x > 0) and -currentRotationAngle or currentRotationAngle

      -- In the AttachEntityToEntity call, replace 'turnAngle' with 'currentTurnAngle'
      AttachEntityToEntity(frontWheel, vehicle, 0, offset.x, offset.y, offset.z, finalRotationAngle, 0.0, orientationAngle + currentTurnAngle, 0, 1, 1, 0, 0, 2)
      end

      for i, rearWheel in ipairs(rearWheels) do
        local offset = rearWheelOffsets[i]

        -- Determine orientation angle based on the side of the vehicle
        local orientationAngle = (offset.x > 0) and 180.0 or 0.0  -- Flip if it's on the right side

        -- Invert rotation angle if the wheel is on the right side
        local finalRotationAngle = (offset.x > 0) and -currentRotationAngle or currentRotationAngle

        AttachEntityToEntity(rearWheel, vehicle, 0, offset.x, offset.y, offset.z - 0.04, finalRotationAngle, 0.0, orientationAngle, 0, 1, 1, 0, 0, 2)
      end
      
      -- Reset the rotation angle if it gets too large (optional)
      if currentRotationAngle >= 360.0 then
        currentRotationAngle = 0.0
          end
        end
       end
	  end
    end
  end)

  -- Create primary audio object
  local primaryAudio = CreateObject(GetHashKey("p_phonograph01x"), pc.x, pc.y, pc.z, true, true, true)
  AttachEntityToEntity(primaryAudio, vehicle, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
  NetworkRegisterEntityAsNetworked(primaryAudio)

  SetEntityVisible(primaryAudio, false)


   -- Create secondary audio object
  local secondaryAudio = CreateObject(GetHashKey("p_phonograph01x"), pc.x, pc.y, pc.z, true, true, true)
  AttachEntityToEntity(secondaryAudio, vehicle, 0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
  NetworkRegisterEntityAsNetworked(secondaryAudio)

  SetEntityVisible(secondaryAudio, false)

  -- Request exhaust model
  local exhaustModel = GetHashKey("p_cigarette01x")
  RequestModel(exhaustModel)
  while not HasModelLoaded(exhaustModel) do
    Citizen.Wait(5)
  end

  -- Create the exhaust object
  local exhaustOffset = { x = 0.6, y = -0.65, z = 0.0 }
  local x, y, z = table.unpack(GetEntityCoords(vehicle, false))
  local exhaust = CreateObject(exhaustModel, x + exhaustOffset.x, y + exhaustOffset.y, z + exhaustOffset.z, 1, 1, 1)

  if exhaust then
    print("Exhaust object created.")  -- Debugging statement
  end

  -- Attach the exhaust object to the vehicle
  AttachEntityToEntity(exhaust, vehicle, 0, exhaustOffset.x, exhaustOffset.y, exhaustOffset.z, 0.0, 0.0, 0.0, 0, 1, 0, 0, 0, 2)
      Citizen.Wait(50)

      local a = {
        vehicle = vehicle, 
        object = obj,
        engine = false,
        
        headlights = false,
        headlight_l = hobj2, 
        headlight_r = hobj3,
        headlight_b = hobj,
        intruck = false,
        curr_speed = 0,
        frontWheels = frontWheels,  
        rearWheels = rearWheels,    
        primaryAudio = primaryAudio, --start sound
        secondaryAudio = secondaryAudio, -- idle sound
        exhaust = exhaust
      }
      
      Citizen.Wait(50)
      truck = a
      
    FreezeEntityPosition(vehicle, 0)
    SetModelAsNoLongerNeeded(model)
    SetModelAsNoLongerNeeded(model2)
    SetModelAsNoLongerNeeded(wheelModel)
	Citizen.Wait(1)
	SetVehicleLights(vehicle, 1)
	
	     -- initialize lights and attach
	        local model3 = GetHashKey("p_steamerlight01x")
        RequestModel(model3)
        while not HasModelLoaded(model3) do
          Citizen.Wait(5)
        end
        hobj, hobj2, hobj3 = CreateObject(GetHashKey("p_stageshelllight_red01x"), pc.x, pc.y, pc.z - 3.0, 1, 1, 1), CreateObject(model3, pc.x, pc.y, pc.z - 2.0, 1, 1, 1), CreateObject(model3, pc.x, pc.y, pc.z, 1, 1, 1)
		        Citizen.Wait(100)
				
  local attaches = {
  [1] = {-0.5, -3.0, -1.2, -40.0, 0.0, (90.0 + 90) % 360, "Back"},
  [2] = {-0.8, 1.9, 0.5, -0.0, 0.0, (270.0 + 90) % 360, "Front Left"},
  [3] = {0.8, 1.9, 0.5, -0.0, 0.0, (270.0 + 90) % 360, "Front Right"},
  }

        Citizen.Wait(100)
        AttachEntityToEntity(hobj, obj, 0, attaches[1][1], attaches[1][2], attaches[1][3], attaches[1][4], attaches[1][5], attaches[1][6], 0, 0, 0, 0, 0, 2)
        AttachEntityToEntity(hobj2, obj, 0, attaches[2][1], attaches[2][2], attaches[2][3], attaches[2][4], attaches[2][5], attaches[2][6], 0, 0, 0, 0, 0, 2)
        AttachEntityToEntity(hobj3, obj, 0, attaches[3][1], attaches[3][2], attaches[3][3], attaches[3][4], attaches[3][5], attaches[3][6], 0, 0, 0, 0, 0, 2)
		SetEntityVisible(hobj, false)
		SetEntityVisible(hobj2, false)
		SetEntityVisible(hobj3, false)
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Function to delete only the truck.vehicle for basic locking

local function deletetruckVehicle()
  if truck and truck.vehicle then
    DeleteEntity(truck.vehicle)
  end
end

-- Register the "lock" command to trigger the function
RegisterCommand("lock", function()
  deletetruckVehicle()
end, false)
--------------------------------------------------------------------------------------------------------------------------------------------
-- invisibility De-Sync manual fix for players
local enterVehicleCounter = 0
local wasIntruck = false  

local function fixme()
    --  Get the player's current coordinates and state
    local player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(player, false))
    local isInVehicle = IsPedInAnyVehicle(player, false)
    local vehicle = nil

    if isInVehicle then
        vehicle = GetVehiclePedIsIn(player, false)
        TaskLeaveVehicle(player, vehicle, 0)       
    end 
    
    Citizen.Wait(700)  -- Wait to ensure the dismount is complete
	ExecuteCommand(Config.DeleteCommand)
	Citizen.Wait(500)

    -- Teleport the player to the new coordinates
    SetEntityCoords(player, -2749.08, -5218.31, -9.63, 0.0, 0.0, 0.0, false)
    Citizen.Wait(300)  -- Wait for 1.5 seconds to ensure the teleportation is complete

    -- Teleport the player back to their original coordinates
    SetEntityCoords(player, x, y, z, 0.0, 0.0, 0.0, false)
    Citizen.Wait(300)  -- Wait to ensure the teleportation is complete
    
    enterVehicleCounter = 0
    SetEntityVisible(player, 1)
end

RegisterCommand("fixme", function()
    fixme()
end, false)
--------------------------------------------------------------------------------------------------------------------------------------------
-- function that runs upon second entry that fixes invisibility De-Sync between players

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local isIntruckNow = (truck and truck.intruck) or false  

        if isIntruckNow and not wasIntruck then  -- If the player has just entered the vehicle
            enterVehicleCounter = enterVehicleCounter + 1  -- Increment the counter

            if enterVehicleCounter > 99999 then  -- If player has entered more than once
                Citizen.Wait(100)
                fixme()  -- Call the fixme function
                Citizen.Wait(1500)
                spawnTruck(c, engine) 
            end
        end
        wasIntruck = isIntruckNow  -- Update the flag for the next iteration
        Citizen.Wait(250)  
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
-- function and command that fixes invisibility De-Sync between players

local objectVisible = true  

local function toggleObjectVisibility()
  if truck and truck.object then
    -- Toggle visibility for the main truck object
    objectVisible = not objectVisible  -- Toggle the boolean
    SetEntityVisible(truck.object, objectVisible)

    -- Toggle visibility for the front wheels
    if truck.frontWheels then 
      for _, wheel in ipairs(truck.frontWheels) do  
        SetEntityVisible(wheel, objectVisible) 
      end
    end
    
    -- Toggle visibility for the back wheels
    if truck.rearWheels then 
      for _, wheel in ipairs(truck.rearWheels) do  
        SetEntityVisible(wheel, objectVisible)  
      end
    end
  end
end

RegisterCommand("fixtruck", function()
  toggleObjectVisibility()
end, false)
--------------------------------------------------------------------------------------------------------------------------------------------
-- Workaround function for invisibility De-Sync between players upon server join

local hasRun = false  -- Variable to track if the function has run for a player

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local vehicleCoords = GetEntityCoords(vehicle)  -- Replace 'vehicle' with your vehicle entity
    local players = GetActivePlayers()

    for i = 1, #players do
      local otherPlayerPed = GetPlayerPed(players[i])
      if otherPlayerPed ~= PlayerPedId() then  -- Exclude the local player
        local otherPlayerCoords = GetEntityCoords(otherPlayerPed)
        local distance = Vdist(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, otherPlayerCoords.x, otherPlayerCoords.y, otherPlayerCoords.z)

        if distance < 50.0 and not hasRun then		-- Change 50.0 to desired distance
		Citizen.Wait(9000)
          toggleObjectVisibility()  -- Run the function
		  Citizen.Wait(10)  -- Wait for 5 seconds

          toggleObjectVisibility()  -- Run the function the second time
	  
          hasRun = true  -- Set the flag to true
          Citizen.Wait(10000)  -- Wait for 100 seconds before the next cycle
          hasRun = false  -- Reset the flag
        end
      end
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
--- Still experiencing an invisibility issue when others drive so for now it blows everything up if they try

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if truck and truck.vehicle then
      local vehicle = truck.vehicle
      
      for i = 0, 32 do
        if NetworkIsPlayerActive(i) then
          local otherPed = GetPlayerPed(i)
          
          if otherPed ~= PlayerPedId() then
            if IsPedGettingIntoAVehicle(otherPed) then
              local foundVehicle = GetVehiclePedIsEntering(otherPed)
              
              if foundVehicle == vehicle then
                print("PedStealing.")
                
                local seat = GetSeatPedIsTryingToEnter(otherPed)
                
                if seat == -1 then
				ClearPedTasksImmediately(otherPed)

                   -- Trigger explosions
                 local x, y, z = table.unpack(GetEntityCoords(otherPed, false))
                  AddExplosion(x, y, z, 26, 1.0, true, false, 1.0)  -- Replace 26 with the actual integer value for EXP_TAG_DYNAMITE
                  Citizen.Wait(500)  -- Half a second delay
                  AddExplosion(x, y, z, 3, 1.0, true, false, 1.0)  -- Replace 3 with the actual integer value for EXP_TAG_MOLOTOV
                  Citizen.Wait(500)  -- Half a second delay
                  AddExplosion(x, y, z, 1, 1.0, true, false, 1.0)  -- Replace 1 with the actual integer value for EXP_TAG_GRENADE
                else
                  TaskEnterVehicle(otherPed, vehicle, -1, seat, 1.0, 1, 0)
                end
              end
            end
          end
        end
      end
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
-- Function to fix visibility issue when car is driven in water

local wasInWater = false

-- Function to handle the vehicle when it's in water
local function handleVehicleInWater()
    if truck and truck.vehicle then
        SetEntityVisible(truck.vehicle, true) -- Make vehicle visible
        wasInWater = true
    end
end

-- Main function to check vehicle's position and call appropriate handlers
local function checkVehicleInWater()
    if truck and truck.vehicle then
        if IsEntityInWater(truck.vehicle) then
            handleVehicleInWater()
        end
    end
end

RegisterCommand("waterfix", function()
    handleVehicleInWater()
end, false)

Citizen.CreateThread(function()
    while true do
        checkVehicleInWater()
        Citizen.Wait(500) -- Check every half second
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
--- ANIMATION TO ENTER DRIVER SEAT PROPER USING CLONE

local clonePed = nil

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)

    if DoesEntityExist(vehicle) and vehicle == truck.vehicle and not DoesEntityExist(clonePed) then
      Citizen.CreateThread(function()
        Citizen.Wait(2)
        SetEntityVisible(player, false, false)
      end)

      -- Create a clone of the player a few feet behind the vehicle
      local cloneCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.0, 0.0)
      clonePed = ClonePed(player, GetEntityHeading(player), false, true)
      SetEntityCoordsNoOffset(clonePed, cloneCoords.x, cloneCoords.y, cloneCoords.z, true, true, true)
      
      -- Start the scenario for the cloned ped
      RequestAnimDict("script_re@check_point@small_cart")
      while not HasAnimDictLoaded("script_re@check_point@small_cart") do
        Citizen.Wait(100)
      end

      -- Play the animation
      TaskPlayAnim(
        clonePed, 
        "script_re@check_point@small_cart", 
        "int_loop_driver", 
        8.0, -- blendInSpeed
        1.0, -- blendOutSpeed
        -1, -- duration
        1, -- flag (loop)
        0.1, -- playbackRate
        0, -- lockX
        0, -- lockY
        0  -- lockZ
      )

      -- Adjust the attachment parameters
      local xOffset = -0.48
      local yOffset = 0.17
      local zOffset = 0.43
      local xRotation = 20.0
      local yRotation = 20.0
      local zRotation = 0.0
      AttachEntityToEntity(clonePed, vehicle, 0, xOffset, yOffset, zOffset, xRotation, yRotation, zRotation, false, false, false, false, 2, true)
      SetEntityVisible(clonePed, false, false)

      -- Start another thread to handle clone visibility with a delay
      Citizen.CreateThread(function()
          Citizen.Wait(700)
          SetEntityVisible(clonePed, true, false)
      end)
    elseif (not DoesEntityExist(vehicle) or vehicle ~= truck.vehicle) and DoesEntityExist(clonePed) then
      -- Make the player visible again
      SetEntityVisible(player, true, false)

      -- Delete the clone
      DeleteEntity(clonePed)
      clonePed = nil
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function(_, args)
  if Config.SpawnCommand then 
    spawnTruck(c, engine)
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.ResetCommand, function(_, args)
  if truck then 
    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(truck.vehicle))
    if dist < 4.0 then 
      SetEntityRotation(truck.vehicle, 0.0, 0.0, 0.0, 2, 1)
    end
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.DeleteCommand, function(_, args)
    if truck then 
      -- Delete the vehicle and its associated parts
      DeleteEntity(truck.vehicle)
      DeleteEntity(truck.headlight_l)
      DeleteEntity(truck.headlight_r)
      DeleteEntity(truck.headlight_b)
      DeleteEntity(truck.object)
	  DeleteEntity(hobj)
	  DeleteEntity(hobj2)
	  DeleteEntity(hobj3)
	  DeleteEntity(truck.exhaust)
	  TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)
	  Citizen.Wait(69)
        DeleteEntity(truck.primaryAudio)
        DeleteEntity(truck.secondaryAudio)
      -- Delete the front wheels
      if truck.frontWheels then
        for _, frontWheel in ipairs(truck.frontWheels) do
          DeleteEntity(frontWheel)
        end
      end
      -- Delete the rear wheels
      if truck.rearWheels then
        for _, rearWheel in ipairs(truck.rearWheels) do
          DeleteEntity(rearWheel)
        end
      end
      -- Clear the truck data
      truck = nil
	  end
  end)
--------------------------------------------------------------------------------------------------------------------------------------------
--- Engine start and stop function on key press - key in config default is ALT

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(10)
        
        if truck then  
            if truck.intruck then  

                local vehicleEntity = GetVehiclePedIsIn(PlayerPedId())
				
                
                -- Get the Network IDs for the primary and secondary audio objects
                 primaryAudioNetId = NetworkGetNetworkIdFromEntity(truck.primaryAudio)
                 secondaryAudioNetId = NetworkGetNetworkIdFromEntity(truck.secondaryAudio)
                
                 if IsControlPressed(0, Config.Engine) then
                 if not truck.engine then  -- If the engine is not on                    if not truck.engine then  -- If the engine is not on
                        print("engine on")                       
                        -- Notify the server to start the start-up sound on the primary audio object
                        TriggerServerEvent('startEngineAudio', primaryAudioNetId)                        
                        -- Enable the truck engine
                        SetVehicleEngineOn(vehicleEntity, 1, 1)
                        -- Citizen.Wait for the start-up sound to finish (assuming it's around 4 seconds long)
                        Citizen.Wait(3800)                        
                        -- Notify the server to start the idle sound on the secondary audio object
                        TriggerServerEvent('startIdleAudio', secondaryAudioNetId)						
						Citizen.Wait(1900)
						TriggerServerEvent('stopEngineAudio', primaryAudioNetId)
						-- lights						
								SetEntityVisible(hobj, true)
		                    SetEntityVisible(hobj2, true)
		                 SetEntityVisible(hobj3, true)
						 Citizen.Wait(3800)
						 SetEntityVisible(hobj, false)
						 
                    else  -- If the engine is already on
                        print("engine off")                       
                        -- Notify the server to stop the sounds
                        TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)
                        -- Disable the truck engine
                        SetVehicleEngineOn(vehicleEntity, 0, 0)						
						--- lights off
								SetEntityVisible(hobj, false)
		                SetEntityVisible(hobj2, false)
		                SetEntityVisible(hobj3, false)
		                 TriggerServerEvent('startStopAudio', primaryAudioNetId)
		                Citizen.Wait(2000)
		                TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)
                    end               
                    -- Toggle the engine state
                    truck.engine = not truck.engine					                   
                    Citizen.Wait(1200)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
---------------- function for brake light
Citizen.CreateThread(function()
    local isSKeyPressed = false  -- Variable to track if "S" key is pressed
    
    while true do
        Citizen.Wait(10)
        
        -- Check if the "S" key is pressed (0xD27782E3 is the control code for "S" key)
        if IsControlPressed(0, 0xD27782E3) then
            if not isSKeyPressed then
                isSKeyPressed = true
                
                -- Make hobj visible here
                SetEntityVisible(hobj, true)
            end
        else
            if isSKeyPressed then
                isSKeyPressed = false
                
                -- Hide hobj when "S" key is released
                SetEntityVisible(hobj, false)
            end
        end
    end
end)

--------------------------------------------------------------------------------------------------------------------------------------------
-- function checking and disabling the engine when vehicle cannot be  driven

Citizen.CreateThread(function()
    while true do  
        Citizen.Wait(2000)         
        if truck then  
            local vehicleEntity = truck.vehicle  
            -- Check if the vehicle is drivable
            local isDriveable = IsVehicleDriveable(vehicleEntity, false, false)
            -- Check if the engine health is too low or if the vehicle is not drivable
            if not isDriveable and truck.engine then
                print("Vehicle is not driveable or engine is destroyed, turning off.")

                -- Notify the server to stop the sounds
                TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)

                -- Disable the truck engine
                SetVehicleEngineOn(vehicleEntity, 0, 0)

                -- Turn off lights
                SetEntityVisible(hobj, false)
                SetEntityVisible(hobj2, false)
                SetEntityVisible(hobj3, false)
				Citizen.Wait(200)

                -- Notify server to stop other sounds if any
                TriggerServerEvent('startStopAudio', primaryAudioNetId)
                Citizen.Wait(2000)
                TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)

                -- Update engine state
                truck.engine = false
            end
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
-- Audio functions using PMMS

local isRevAudioPlaying = false
local isAccelAudioPlaying = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)  
        if truck and truck.intruck and truck.engine then  

            -- Handle rev audio
            if IsControlJustReleased(0, 0xE30CD707) then  -- 'r' is pressed
                if not isRevAudioPlaying then  -- Check the flag before starting the audio
                    isRevAudioPlaying = true
                    TriggerServerEvent('startRevAudio', primaryAudioNetId)
                    Citizen.Wait(3000)
                    TriggerServerEvent('stopEngineAudio', primaryAudioNetId)
                    isRevAudioPlaying = false  -- Reset the flag
                end
            end

            -- Handle accel audio
            if IsControlPressed(0, 0x8FFC75D6) then  -- 'Shift' is pressed
                if not isAccelAudioPlaying then  -- Check the flag before starting the audio
                    isAccelAudioPlaying = true
                    TriggerServerEvent('startAccelAudio', primaryAudioNetId)
                end
            elseif IsControlJustReleased(0, 0x8FFC75D6) then  -- 'Shift' is released
                TriggerServerEvent('stopEngineAudio', primaryAudioNetId)
                isAccelAudioPlaying = false  -- Reset the flag
				Citizen.Wait(420)
				TriggerServerEvent('startDecelAudio', primaryAudioNetId)
				Citizen.Wait(1600)
				TriggerServerEvent('stopEngineAudio', primaryAudioNetId)
            end

            -- Stop engine audio if neither 'W' nor 'Shift' are pressed
            if not IsControlPressed(0, 0x8FD015D8) and not IsControlPressed(0, 0x8FFC75D6) then
                if isRevAudioPlaying or isAccelAudioPlaying then  -- Check if either audio is currently playing
                    TriggerServerEvent('stopEngineAudio', primaryAudioNetId)
                    isRevAudioPlaying = false  -- Reset the flag
                    isAccelAudioPlaying = false  
                end
            end
        end  
        Citizen.Wait(10)  
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
--- Exhaust smoke effect function 

local new_ptfx_dictionary = "core"
local new_ptfx_name = "ent_amb_smoke_cabin"
local is_particle_effect_active = false
local current_ptfx_dictionary = new_ptfx_dictionary
local current_ptfx_name = new_ptfx_name
local current_ptfx_handle_id = false
local ptfx_offcet_x = 0.55
local ptfx_offcet_y = -1.7
local ptfx_offcet_z = 0.09
local ptfx_rot_x = 0.0
local ptfx_rot_y = 0.0
local ptfx_rot_z = 0.0
local ptfx_scale = 0.5
local ptfx_axis_x = 0
local ptfx_axis_y = 0
local ptfx_axis_z = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)             
        if truck and truck.intruck then                        
            local vehicleEntity = GetVehiclePedIsIn(PlayerPedId())                       
            if truck.engine then  -- If the engine is on               
                if not is_particle_effect_active then
                    current_ptfx_dictionary = new_ptfx_dictionary
                    current_ptfx_name = new_ptfx_name
                    if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
                        Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
                        local counter = 0
                        while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                            Citizen.Wait(0)
                        end
                    end
                    if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
                        Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset
                        current_ptfx_handle_id = Citizen.InvokeNative(0x8F90AB32E1944BDE,current_ptfx_name,truck.exhaust,ptfx_offcet_x,ptfx_offcet_y,ptfx_offcet_z,ptfx_rot_x,ptfx_rot_y,ptfx_rot_z,ptfx_scale,ptfx_axis_x,ptfx_axis_y,ptfx_axis_z) -- StartNetworkedParticleFxLoopedOnEntity
                        is_particle_effect_active = true
                    else
                        print("cant load ptfx dictionary!")
                    end
                end
            else  -- If the engine is off               
                if is_particle_effect_active then  -- If the particle effect is active
                    if current_ptfx_handle_id then
                        if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                            Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false)   -- RemoveParticleFx
                        end
                    end
                    current_ptfx_handle_id = false
                    is_particle_effect_active = false
                end
            end
        else
            Citizen.Wait(1000)  
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
--- Speedometer and Engine Key sprite function 

Citizen.CreateThread(function()
  local color1, color2 = {126,0,0, 200}, {126,0,0, 200}
  while true do
    Citizen.Wait(5)
    if truck then     
      if truck.intruck then
        local speedMetersPerSecond = GetEntitySpeed(truck.vehicle)
        local speedMPH = speedMetersPerSecond * 2.23694
        local curr_speed = string.format("%.1f", speedMPH) -- formatted speed       
        if truck and truck.engine then
          color2 = {0,126,0, 200}
        else
          color2 = {126,0,0, 200}
        end
        if truck and truck.headlights then
          color1 = {0,126,0, 200}
        else
          color1 = {126,0,0, 200}
        end

        -- Text drawing logic
        SetTextColor(126,0,0, 215)
        SetTextScale(0.35,0.35)
        SetTextFontForCurrentCommand(0)
        SetTextCentre(1)
        local str = CreateVarString(10, "LITERAL_STRING", curr_speed.."mph", Citizen.ResultAsLong())
        DisplayText(str,0.46,0.9)
        DrawSprite("hud_textures", "gang_savings", 0.53, 0.91, 0.04, 0.04, 0.1, color2[1], color2[2], color2[3], color2[4], 0)
      end
    else
      Citizen.Wait(800)
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    if truck then 
        -- Delete the vehicle and its associated parts
        DeleteEntity(truck.vehicle)
        DeleteEntity(truck.headlight_l)
        DeleteEntity(truck.headlight_r)
        DeleteEntity(truck.headlight_b)
        DeleteEntity(truck.object)
		DeleteEntity(truck.headlight_b)
		DeleteEntity(truck.headlight_l)
		DeleteEntity(truck.headlight_r)
			  DeleteEntity(hobj)
	  DeleteEntity(hobj2)
	  DeleteEntity(hobj3)
	  DeleteEntity(truck.exhaust)
	     TriggerServerEvent('stopEngineAudio', primaryAudioNetId, secondaryAudioNetId)		
        if truck.primaryAudio then
          DeleteEntity(truck.primaryAudio)
        end
        if truck.secondaryAudio then
          DeleteEntity(truck.secondaryAudio)
        end       
        -- Delete the front wheels
        if truck.frontWheels then
          for _, frontWheel in ipairs(truck.frontWheels) do
            DeleteEntity(frontWheel)
          end
        end
        -- Delete the rear wheels
        if truck.rearWheels then
          for _, rearWheel in ipairs(truck.rearWheels) do
            DeleteEntity(rearWheel)
          end
        end   
        -- Clear the truck data
        truck = nil
      end
    end)