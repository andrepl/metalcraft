minetest.register_node('mithril:mineral_mithril', {
	description = "Mithril Ore",
	tiles = { "default_stone.png^mithril_mineral_mithril.png"},
	groups = { cracky = 3 },
	sounds = default.node_sound_stone_defaults(),
	drop = 'mithril_lump',
})

minetest.register_craftitem('mithril:mithril_lump', {
	description = "Mithril Lump",
	inventory_image = "mithril_mithril_lump.png",
})
minetest.register_alias('mithril_lump', 'mithril:mithril_lump')

minetest.register_craftitem('mithril:mithril_ingot', {
	description = "Mithril Ingot",
	inventory_image = "mithril_mithril_ingot.png",
})
minetest.register_alias('mithril_ingot', 'mithril:mithril_ingot')

minetest.register_node("mithril:mithril_block", {
	description = "Mithril Block",
	tiles = { 'mithril_mithril_block.png' },
	groups = { snappy = 1, bendy = 2, cracky = 1, melty = 2, level = 2 },
	sounds = default.node_sound_stone_defaults()
})
minetest.register_alias("mithril_block", "mithril:mithril_block")

minetest.register_craft({
	type = 'cooking',
	output = 'mithril:mithril_ingot',
	recipe = 'mithril:mithril_lump'
})

minetest.register_craft({
	output = "mithril:mithril_ingot 9",
	recipe = { { 'mithril:mithril_block' } }
})

minetest.register_craft({
	output = "mithril:mithril_block",
	recipe = { { 'mithril:mithril_ingot',  'mithril:mithril_ingot',  'mithril:mithril_ingot' },
			   { 'mithril:mithril_ingot',  'mithril:mithril_ingot',  'mithril:mithril_ingot' },
			   { 'mithril:mithril_ingot',  'mithril:mithril_ingot',  'mithril:mithril_ingot' } }
})

local mithril_chunk_size = 11
local mithril_ore_per_chunk = 1
local mithril_min_depth = -31000
local mithril_max_depth = -512

local oredef = {
	clust_scarcity = mithril_chunk_size * mithril_chunk_size * mithril_chunk_size,
	clust_num_ores = mithril_ore_per_chunk,
	clust_size = mithril_chunk_size,
	height_min = mithril_min_depth,
	height_max = mithril_max_depth,
	ore_type = "scatter",
	ore = "mithril:mineral_mithril",
	wherein = "default:stone",
}

minetest.register_ore(oredef)

local tool_pick = {
	description = "Mithril Pickaxe",
	damage_groups = { fleshy = 9 },
	full_punch_interval = 0.45,
	inventory_image = 'mithril_tool_mithrilpick.png',
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {
			cracky = {
				times = {
					[1] = 2.25,
					[2] = 0.55,
					[3] = 0.35
				},
				uses = 200,
				maxlevel= 1
			}
		}
	}
}

local tool_shovel = {
	description = "Mithril Shovel",
	damage_groups = { fleshy = 9 },
	full_punch_interval = 0.45,
	inventory_image = 'mithril_tool_mithrilshovel.png',
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {
			crumbly = {
				times = {
					[1] = 0.70,
					[2] = 0.35,
					[3] = 0.20
				},
				uses = 200,
				maxlevel= 1
			}
		}
	}
}

local tool_axe = {
	description = "Mithril Axe",
	damage_groups = { fleshy = 9 },
	full_punch_interval = 0.45,
	inventory_image = 'mithril_tool_mithrilaxe.png',
	tool_capabilities = {
		max_drop_level = 3,
		groupcaps = {
			choppy = {
				times = {
					[1] = 1.75,
					[2] = 0.45,
					[3] = 0.45
				},
				uses = 200,
				maxlevel= 1
			},
			fleshy = {
				times = {
					[2] = 0.95,
					[3] = 0.30
				},
				uses = 200,
				maxlevel= 1
			}
		}
	}
}
--
--tool_hoe = {
--	description = "Mithril Hoe",
--	inventory_image = 'mithril_tool_mithrilhoe.png',
--	tool_capabilities = {
--		max_drop_level = 3,
--		groupcaps = {
--			uses = 1000
--		}
--	},
--	on_use = function(itemstack, user, pointed_thing)
--		return hoe_on_use(itemstack, user, pointed_thing, 1000)
--	end,
--}

local tool_sword = {
	description = "Mithril Sword",
	inventory_image = 'mithril_tool_mithrilsword.png',
	tool_capabilities = {
		damage_groups = { fleshy = 9 },
		full_punch_interval = 0.45,
		max_drop_level = 3,
		groupcaps = {
			fleshy = {
				times = {
					[2] = 0.65,
					[3] = 0.25
				},
				uses = 200,
				maxlevel= 1
			},
			snappy = {
				times = {
					[2] = 0.70,
					[3] = 0.25
				},
				uses = 200,
				maxlevel= 1
			},
			choppy = {
				times = {
					[3] = 0.65
				},
				uses = 200,
				maxlevel= 0
			}
		}
	}
}

minetest.register_tool("mithril:pick_mithril", tool_pick)
minetest.register_alias("pick_mithril", "mithril:pick_mithril")
minetest.register_craft({
	output = "mithril:pick_mithril",
	recipe = {
		{'mithril:mithril_ingot', 'mithril:mithril_ingot', 'mithril:mithril_ingot' },
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_tool("mithril:axe_mithril", tool_axe)
minetest.register_alias("axe_mithril", "mithril:axe_mithril")
minetest.register_craft({
	output = "mithril:axe_mithril",
	recipe = {
		{'mithril:mithril_ingot', 'mithril:mithril_ingot' },
		{'mithril:mithril_ingot', 'group:stick' },
		{'', 'group:stick' },
	}
})

minetest.register_tool("mithril:shovel_mithril", tool_shovel)
minetest.register_alias("shovel_mithril", "mithril:shovel_mithril")
minetest.register_craft({
	output = "mithril:shovel_mithril",
	recipe = {
		{'mithril:mithril_ingot' },
		{'group:stick' },
		{'group:stick' },
	}
})

minetest.register_tool("mithril:sword_mithril", tool_sword)
minetest.register_alias("sword_mithril", "mithril:sword_mithril")
minetest.register_craft({
	output = "mithril:sword_mithril",
	recipe = {
		{'mithril:mithril_ingot'},
		{'mithril:mithril_ingot'},
		{'group:stick' },
	}
})
--
--minetest.register_tool("mithril:hoe_mithril", tool_hoe)
--minetest.register_alias("hoe_mithril", "mithril:hoe_mithril")
--minetest.register_craft({
--	output = "mithril:hoe_mithril",
--	recipe = {
--		{'mithril:mithril_ingot', 'mithril:mithril_ingot' },
--		{'', 'group:stick' },
--		{'', 'group:stick' },
--	}
--})

