local sf = require "sampfuncs"
local enc = require "encoding"
enc.default = "CP1251"
local u8 = enc.UTF8
local incoming_rpc = {}

incoming_rpc[sf.RPC_SCRSETPLAYERNAME] = {
    {"playerId", "int16"},
    {
        "nameLen",
        "int8",
        {
            {
                "Get Name Len",
                {"name"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "name",
        "string",
        {
            {
                "Get Name By ID",
                {"playerId"},
                function(val, data)
                    if sampIsPlayerConnected(data[1].v) then
                        val.v = sampGetPlayerNickname(data[1].v)
                    else
                        return {"Player doesn't connected", 3}
                    end
                end
            }
        }
    },
    {
        "success",
        "int8",
        {
            {
                "To change nick must be 1"
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERPOS] = {
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERPOSFINDZ] = {
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERHEALTH] = {
    {
        "health",
        "float",
        {
            {
                "Get Self Health",
                function(val)
                    val.v = getCharHealth(playerPed)
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRTOGGLEPLAYERCONTROLLABLE] = {
    {
        "freeze",
        "int8",
        {
            {
                "Unfreeze - 0\nFreeze - 1"
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRPLAYSOUND] = {
    {
        "soundId",
        "int32",
        {
            {
                [[
Name	ID
SOUND_CEILING_VENT_LAND	1002
SOUND_BONNET_DENT	1009
SOUND_WHEEL_OF_FORTUNE_CLACKER	1027
SOUND_SHUTTER_DOOR_START	1035
SOUND_SHUTTER_DOOR_STOP	1036
SOUND_PARACHUTE_OPEN	1039
SOUND_AMMUNATION_BUY_WEAPON	1052
SOUND_AMMUNATION_BUY_WEAPON_DENIED	1053
SOUND_SHOP_BUY	1054
SOUND_SHOP_BUY_DENIED	1055
SOUND_RACE_321	1056
SOUND_RACE_GO	1057
SOUND_PART_MISSION_COMPLETE	1058
SOUND_GOGO_TRACK_START	1062 (music)
SOUND_GOGO_TRACK_STOP	1063 (music)
SOUND_DUAL_TRACK_START	1068 (music)
SOUND_DUAL_TRACK_STOP	1069 (music)
SOUND_BEE_TRACK_START	1076 (music)
SOUND_BEE_TRACK_STOP	1077 (music)
SOUND_ROULETTE_ADD_CASH	1083
SOUND_ROULETTE_REMOVE_CASH	1084
SOUND_ROULETTE_NO_CASH	1085
SOUND_BIKE_PACKER_CLUNK	1095
SOUND_AWARD_TRACK_START	1097 (music)
SOUND_AWARD_TRACK_STOP	1098 (music)
SOUND_MESH_GATE_OPEN_START	1100
SOUND_MESH_GATE_OPEN_STOP	1101
SOUND_PUNCH_PED	1130
SOUND_AMMUNATION_GUN_COLLISION	1131
SOUND_CAMERA_SHOT	1132
SOUND_BUY_CAR_MOD	1133
SOUND_BUY_CAR_RESPRAY	1134
SOUND_BASEBALL_BAT_HIT_PED	1135
SOUND_STAMP_PED	1136
SOUND_CHECKPOINT_AMBER	1137
SOUND_CHECKPOINT_GREEN	1138
SOUND_CHECKPOINT_RED	1139
SOUND_CAR_SMASH_CAR	1140
SOUND_CAR_SMASH_GATE	1141
SOUND_OTB_TRACK_START	1142
SOUND_OTB_TRACK_STOP	1143
SOUND_PED_HIT_WATER_SPLASH	1144
SOUND_RESTAURANT_TRAY_COLLISION	1145
SOUND_SWEETS_HORN	1147
SOUND_MAGNET_VEHICLE_COLLISION	1148
SOUND_PROPERTY_PURCHASED	1149
SOUND_PICKUP_STANDARD	1150
SOUND_GARAGE_DOOR_START	1153
SOUND_GARAGE_DOOR_STOP	1154
SOUND_PED_COLLAPSE	1163
SOUND_SHUTTER_DOOR_SLOW_START	1165
SOUND_SHUTTER_DOOR_SLOW_STOP	1166
SOUND_RESTAURANT_CJ_PUKE	1169
SOUND_DRIVING_AWARD_TRACK_START	1183 (music)
SOUND_DRIVING_AWARD_TRACK_STOP	1184
SOUND_BIKE_AWARD_TRACK_START	1185 (music)
SOUND_BIKE_AWARD_TRACK_STOP	1186
SOUND_PILOT_AWARD_TRACK_START	1187 (music)
SOUND_PILOT_AWARD_TRACK_STOP	1188
SOUND_SLAP	1190
   ]]
            }
        }
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERWORLDBOUNDS] = {
    {"maxX", "float"},
    {"minX", "float"},
    {"maxY", "float"},
    {"minX", "float"}
}

incoming_rpc[sf.RPC_SCRGIVEPLAYERMONEY] = {
    {"money", "int32"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERFACINGANGLE] = {
    {
        "angle",
        "float",
        {
            {
                "Angle must be from 0 to 360\n"
            },
            {
                "Get Self Angle",
                function(val)
                    val.v = getCharHeading(playerPed)
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRRESETPLAYERMONEY] = {}
incoming_rpc[sf.RPC_SCRRESETPLAYERWEAPONS] = {}

incoming_rpc[sf.RPC_SCRGIVEPLAYERWEAPON] = {
    {"weaponId", "int32"},
    {"ammo", "int32"}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEPARAMSEX] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self VehicleID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"Seat In Car", 3}
                    end
                end
            }
        }
    },
    {
        "params_engine",
        "int8"
    },
    {
        "params_lights",
        "int8"
    },
    {
        "params_alarm",
        "int8"
    },
    {
        "params_doors",
        "int8"
    },
    {
        "params_bonnet",
        "int8"
    },
    {
        "params_boot",
        "int8"
    },
    {
        "params_objective",
        "int8"
    },
    {
        "params_unknown",
        "int8"
    },
    {
        "doors_driver",
        "int8"
    },
    {
        "doors_passenger",
        "int8"
    },
    {
        "doors_backleft",
        "int8"
    },
    {
        "doors_backright",
        "int8"
    },
    {
        "windows_driver",
        "int8"
    },
    {
        "windows_passenger",
        "int8"
    },
    {
        "windows_backleft",
        "int8"
    },
    {
        "windows_backright",
        "int8"
    }
}

incoming_rpc[sf.RPC_SCRCANCELEDIT] = {}

incoming_rpc[sf.RPC_SCRSETPLAYERTIME] = {
    {"hour", "int8"},
    {"minute", "int8"}
}
incoming_rpc[sf.RPC_SCRTOGGLECLOCK] = {
    {"state", "int8"}
}

incoming_rpc[sf.RPC_SCRWORLDPLAYERADD] = {
    {"playerId", "int16"},
    {"team", "in8"},
    {"model", "int32"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "rotation",
        "float",
        {
            {
                "Angle must be from 0 to 360\n"
            },
            {
                "Get Self Angle",
                function(val)
                    val.v = getCharHeading(playerPed)
                end
            }
        }
    },
    {
        "color",
        "int32"
    },
    {
        "fightingStyle",
        "int8"
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERSHOPNAME] = {
    {"shopname", "string256"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERSKILLLEVEL] = {
    {"playerId", "int16"},
    {"skill", "int32"},
    {"level", "int16"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERDRUNKLEVEL] = {
    {"drunkLevel", "int32"}
}

incoming_rpc[sf.RPC_SCRCREATE3DTEXTLABEL] = {
    {"id", "int16"},
    {"color", "int32"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            }
        }
    },
    {
        "distance",
        "float"
    },
    {
        "testLOS",
        "int8"
    },
    {
        "attachedPlayerId",
        "int16",
        {
            {
                "65535 - to not attach"
            }
        }
    },
    {
        "attachedVehicleId",
        "int16",
        {
            {
                "65535 - to not attach"
            }
        }
    },
    {
        "text",
        "encodedString4096"
    }
}

incoming_rpc[sf.RPC_SCRDISABLECHECKPOINT] = {}

incoming_rpc[sf.RPC_SCRSETRACECHECKPOINT] = {
    {"type", "int8"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "nextPosition",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "size",
        "float"
    }
}

incoming_rpc[sf.RPC_SCRDISABLERACECHECKPOINT] = {}
incoming_rpc[sf.RPC_SCRGAMEMODERESTART] = {}
incoming_rpc[sf.RPC_SCRPLAYAUDIOSTREAM] = {
    {
        "urlLen",
        "int8",
        {
            {
                "Get Url Len",
                {"url"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "url",
        "string"
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "radius",
        "float"
    },
    {
        "usePosition",
        "int8"
    }
}

incoming_rpc[sf.RPC_SCRSTOPAUDIOSTREAM] = {}
incoming_rpc[sf.RPC_SCRREMOVEBUILDINGFORPLAYER] = {
    {
        "modelId",
        "int32"
    },
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "radius",
        "float"
    }
}

incoming_rpc[sf.RPC_SCRSETOBJECTPOS] = {
    {"objectId", "int16"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETOBJECTROT] = {
    {"objectId", "int16"},
    {
        "rotation",
        "vector3d"
    }
}

incoming_rpc[sf.RPC_SCRDESTROYOBJECT] = {
    {"objectId", "int16"}
}

incoming_rpc[sf.RPC_SCRDEATHMESSAGE] = {
    {
        "killerId",
        "int16",
        {
            {
                "Get Self Id",
                function(val)
                    val.v = select(2, sampGetPlayerIdByCharHandle(playerPed))
                end
            }
        }
    },
    {
        "victimId",
        "int16",
        {
            {
                "Get Self Id",
                function(val)
                    val.v = select(2, sampGetPlayerIdByCharHandle(playerPed))
                end
            }
        }
    },
    {
        "weapon",
        "int8",
        {
            {
                "Get Weapon From Killer",
                {"killerId"},
                function(val, data)
                    local result, ped = sampGetCharHandleBySampPlayerId(data[1].v)
                    if result then
                        val.v = getCurrentCharWeapon(ped)
                    else
                        return {"Player doesn't streamed", 3}
                    end
                end
            },
            {
                "Get Weapon From Victim",
                {"victimId"},
                function(val, data)
                    local result, ped = sampGetCharHandleBySampPlayerId(data[1].v)
                    if result then
                        if ped == playerPed then
                            val.v = getCurrentCharWeapon(playerPed)
                        else 
                            val.v = getCurrentCharWeapon(ped)
                        end
                    else
                        return {"Player doesn't streamed", 3}
                    end
                end
            }
        }
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERMAPICON] = {
    {"iconId", "int8"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "type",
        "int8"
    },
    {
        "color",
        "int32"
    },
    {
        "style",
        "int8"
    }
}

incoming_rpc[sf.RPC_SCRREMOVEVEHICLECOMPONENT] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self VehicleID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest VehicleID",
                function(val)
                    local veh = storeClosestEntities(playerPed)
                    if doesVehicleExist(veh) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(veh))
                    else
                        return {"No closest vehicles", 3}
                    end
                end
            }
        }
    },
    {
        "componentId",
        "int16"
    }
}

incoming_rpc[sf.RPC_SCRUPDATE3DTEXTLABEL] = {
    {
        "textLabelId",
        "int16"
    }
}

incoming_rpc[sf.RPC_SCRCHATBUBBLE] = {
    {"playerId", "int16"},
    {"color", "int32"},
    {"distance", "float"},
    {"duration", "int32"},
    {
        "messageLen",
        "int8",
        {
            {
                "Get Len of Message",
                {"message"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "message",
        "string"
    }
}

incoming_rpc[sf.RPC_SCRSOMEUPDATE] = {
    {"time", "int32"}
}

incoming_rpc[sf.RPC_SCRSHOWDIALOG] = {
    {"dialogId", "int16"},
    {"style", "int8"},
    {
        "titleLen",
        "int8",
        {
            {
                "Get Len of Message",
                {"title"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "title",
        "string"
    },
    {
        "button1Len",
        "int8",
        {
            {
                "Get Len of Message",
                {"button1"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "button1",
        "string"
    },
    {
        "button2Len",
        "int8",
        {
            {
                "Get Len of Message",
                {"button2"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {
        "button2",
        "string"
    },
    {
        "text",
        "encodedString4096"
    }
}

incoming_rpc[sf.RPC_SCRDESTROYPICKUP] = {
    {"pickupId", "int32"} -- < TODO: Maybe int16?
}

incoming_rpc[sf.RPC_SCRLINKVEHICLETOINTERIOR] = {
    {
        "vehicleId",
        "int16",
        {
            {
                "Get Self VehicleID",
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest VehicleID",
                function(val)
                    local veh = storeClosestEntities(playerPed)
                    if doesVehicleExist(veh) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(veh))
                    else
                        return {"No closest vehicles", 3}
                    end
                end
            }
        }
    },
    {
        "interiorId",
        "int8"
    }
}

incoming_rpc[sf.RPC_SCRSETPLAYERARMOUR] = {
    {"armour", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERARMEDWEAPON] = {
    {"weaponId", "int32"} -- TODO: Maybe int16?
}


incoming_rpc[sf.RPC_SCRSETSPAWNINFO] = {
    {"team", "int8"},
    {"skin", "int32",
        {
            {
                "Get Self Skin",
                function(val)
                    val.v = getCharModel(playerPed)
                end
            }
        }
    },
    {"unk", "int8"},
    {
        "position",
        "vector3d",
        {
            {
                "Get Self Position",
                function(val)
                    val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
                end
            },
            {
                "Get Target Blip Position",
                function(val)
                    local result, x, y, z = getTargetBlipCoordinates()
                    if result then
                        val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                    else
                        return {"No Target Blip", 3}
                    end
                end
            }
        }
    },
    {
        "rotation",
        "float",
        {
            {
                "Get Self Heading",
                function(val)
                    val.v = getCharHeading(playerPed)
                end
            }
        }
    },
    {
        "weapons",
        "Int32Array3"
    },
    {
        "ammo",
        "Int32Array3"
    }
}


incoming_rpc[sf.RPC_SCRSETPLAYERTEAM] = {
    {"playerId", "int16"},
    {"team", "int8"}
}

incoming_rpc[sf.RPC_SCRPUTPLAYERINVEHICLE] = {
    {"vehicleId", "int16",
        {
            {
                "Get Self VehicleID", 
                function(val)
                    if isCharInAnyCar(playerPed) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                    else
                        return {"You are not in the car", 3}
                    end
                end
            },
            {
                "Get Nearest VehicleID",
                function(val)
                    local veh = storeClosestEntities(playerPed)
                    if doesVehicleExist(veh) then
                        val.v = select(2, sampGetVehicleIdByCarHandle(veh))
                    else
                        return {"No closest vehicles", 3}
                    end
                end
            }
        }
    },
    {
        "seatId",
        "int8"
    }  
}

incoming_rpc[sf.RPC_SCRREMOVEPLAYERFROMVEHICLE] = {}

incoming_rpc[sf.RPC_SCRSETPLAYERCOLOR] = {
    {"playerId", "int16"},
    {"color", "int32", {
        {
            "Get Player Color",
            {"playerId"},
            function(val, data)
                local id = data[1].v
                local self_id = select(2, sampGetPlayerIdByCharHandle(playerPed))
                if id == self_id then
                    val.v = sampGetPlayerColor(self_id)
                else 
                    if sampIsPlayerConnected(id) then
                        val.v = sampGetPlayerColor(id)
                    else
                        return {"Player not connected", 3}
                    end
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRDISPLAYGAMETEXT] = {
    {"style", "int32"},
    {"time", "int32"},
    {"textLen", "int32", {
        {
            "Get Text Len",
            {"text"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"text", "string"}
}

incoming_rpc[sf.RPC_SCRFORCECLASSSELECTION] = {}

incoming_rpc[sf.RPC_SCRATTACHOBJECTTOPLAYER] = {
    {"objectId", "int16"},
    {"playerId", "int16"},
    {"offsets", "vector3d"},
    {"rotation", "vector3d"}
}


incoming_rpc[sf.RPC_SCRSHOWMENU] = {
    {"menuId", "int8"}
}

incoming_rpc[sf.RPC_SCRHIDEMENU] = {
    {"menuId", "int8"}
}

incoming_rpc[sf.RPC_SCRCREATEEXPLOSION] = {
    {"position", "vector3d", {
        {
            "Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        }
    }},
    {"style", "int32"},
    {"radius", "float"}
}

incoming_rpc[sf.RPC_SCRSHOWPLAYERNAMETAGFORPLAYER] = {
    {"playerId", "int16"},
    {"show", "int8", {
        {
            "1 - Show\n0 - Hide"
        }
    }}
}

incoming_rpc[sf.RPC_SCRATTACHCAMERATOOBJECT] = {
    {"objectId", "int16"}
}

incoming_rpc[sf.RPC_SCRINTERPOLATECAMERA] = {
    {"setPos", "bool"},
    {"fromPos", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
    {"destPos", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
    {"time", "int32"},
    {"mode", "int8"}
}

incoming_rpc[sf.RPC_SCRGANGZONESTOPFLASH] = {
    {"zoneId", "int16"}
}

incoming_rpc[sf.RPC_SCRAPPLYANIMATION] = {
    {"playerId", "int16"},
    {"animLibLen", "int8", {
        {
            "Get AnimLib Len",
            {"animLib"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"animLib", "string"},
    {"animNameLen", "int8", {
        {
            "Get AnimName Len",
            {"animName"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"animName", "string"},
    {"loop", "bool"},
    {"lockX", "bool"},
    {"lockY", "bool"},
    {"freeze", "bool"},
    {"time", "int32"}
}

incoming_rpc[sf.RPC_SCRCLEARANIMATIONS] = {
    {"playerId", "int16"},
}


incoming_rpc[sf.RPC_SCRSETPLAYERSPECIALACTION] = {
    {"actionId", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERFIGHTINGSTYLE] = {
    {"playerId", "int16"},
    {"fightingStyle", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERVELOCITY] = {
    {"velocity", "vector3d"}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEVELOCITY] = {
    {"turn", "int8"},
    {"velocity", "vector3d"}
}

incoming_rpc[sf.RPC_SCRCLIENTMESSAGE] = {
    {"color", "int32"},
    {"textLen", "int32", {
        {
            "Get Text Len",
            {"text"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"text", "string"}
}

incoming_rpc[sf.RPC_SCRSETWORLDTIME] = {
    {"hour", "int8"}
}

incoming_rpc[sf.RPC_SCRCREATEPICKUP] = {
    {"id", "int32"},
    {"model", "int32"},
    {"pickupType", "int32"},
    {"position", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRMOVEOBJECT] = {
    {"objectId", "int16"},
    {"fromPos", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
    {"destPos", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
    {"speed", "float"},
    {"rotation", "vector3d"}
}

incoming_rpc[sf.RPC_SCRENABLESTUNTBONUSFORPLAYER] = {
    {"enable", "bool"}
}

incoming_rpc[sf.RPC_SCRTEXTDRAWSETSTRING] = {
    {"id", "int16"},
    {"textLen", "int16", {
        {
            "Get Text Len",
            {"text"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"text", "string"}
}

incoming_rpc[sf.RPC_SCRSETCHECKPOINT] = {
    {"postion", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
    {"radius", "float"}
}

incoming_rpc[sf.RPC_SCRGANGZONECREATE] = {
    {"zoneId", "int16"},
    {"squareStart", "vector2d"},
    {"squareEnd", "vector2d"},
    {"color", "int32"}
}

incoming_rpc[sf.RPC_SCRPLAYCRIMEREPORT] = {
    {"suspectId", "int16"},
    {"unk", "int32"},
    {"unk", "int32"},
    {"unk", "int32"},
    {"crime", "int32"},
    {"postion", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }},
}

incoming_rpc[sf.RPC_SCRGANGZONEDESTROY] = {
    {"zoneId", "int16"}
}

incoming_rpc[sf.RPC_SCRGANGZONEFLASH] = {
    {"zoneId", "int16"},
    {"color", "int32"}
}

incoming_rpc[sf.RPC_SCRSTOPOBJECT] = {
    {"objectId", "int16"}
}

incoming_rpc[sf.RPC_SCRSETNUMBERPLATE] = {
    {"vehicleId", "int16"},
    {"numberPlateLen", "int16", {
        {
            "Get NumberPlate Len",
            {"numberPlate"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"numberPlate", "string"}
}

incoming_rpc[sf.RPC_SCRTOGGLEPLAYERSPECTATING] = {
    {"toggle", "int32", {
        {
            "0 - Disable\n1 - Enable\nP.S: Maybe"
        }
    }}
}

incoming_rpc[sf.RPC_SCRPLAYERSPECTATEPLAYER] = {
    {"playerId", "int16"},
    {"camType", "int8"}
}

incoming_rpc[sf.RPC_SCRPLAYERSPECTATEVEHICLE] = {
    {"vehicleId", "int16"},
    {"camType", "int8"}
}


incoming_rpc[sf.RPC_SCRSETPLAYERWANTEDLEVEL] = {
    {"wantedLevel", "int8"}
}

incoming_rpc[sf.RPC_SCRTEXTDRAWHIDEFORPLAYER] = {
    {"textdrawId", "int16"}
}

incoming_rpc[sf.RPC_SCRSERVERJOIN] = {
    {"playerId", "int16"},
    {"color", "int32"},
    {"isNpc", "int8", {
        {
            "1 - Npc\n0 - Player"
        }
    }},
    {"nicknameLen", "int8", {
        {
            "Get Nickname Len",
            {"nickname"},
            function(val, data)
                val.v = string.len(u8:decode(data[1].v))
            end
        }
    }},
    {"nickname", "string"}
}

incoming_rpc[sf.RPC_SCRSERVERQUIT] = {
    {"playerId", "int16"},
    {"reason", "int8"} -- TODO: find reasons
}

incoming_rpc[sf.RPC_SCRREMOVEPLAYERMAPICON] = {
    {"iconId", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERAMMO] = {
    {"weaponId", "int8"},
    {"ammo", "int16"}
}


incoming_rpc[sf.RPC_SCRSETGRAVITY] = {
    {"gravity", "float", {
        {
            "0.007 or 0.0007 - default gravity"
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEHEALTH] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"SIT IN FUCKING CAR", 3}
                end
            end
        }
    }},
    {"health", "float"}
}

incoming_rpc[sf.RPC_SCRATTACHTRAILERTOVEHICLE] = {
    {"trailerId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"omg, maybe u sit in car?", 3}
                end
            end
        }
    }},
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"hm... car is not a car...", 3}
                end
            end
        }
    }}
}


incoming_rpc[sf.RPC_SCRDETACHTRAILERFROMVEHICLE] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"you don't love cars, yeah?", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETWEATHER] = {
    {"weatherId", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERSKIN] = {
    {"playerId", "int16"},
    {"skin", "int32", {
        {
            "Get Self Skin",
            function(val)
                val.v = getCharModel(playerPed)
            end
        },
        {
            "Get Player Skin",
            {"playerId"},
            function(val, data)
                local result, ped = sampGetCharHandleBySampPlayerId(data[1].v)
                if result then
                    val.v = getCharModel(ped)
                else 
                    return {"Player doesn't exist", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETPLAYERINTERIOR] = {
    {"interior", "int8"}
}

incoming_rpc[sf.RPC_SCRSETPLAYERCAMERAPOS] = {
    {"cameraPos", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Self Camera Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getActiveCameraCoordinates()
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETPLAYERCAMERALOOKAT] = {
    {"lookAt", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Self Camera Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getActiveCameraCoordinates()
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }}
    },
    {"cutType", "int8", {
        {
            "1 - CAMERA_MOVE\n2 - CAMERA_CUT"
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEPOS] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"sit in car or die", 3}
                end
            end
        }
    }},
    {"position", "vector3d", {
        {
            "Get Self Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getCharCoordinates(playerPed)
            end
        },
        {
            "Get Self Camera Position",
            function(val)
                val.v[1], val.v[2], val.v[3] = getActiveCameraCoordinates()
            end
        },
        {
            "Get Target Blip Position",
            function(val)
                local result, x, y, z = getTargetBlipCoordinates()
                if result then
                    val.v[1], val.v[2], val.v[3] = x, y, getGroundZFor3dCoord(x, y, z)
                else
                    return {"No Target Blip", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEZANGLE] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"sit in car or die", 3}
                end
            end
        }
    }},
    {"angle", "float", {
        {
            "From 0 to 360"
        },
        {
            "Get Self Heading",
            function(val)
                val.v = isCharInAnyCar(playerPed) and getCarHeading(storeCarCharIsInNoSave(playerPed)) or getCharHeading(playerPed)
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETVEHICLEPARAMSFORPLAYER] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"sit in car or die", 3}
                end
            end
        }
    }},
    {"objective", "int8"}, -- TODO: что за хуйня
    {"doorsLocked", "int8", {
        {
            "1 - Locked\n0 - Unlocked"
        }
    }}
}

incoming_rpc[sf.RPC_SCRSETCAMERABEHINDPLAYER] = {}


incoming_rpc[sf.RPC_SCRWORLDPLAYERREMOVE] = {
    {"playerId", "int16"}
}

incoming_rpc[sf.RPC_SCRWORLDVEHICLEREMOVE] = {
    {"vehicleId", "int16", {
        {
            "Get Self Vehicle ID",
            function(val)
                if isCharInAnyCar(playerPed) then
                    val.v = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(playerPed)))
                else
                    return {"sit in car or die", 3}
                end
            end
        }
    }}
}

incoming_rpc[sf.RPC_SCRWORLDPLAYERDEATH] = {
    {"playerId", "int16"}
}

return incoming_rpc