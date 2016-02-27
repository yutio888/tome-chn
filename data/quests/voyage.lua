questCHN["Voyage to the Center of Eyal"] = {
	name = "直探地心！",
	description = function(desc)
		
		desc = desc:gsub("In the Palace of Fumes you found a geothermal vent that digs deep into the planet's core.","在烟雾宫殿中，你找到了一个冒出地热的排风口，直探这颗星球的地心。")
		desc = desc:gsub("Strange mutated giants came out. You must find the source of those titans!","奇怪的变异巨人从里面走了出来。你必须找出泰坦的来源！")
		desc = desc:gsub("Travelling deep within Eyal you found the source of all corruptions: the dead god #{bold}##CRIMSON#Amakthel#LAST##{normal}#.","在埃亚尔的深核中寻找，你终于找到了一切污染的尽头：已死之神#{bold}##CRIMSON#阿马克泰尔#LAST##{normal}#。")

		return desc
	end}
