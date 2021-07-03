-- This file is part of the SAMP.Lua project.
-- Licensed under the MIT License.
-- Copyright (c) 2016, FYP @ BlastHack Team <blast.hk>
-- https://github.com/THE-FYP/SAMP.Lua

local Vector3D = require "lib.vector3d"
local BitStreamIO = {}

BitStreamIO.bool = {
	write = function(bs, value)
		return raknetBitStreamWriteBool(bs, value)
	end
}

BitStreamIO.int8 = {
	write = function(bs, value)
		return raknetBitStreamWriteInt8(bs, value)
	end
}

BitStreamIO.int16 = {
	write = function(bs, value)
		return raknetBitStreamWriteInt16(bs, value)
	end
}

BitStreamIO.int32 = {
	write = function(bs, value)
		return raknetBitStreamWriteInt32(bs, value)
	end
}

BitStreamIO.float = {
	write = function(bs, value)
		return raknetBitStreamWriteFloat(bs, value)
	end
}

BitStreamIO.string8 = {
	write = function(bs, value)
		raknetBitStreamWriteInt8(bs, #value)
		raknetBitStreamWriteString(bs, value)
	end
}
BitStreamIO.string = {
	write = function(bs, value)
		raknetBitStreamWriteString(bs, value)
	end
}

BitStreamIO.string16 = {
	write = function(bs, value)
		raknetBitStreamWriteInt16(bs, #value)
		raknetBitStreamWriteString(bs, value)
	end
}

BitStreamIO.string32 = {
	write = function(bs, value)
		raknetBitStreamWriteInt32(bs, #value)
		raknetBitStreamWriteString(bs, value)
	end
}

BitStreamIO.bool8 = {
	write = function(bs, value)
		raknetBitStreamWriteInt8(bs, value == true and 1 or 0)
	end
}

BitStreamIO.bool32 = {
	write = function(bs, value)
		raknetBitStreamWriteInt32(bs, value == true and 1 or 0)
	end
}

BitStreamIO.int1 = {
	write = function(bs, value)
		raknetBitStreamWriteBool(bs, value ~= 0 and true or false)
	end
}

BitStreamIO.string256 = {
	write = function(bs, value)
		if #value >= 32 then
			raknetBitStreamWriteString(bs, value:sub(1, 32))
		else
			raknetBitStreamWriteString(bs, value .. string.rep("\0", 32 - #value))
		end
	end
}

BitStreamIO.encodedString2048 = {
	write = function(bs, value)
		raknetBitStreamEncodeString(bs, value)
	end
}

BitStreamIO.encodedString4096 = {
	write = function(bs, value)
		raknetBitStreamEncodeString(bs, value)
	end
}

BitStreamIO.compressedFloat = {
	write = function(bs, value)
		if value < -1 then
			value = -1
		elseif value > 1 then
			value = 1
		end
		raknetBitStreamWriteInt16(bs, (value + 1) * 32767.5)
	end
}

BitStreamIO.compressedVector = {
	write = function(bs, data)
		local x, y, z = data.x, data.y, data.z
		local magnitude = math.sqrt(x * x + y * y + z * z)
		raknetBitStreamWriteFloat(bs, magnitude)
		if magnitude > 0 then
			local writeCf = BitStreamIO.compressedFloat.write
			writeCf(bs, x / magnitude)
			writeCf(bs, y / magnitude)
			writeCf(bs, z / magnitude)
		end
	end
}

BitStreamIO.normQuat = {
	write = function(bs, value)
		local w, x, y, z = value[1], value[2], value[3], value[4]
		raknetBitStreamWriteBool(bs, w < 0)
		raknetBitStreamWriteBool(bs, x < 0)
		raknetBitStreamWriteBool(bs, y < 0)
		raknetBitStreamWriteBool(bs, z < 0)
		raknetBitStreamWriteInt16(bs, math.abs(x) * 65535)
		raknetBitStreamWriteInt16(bs, math.abs(y) * 65535)
		raknetBitStreamWriteInt16(bs, math.abs(z) * 65535)
		-- w is calculates on the target
	end
}

BitStreamIO.Int32Array3 = {
	write = function(bs, value)
		raknetBitStreamWriteInt32(bs, value.v[1])
		raknetBitStreamWriteInt32(bs, value.v[2])
		raknetBitStreamWriteInt32(bs, value.v[3])
	end
}

BitStreamIO.vector3d = {
	write = function(bs, value)
		raknetBitStreamWriteFloat(bs, value.x)
		raknetBitStreamWriteFloat(bs, value.y)
		raknetBitStreamWriteFloat(bs, value.z)
	end
}

BitStreamIO.vector2d = {
	write = function(bs, value)
		raknetBitStreamWriteFloat(bs, value.x)
		raknetBitStreamWriteFloat(bs, value.y)
	end
}

BitStreamIO.floatQuat = {
	write = function(bs, value)
		raknetBitStreamWriteFloat(bs, value[1])
		raknetBitStreamWriteFloat(bs, value[2])
		raknetBitStreamWriteFloat(bs, value[3])
		raknetBitStreamWriteFloat(bs, value[4])
	end
}

function bitstream_io_interface(field)
	return setmetatable(
		{},
		{
			__index = function(t, index)
				return BitStreamIO[index][field]
			end
		}
	)
end

BitStreamIO.bs_read = bitstream_io_interface("read")
BitStreamIO.bs_write = bitstream_io_interface("write")

return BitStreamIO
