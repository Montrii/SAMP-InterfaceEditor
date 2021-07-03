local sf = require "sampfuncs"
local enc = require "encoding"
enc.default = "CP1251"
local u8 = enc.UTF8
local outcoming_rpc = {}

outcoming_rpc[sf.RPC_CLICKPLAYER] = {
    {"playerId", "int16"},
    {"source", "int8"}
}

outcoming_rpc[sf.RPC_CLIENTJOIN] = {
    {"version", "int32"},
    {"mod", "int8"},
    {
        "nicknameLen",
        "int8",
        {
            {
                "Get Nickname Len",
                {"nickname"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"nickname", "string"},
    {"challengeResponse", "int32"},
    {
        "joinAuthKeyLen",
        "int8",
        {
            {
                "Get joinAuthKey Len",
                {"joinAuthKey"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"joinAuthKey", "string"},
    {
        "clientVerLen",
        "int8",
        {
            {
                "Get clientVer Len",
                {"clientVer"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"clientVer", "string"},
    {"unknown", "int32"}
}

outcoming_rpc[sf.RPC_ENTERVEHICLE] = {
    {"vehicleId", "int16"},
    {
        "passenger",
        "int8",
        {
            {
                "1 - Passenger\n0 - Driver"
            }
        }
    }
}

outcoming_rpc[sf.RPC_ENTEREDITOBJECT] = {
    {"type", "int32"},
    {"objectId", "int16"},
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
    }
}

outcoming_rpc[sf.RPC_SERVERCOMMAND] = {
    {
        "commandLen",
        "int32",
        {
            {
                "Get command Len",
                {"command"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"command", "string"}
}

outcoming_rpc[sf.RPC_SPAWN] = {}

outcoming_rpc[sf.RPC_DEATH] = {
    {"reason", "int8"},
    {"killerId", "int16"}
}

outcoming_rpc[sf.RPC_DIALOGRESPONSE] = {
    {
        "dialogId",
        "int16",
        {
            {
                "Get Current Dialog ID",
                function(val)
                    if sampIsDialogActive() then
                        val.v = sampGetCurrentDialogId()
                    else
                        return {"Dialog not active", 3}
                    end
                end
            }
        }
    },
    {
        "button",
        "int8",
        {
            {
                "1 - Enter\n0 - Exit"
            }
        }
    },
    {
        "listBoxId",
        "int16"
    },
    {
        "inputLen",
        "int8",
        {
            {
                "Get Current Dialog Input Len",
                function(val)
                    if sampIsDialogActive() then
                        val.v = string.len(sampGetCurrentDialogEditboxText())
                    else
                        return {"Dialog not active", 3}
                    end
                end
            },
            {
                "Get Input Len",
                {"input"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"input", "string"}
}

outcoming_rpc[sf.RPC_CLICKTEXTDRAW] = {
    {"textDrawId", "int16"}
}

outcoming_rpc[sf.RPC_SCMEVENT] = {
    {"vehicleId", "int32"}, -- TODO: Maybe int16
    {"param1", "int32"},
    {"param2", "int32"},
    {"event", "int32"} -- TODO: Maybe int8-int16
}

outcoming_rpc[sf.RPC_CHAT] = {
    {
        "messageLen",
        "int8",
        {
            {
                "Get Message Len",
                {"message"},
                function(val, data)
                    val.v = string.len(u8:decode(data[1].v))
                end
            }
        }
    },
    {"message", "string"}
}

outcoming_rpc[sf.RPC_CLIENTCHECK] = {
    {"unknown1", "int8"},
    {"unknown2", "int32"},
    {"unknown3", "int8"}
}

outcoming_rpc[sf.RPC_DAMAGEVEHICLE] = {
    {"vehicleId", "int16"},
    {"panelDmg", "int32"},
    {"doorDmg", "int32"},
    {"lights", "int8"},
    {"tires", "int8"}
}

outcoming_rpc[sf.RPC_GIVETAKEDAMAGE] = {
    {
        "take",
        "bool",
        {
            {
                "true - take damage\nfalse - give damage"
            }
        }
    },
    {
        "playerId",
        "int16"
    },
    {
        "damage",
        "float"
    },
    {
        "weapon",
        "int32"
    },
    {
        "bodyPart",
        "int32",
        {
            {
                "From 1 - 9"
            }
        }
    }
}

outcoming_rpc[sf.RPC_EDITATTACHEDOBJECT] = {
    {"response", "int32"},
    {"index", "int32"},
    {"model", "int32"},
    {"bone", "int32"},
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
    {"rotation", "vector3d"},
    {"scale", "vector3d"},
    {"color1", "int32"},
    {"color2", "int32"}
}

outcoming_rpc[sf.RPC_EDITOBJECT] = {
    {"playerObject", "bool"},
    {"objectId", "int16"},
    {"response", "int32"},
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
    {"rotation", "vector3d"}
}

outcoming_rpc[sf.RPC_SETINTERIORID] = {
    {"interior", "int8"}
}

outcoming_rpc[sf.RPC_MAPMARKER] = {
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
    }
}

outcoming_rpc[sf.RPC_REQUESTCLASS] = {
    {"class", "int32"}
}

outcoming_rpc[sf.RPC_REQUESTSPAWN] = {}

outcoming_rpc[sf.RPC_PICKEDUPPICKUP] = {
    {"pickupId", "int32"}
}

outcoming_rpc[sf.RPC_MENUSELECT] = {
    {"row", "int8"}
}

outcoming_rpc[sf.RPC_VEHICLEDESTROYED] = {
    {"vehicleId", "int16"}
}

outcoming_rpc[sf.RPC_MENUQUIT] = {}

outcoming_rpc[sf.RPC_EXITVEHICLE] = {
    {"vehicleId", "int16"}
}

outcoming_rpc[sf.RPC_UPDATESCORESPINGSIPS] = {}

return outcoming_rpc
