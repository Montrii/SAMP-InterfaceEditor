local root_dir = variables.LUA_DIR:sub(1, -8)

rocks_subdir = 'rocks-'..lua_version

rocks_trees = {
	{
		name = [[lib]],
		root = root_dir..[[\luarocks\usertree]],
		bin_dir = root_dir..[[\luarocks\usertree\bin]],
		lib_dir = root_dir..[[\lib]],
		lua_dir = root_dir..[[\lib]],
	},
	{
		name = [[libstd]],
		root = root_dir..[[\luarocks\systree]],
		bin_dir = root_dir..[[\luarocks\systree\bin]],
		lib_dir = root_dir..[[\libstd]],
		lua_dir = root_dir..[[\libstd]],
	},
}

variables = {
	MSVCRT = 'MSVCR80',
	LUALIB = 'lua51.lib',
}

verbose = false   -- set to 'true' to enable verbose output
deps_mode = 'order'
fs_use_modules = true
