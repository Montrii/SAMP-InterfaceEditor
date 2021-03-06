--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CCollisionData'
shared.require 'RenderWare'

shared.ffi.cdef[[
	typedef struct CColModel
	{
		void						*vptr;
		RwBBox 					nBoundBox;
		RwSphere   			nBoundSphere;
		CCollisionData  *pColData;
	} CColModel;
]]

shared.validate_size('CColModel', 0x30)
