questCHN["Of Steamwork and Pain"] = {
	name = "苦痛和蒸汽",
	description = function(desc)
		
		desc = desc:gsub("To win the war you must help the Pride by striking a blow to the giant's morale and supply lines.","为了让部落赢得和蒸汽巨人的战争，你必须打击敌人的士气和补给线。")
		desc = desc:gsub("You have assaulted the Vaporous Emporium, crushing the morale of the Atmos tribe.","你已经袭击了蒸汽商场，摧垮了气之部落的士气。")
		desc = desc:gsub("You must assault the Vaporous Emporium to crush the morale of the Atmos tribe!","你必须袭击了蒸汽商场来摧垮了气之部落的士气！")
		desc = desc:gsub("You have explored the yeti cave and vanquished the Yeti Patriarch.","你已经探索了雪人洞穴，打败了雪人族长。")
		desc = desc:gsub("You must explore the Yeti Cave and destroy the patriarch!","你必须探索雪人洞穴并击败他们的族长！")

		return desc
	end}
