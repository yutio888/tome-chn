questCHN["The Deconstruction of Falling Stars"] = {
	name = "群星的陨落",
	description = function(desc)
		desc = desc:gsub([[The people of the sunwall have lingered on this land for too long and now they are spreading their control to all the mainland. This must not be allowed!
With the help of their newfound allies in the west they keep a permanent guard over the farportal. The portal must be permanently destroyed to prevent reinforcements.
The leader of the Sunwall, High Sun Paladin Aeryn must be punished for her crimes against the Prides.]],[[太阳堡垒的敌人已经在这片土地上横行了太久，他们妄图掌控整个大陆。他们绝不会得逞！
在他们来自西方的新盟友的帮助下，他们永久守护着远古传送门。摧毁远古传送门，防止援军前来！
太阳堡垒的领袖，高阶太阳骑士艾伦，将会为她对部落犯下的恶行付出代价！]]
)
		desc = desc:gsub("You have killed Aeryn, making sure no more troops will come from the west.","你杀死了艾伦，西方的援军再也不会前来了。")

		return desc
	end}
