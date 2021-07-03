local sf = require "sampfuncs"
local enc = require "encoding"
enc.default = "CP1251"
local u8 = enc.UTF8
local outcoming_packets = {}

outcoming_packets[sf.PACKET_RCON_COMMAND] = {
    {
        "commandLen",
        "int32",
        {
            {
                "Calculate Length By String",
                {"command"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "command",
        "string"
    }
}

outcoming_packets[sf.PACKET_STATS_UPDATE] = {
    {"money", "int32"},
    {"drunkLevel", "int32"}
}

outcoming_packets[sf.PACKET_PLAYER_SYNC] = {
    {"leftRightKeys", "int16"},
    {"upDownKeys", "int16"},
    {"keysData", "int16"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            },
            {
                "Get Target Blip Coordinates",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"There is no tag on the map", 3}
                    end
                end
            }
        }
    },
    {
        "quaternion",
        "floatQuat",
        {
            {
                "Get Self Quaternion",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v[1], val.v[2], val.v[3], val.v[4] = getCharQuaternion(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "health",
        "int8",
        {
            {
                "Get Self Health",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCharHealth(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "armor",
        "int8",
        {
            {
                "Get Self Armour",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCharArmour(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "weapon",
        "int8",
        {
            {
                "Get Self Weapon",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCurrentCharWeapon(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {"specialAction", "int8"},
    {"moveSpeed", "vector3d"},
    {"surfingOffsets", "vector3d"},
    {"surfingVehicleId", "int16"},
    {
        "animationId",
        "int16",
        {
            {
                "Get Self AnimationID",
                function(val)
                    val.v = sampGetPlayerAnimationId(select(2, sampGetPlayerIdByCharHandle(playerPed)))
                end
            }
        }
    },
    {"animationFlags", "int16"}
}

outcoming_packets[sf.PACKET_VEHICLE_SYNC] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self Vehicle",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest Vehicle",
                function(val)
                    local vehicle = storeClosestEntities(playerPed)
                    if doesVehicleExist(vehicle) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(vehicle))
                    else
                        return {"Nearest vehicle doesn't exist", 3}
                    end
                end
            }
        }
    },
    {"leftRightKeys", "int16"},
    {"upDownKeys", "int16"},
    {"keysData", "int16"},
    {"quaternion", "floatQuat"},
    {"position", "vector3d"},
    {"moveSpeed", "vector3d"},
    {"vehicleHealth", "float"},
    {
        "playerHealth",
        "int8",
        {
            {
                "Get Self Health",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCharHealth(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "armor",
        "int8",
        {
            {
                "Get Self Armour",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCharArmour(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "weapon",
        "int8",
        {
            {
                "Get Self Weapon",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCurrentCharWeapon(playerPed)
                    else
                        return {"You dead. Noob!", 2}
                    end
                end
            }
        }
    },
    {
        "siren",
        "int8",
        {
            {
                "Get Self Car Siren",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = isCarSirenOn(storeCarCharIsInNoSave(playerPed)) and 1 or 0
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Selected Car Siren",
                {"vehicleId"},
                function(val, data)
                    local result, handle = sampGetCarHandleBySampVehicleId(data[1].v)
                    if result then
                        val.v = isCarSirenOn(handle) and 1 or 0
                    else
                        return {"Car doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "landingGearState",
        "int8"
    },
    {
        "trailerId",
        "int16"
    },
    {
        "trainSpeed",
        "float"
    },
    {
        "hydraThrustAngleX",
        "int16"
    },
    {
        "hydraThrustAngleY",
        "int16"
    }
}

outcoming_packets[sf.PACKET_AIM_SYNC] = {
    {"camMode", "int8"},
    {
        "camFront",
        "vector3d"
    },
    {
        "camPos",
        "vector3d",
        {
            {
                "Get Self Camera Coordinates",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getActiveCameraCoordinates()
                end
            }
        }
    },
    {"aimZ", "float"},
    {"camExtZoom", "int8"},
    {"weaponState", "int8"},
    {"unknown", "int8"}
}

outcoming_packets[sf.PACKET_BULLET_SYNC] = {
    {
        "targetType",
        "int8",
        {
            {
                [[
Air/Ground/Object - 0
Player - 1
Vehicle - 2
Dynamic Object - 3                    
                ]]
            }
        }
    },
    {"targetId", "int16"},
    {
        "origin",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    else
                        return {"You dead. Noob!", 3}
                    end
                end
            },
            {
                "Get Self Camera Position",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v[1], val.v[2], val.v[3] = getActiveCameraCoordinates()
                    else
                        return {"You dead. Noob!", 3}
                    end
                end
            }
        }
    },
    {
        "target",
        "vector3d",
        {
            {
                "Get Target Coordinates",
                {"targetId"},
                function(val, data)
                    local result, handle = sampGetCharHandleBySampPlayerId(data[1].v)
                    if result then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(handle)
                    else
                        return {"Target doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "center",
        "vector3d",
        {
            {
                "Random Offsets",
                function(val)
                    math.randomseed(os.time())
                    local x, y, z = math.random(), math.random(), math.random()
                    val.v[1], val.v[2], val.v[3] = x, y, z
                end
            }
        }
    },
    {
        "weapon",
        "int8",
        {
            {
                "Get Self Weapon",
                function(val)
                    if isPlayerPlaying(playerHandle) then
                        val.v = getCurrentCharWeapon(playerPed)
                    else
                        return {"You dead. Noob!", 3}
                    end
                end
            }
        }
    }
}

outcoming_packets[sf.PACKET_UNOCCUPIED_SYNC] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self Vehicle ID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest Vehicle ID",
                function(val)
                    local vehicle = storeClosestEntities(playerPed)
                    if doesVehicleExist(vehicle) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(vehicle))
                    else
                        return {"Vehicle doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "seatId",
        "int8"
    },
    {
        "roll",
        "vector3d"
    },
    {
        "direction",
        "vector3d"
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Coordinates",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(storeCarCharIsInNoSave(playerPed))
                    elseif not isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    elseif not isPlayerPlaying(playerHandle) then
                        return {"You are dead. Noob!", 3}
                    end
                end
            },
            {
                "Get Selected Car Coordinates",
                {"vehicleId"},
                function(val, data)
                    local result, handle = sampGetCarHandleBySampVehicleId(data[1].v)
                    if result then
                        val.v[1], val.v[2], val.v[3] = getCarCoordinates(handle)
                    else
                        return {"Car doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "moveSpeed",
        "vector3d"
    },
    {
        "turnSpeed",
        "vector3d"
    },
    {
        "vehicleHealth",
        "float",
        {
            {
                "Get Self Vehicle Health",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = getCarHealth(storeCarCharIsInNoSave(playerPed))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Selected Vehicle Health",
                {"vehicleId"},
                function(val, data)
                    local result, handle = sampGetCarHandleBySampVehicleId(data[1].v)
                    if result then
                        val.v = getCarHealth(handle)
                    else
                        return {"Car doesn't exist", 3}
                    end
                end
            }
        }
    }
}

outcoming_packets[sf.PACKET_TRAILER_SYNC] = {
    {
        "trailerId",
        "int16",
        {
            {
                "Get Self Vehicle ID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest Vehicle ID",
                function(val)
                    local vehicle = storeClosestEntities(playerPed)
                    if doesVehicleExist(vehicle) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(vehicle))
                    else
                        return {"Vehicle doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Coordinates",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(storeCarCharIsInNoSave(playerPed))
                    elseif not isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    elseif not isPlayerPlaying(playerHandle) then
                        return {"You are dead. Noob!", 3}
                    end
                end
            },
            {
                "Get Selected Car Coordinates",
                {"trailerId"},
                function(val, data)
                    local result, handle = sampGetCarHandleBySampVehicleId(data[1].v)
                    if result then
                        val.v[1], val.v[2], val.v[3] = getCarCoordinates(handle)
                    else
                        return {"Car doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "roll",
        "vector3d"
    },
    {
        "direction",
        "vector3d"
    },
    {
        "speed",
        "vector3d"
    },
    {
        "unknown",
        "int32"
    }
}

outcoming_packets[sf.PACKET_PASSENGER_SYNC] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self Vehicle ID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest Vehicle ID",
                function(val)
                    local vehicle = storeClosestEntities(playerPed)
                    if doesVehicleExist(vehicle) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(vehicle))
                    else
                        return {"Vehicle doesn't exist", 3}
                    end
                end
            }
        }
    },
    {
        "seatId",
        "int8"
    },
    {
        "currentWeapon",
        "int8",
        {
            {
                "Get Self Weapon",
                function(val)
                    val.v = getCurrentCharWeapon(playerPed)
                end
            }
        }
    },
    {
        "health",
        "int8",
        {
            {
                "Get Self Health",
                function(val)
                    val.v = getCharHealth(playerPed)
                end
            }
        }
    },
    {
        "armor",
        "int8",
        {
            {
                "Get Self Armour",
                function(val)
                    val.v = getCharArmour(playerPed)
                end
            }
        }
    },
    {
        "leftRightKeys",
        "int16"
    },
    {
        "upDownKeys",
        "int16"
    },
    {
        "keysData",
        "int16"
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Coordinates",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(storeCarCharIsInNoSave(playerPed))
                    elseif not isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    elseif not isPlayerPlaying(playerHandle) then
                        return {"You are dead. Noob!", 3}
                    end
                end
            },
            {
                "Get Selected Car Coordinates",
                {"vehicleId"},
                function(val, data)
                    local result, handle = sampGetCarHandleBySampVehicleId(data[1].v)
                    if result then
                        val.v[1], val.v[2], val.v[3] = getCarCoordinates(handle)
                    else
                        return {"Car doesn't exist", 3}
                    end
                end
            }
        }
    }
}

outcoming_packets[sf.PACKET_SPECTATOR_SYNC] = {
    {
        "leftRightKeys",
        "int16"
    },
    {
        "upDownKeys",
        "int16"
    },
    {
        "keysData",
        "int16"
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Coordinates",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(storeCarCharIsInNoSave(playerPed))
                    elseif not isCharInAnyCar(playerPed) then
                        val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                    elseif not isPlayerPlaying(playerHandle) then
                        return {"You are dead. Noob!", 3}
                    end
                end
            }
        }
    }
}

return outcoming_packets
