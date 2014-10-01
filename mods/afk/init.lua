local _afk = {}
local _last_input = {}
local _last_look = {}

local cjson = require "cjson"

local AUTO_AFK_AFTER = 60
local KICK_AFTER = 600

function is_afk(player)
	return _afk[player:get_player_name()] ~= nil
end

function set_afk(player, afk)
	if not afk then
		minetest.chat_send_all("* " .. player:get_player_name() .. " is no longer AFK.")
		_afk[player:get_player_name()] = nil
	else
		minetest.chat_send_all("* " .. player:get_player_name() .. " is now AFK.")
		_afk[player:get_player_name()] = os.time()
	end
end

local function _any(tbl)
	for k, v in pairs(tbl) do
		if v then return true end
	end
	return false
end

minetest.register_on_joinplayer(function (player)
	_last_input[player:get_player_name()] = os.time()
end)

minetest.register_on_leaveplayer(function (player)
	local name = player:get_player_name()
	_last_input[name] = nil
	_last_look[name] = nil
	_afk[name] = nil;
end)

function vectors_equal(va, vb)
	if (va == nil) ~= (vb == nil) then
		return false
	end
	if va ~= nil then
		return va.x == vb.x and va.y == vb.y and va.z == vb.z
	end
	return true
end

minetest.register_privilege("afk", {
	description = "Allow using the /afk command",
	give_to_singleplayer = true
})

minetest.register_chatcommand("afk", {
	params = "",
	description = "toggle AFK",
	privs = {afk=true},
	func = function (name, param)
		local player = minetest.get_player_by_name(name)
		set_afk(player, not is_afk(player))
	end
})

minetest.register_globalstep(function (dtime)
	now = os.time()
	for i, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local look = player:get_look_dir()
		if not vectors_equal(look, _last_look[name]) then
			_last_look[name] = look
			_last_input[name] = now
			if _afk[name] ~= nil then
				set_afk(player, false)
			end
		end
		if _any(player:get_player_control()) then
			_last_input[name] = now
			if _afk[name] ~= nil then
				set_afk(player, false)
			end
		elseif _afk[name] == nil and (_last_input[name] ~= nil) and (now - _last_input[name]) > AUTO_AFK_AFTER then
			set_afk(player, true)
			_afk[name] = _last_input[name]
		end
		if KICK_AFTER > 0 and _afk[name] and now - _last_input[name] > KICK_AFTER then
			minetest.kick_player(player:get_player_name(), "AFK")
		end
	end
end)
