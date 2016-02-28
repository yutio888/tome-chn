dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/therapeutics.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/smith.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/mechanical.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/explosive.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/electricity.lua")
dofile("data-chn123/objects/object_detail/orc_dlc/tinkers/chemistry.lua")
objects:addObjects({
	subtype = "bomb",
	enName = "Cave Detonator",
	chName = 	"洞穴炸弹",
	desc = [[该炸弹用于摧毁蒸汽巨人侵略克鲁克部落的通道，220回合引爆。]],
})
objects:addObjects({
	subtype = "bomb",
	enName = "Tower Detonator",
	chName = 	"炸弹",
	desc = [[炸弹，需安置于结构薄弱处，100回合引爆时间。]],
})
