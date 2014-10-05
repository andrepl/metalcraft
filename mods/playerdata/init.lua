
local PLAYER_DATA_DIR = minetest.get_worldpath().."/playerdata"
os.execute("mkdir "..PLAYER_DATA_DIR)

local MAX_SAVED_PER_TICK = 10
local SAVE_INTERVAL = 30

local backend = 'json'

local _data = {}
local _dirty = {}

playerdata = {}

local function get_player_name(player)
	if type(player) ~= 'string' then player = player:get_player_name() end
	return player
end

playerdata.get = function (player, key)

	return _data[player][key]
end

playerdata.set = function (player, key, value)
	player = get_player_name(player)
	_data[player][key] = value
	_dirty[player] = os.time()
end

playerdata.set_dirty = function (player)
	player = get_player_name(player)
	_dirty[player] = os.time()
end

local function read_playerfile(player)
	player = get_player_name(player)
	local f = io.open(PLAYER_DATA_DIR..'/'..player..'.json', 'r')
	local data
	if f ~= nil then
		data = minetest.parse_json(f:read("*a"))
	end
	return data
end

local function save_playerfile(player)
	player = get_player_name(player)
	_dirty[player] = nil
	local f = io.open(PLAYER_DATA_DIR..'/'..player..'.json', 'w')
	f:write(minetest.write_json(_data[player]))
	f:close()
end

local function do_save(max)
	local due = os.time() - SAVE_INTERVAL
	local processed = 0
	for pname, pdata in pairs(_data) do
		-- Don't save too many in a single tick
		if max ~= nil and processed > max then
			return
		end
		if _dirty[pname] ~= nil then
			if _dirty[pname] < due then
				print(_dirty[pname].." < "..due.." saving "..pname)
				save_playerfile(pname)
			end
		end
	end
end

minetest.register_on_joinplayer(function (player)
	local name = player:get_player_name()
	_data[name] = read_playerfile(name)
	if _data[name] == nil then _data[name] = {} end
	if _data[name].first_login == nil then
		_data[name].first_login = os.time()
	end
	_data[name].last_login = os.time()
	_dirty[name] = os.time()
end)

minetest.register_on_shutdown(function ()
	do_save()
end)

minetest.register_globalstep(function (dtime)
	do_save(MAX_SAVED_PER_TICK)
end)

minetest.register_on_leaveplayer(function (player)
	save_playerfile(player)
end)

