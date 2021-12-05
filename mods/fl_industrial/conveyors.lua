--Aurailus, wsor, MIT
local nb_table = {
	{
		{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox1
		{-0.5, -0.4375, -0.5, -0.375, -0.3125, 0.5}, -- NodeBox2
		{0.375, -0.4375, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox3
	},
	{
		{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox1
		{-0.5, -0.4375, -0.5, -0.375, -0.3125, 0.5}, -- NodeBox2
		{0.375, -0.4375, -0.5, 0.5, -0.3125, -0.375}, -- NodeBox3
		{0.375, -0.4375, 0.375, 0.5, -0.3125, 0.5}, -- NodeBox4}
	},
	{
		{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox1
		{0.5, -0.4375, -0.5, 0.375, -0.3125, 0.5}, -- NodeBox2
		{-0.375, -0.4375, -0.5, -0.5, -0.3125, -0.375}, -- NodeBox3
		{-0.375, -0.4375, 0.375, -0.5, -0.3125, 0.5}, -- NodeBox4}
	},
	{
		{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox1
		{0.375, -0.4375, -0.5, 0.5, -0.3125, -0.375}, -- NodeBox3
		{0.375, -0.4375, 0.375, 0.5, -0.3125, 0.5}, -- NodeBox4}
		{-0.375, -0.4375, -0.5, -0.5, -0.3125, -0.375}, -- NodeBox3
		{-0.375, -0.4375, 0.375, -0.5, -0.3125, 0.5}, -- NodeBox4}
	}
}
local names = {
	{"", "farlands_conveyor_top.png"},
	{"_left", "farlands_conveyor_top_two.png^[transformR180"},
	{"_right", "farlands_conveyor_top_two.png"},
	{"_funnel", "[combine:16x256:0,0=farlands_conveyor_top_two.png:14,0=farlands_conveyor_top_two.png"}
}

for i = 1, 4 do
	minetest.register_node("fl_industrial:conveyor" .. names[i][1], {
		description = "Conveyor Belt",
		groups = {oddly_breakable_by_hand = 3, cracky = 3, choppy = 3, conveyor = 1},
		tiles = {
			{
				name = names[i][2],
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
			"farlands_conveyor_base.png",
			"farlands_conveyor_base.png",
			"farlands_conveyor_base.png",
			"farlands_conveyor_base.png",
			"farlands_conveyor_base.png",
		},
		drawtype = "nodebox",
		paramtype = "light",
		sunlight_propagates = true,
		node_box = {
			type = "fixed",
			fixed = nb_table[i]
		},
		paramtype2 = "facedir",
        collision_box = {
			type = "fixed",
			fixed = {{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}},
		},
        selection_box = {
            type = "fixed",
            fixed = {{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}},
		}
	})
end