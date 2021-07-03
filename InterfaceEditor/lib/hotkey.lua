local vkeys = require("vkeys")
local imgui = require("imgui")
local wm = require("lib.windows.message")

local module, list = {}, {}
local block = {[vkeys.VK_RETURN] = true, [vkeys.VK_T] = true, [vkeys.VK_F6] = true, [vkeys.VK_F8] = true}

lua_thread.create(function ()
	while true do
		wait(0)
		for k, v in ipairs(list) do
			if module.isKeyPressed(v.keys) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				v.callback(v.keys)
			end
		end
	end
end)

function module.getAllKeys()
	return list
end

function module.getKeyName(keys)
	local result = {}
	for k, v in ipairs(keys) do
		table.insert(result, vkeys.id_to_name(v))
	end
	return table.concat(result, " + ")
end

function module.getKeyPressed()
	local keys = {}
	local state = false
	for k, v in ipairs({VK_LCONTROL, VK_RCONTROL, VK_LSHIFT, VK_RSHIFT, VK_LMENU, VK_RMENU}) do
		if isKeyDown(v) then table.insert(keys, v) end
	end
	for k, v in pairs(vkeys) do
		if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT) and not state and not block[v] then
			table.insert(keys, v)
			state = true
		end
	end
	return state, keys
end

function module.isKeyPressed(keys)
	local count = 0
	for k, v in ipairs(keys) do
		if k == #keys and isKeyJustPressed(v) then count = count + 1
		elseif k ~= #keys and isKeyDown(v) then count = count + 1 end
	end
	if count == #keys then
		module.state = true
		return true
	else return false end
end

function module.isHotKeyDefined(keys)
	for k, v in ipairs(list) do if table.concat(v.keys) == table.concat(keys) then return true end end
	return false
end

function module.registerHotKey(keys, callback)
	if module.isHotKeyDefined(keys) then return false end
	table.insert(list, {keys = keys, callback = callback})
	return true
end

function module.unRegisterHotKey(keys)
	for k, v in ipairs(list) do
		if table.concat(v.keys) == table.concat(keys) then
			table.remove(list, k)
			return true
		end
	end
	return false
end

function module.HotKey(keys, size)
	local keys = keys or {}
	local bool, name = false
	local size = size or imgui.ImVec2(0, 0)
	if module.edit == 0 then
		bool = true
		keys.v = {}
		module.edit = nil
		name = "не указано"
	elseif module.edit == keys then
		local state, result = module.getKeyPressed()
		if state then
			bool = true
			keys.v = result
			module.edit = nil
			name = module.getKeyName(result)
		elseif #result > 0 then name = module.getKeyName(result)
		else name = os.time() % 2 == 0 and "не указано" or "" end
	else
		local key = module.getKeyName(keys)
		name = key:len() > 0 and key or "не указано"
	end
	imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
	if imgui.Button(name, size) and not module.edit then module.edit = keys end
	imgui.PopStyleColor(imgui.Col.WindowBg)
	return bool
end

addEventHandler("onWindowMessage", function(msg, wparam, lparam)
	if module.edit and msg == wm.WM_CHAR and (wparam == 84 or wparam == 116) then consumeWindowMessage(true, true)
	elseif msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
		if module.edit then
			if wparam == vkeys.VK_ESCAPE then
				module.edit = nil
				consumeWindowMessage(true, true)
			elseif wparam == vkeys.VK_BACK then
				module.edit = 0
				consumeWindowMessage(true, true)
			end
		end
	end
end)

return module