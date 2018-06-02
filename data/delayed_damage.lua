function delayed_damage_trans(desc)
	if not desc then return desc end

	desc = desc:gsub("essence drain","精华吸取"):gsub("warded","守护"):gsub("blocked","格挡")
	     :gsub("to psi shield","超能盾"):gsub("antimagic","反魔"):gsub("resist armour","减免"):gsub("orc summon chance","几率召唤兽人")
	     :gsub("orc summon","召唤兽人"):gsub("terror chance","恐惧几率"):gsub("blinding powder","致盲粉"):gsub("smoke","烟雾")
	     :gsub("dismissed","豁免"):gsub("reacted","反应"):gsub("deflected","偏移"):gsub("decoy","诱饵"):gsub("converted","转化")
	     :gsub("dissipated","驱散"):gsub("shared","共享"):gsub("smeared","时空转化"):gsub("STATIC","静电"):gsub("braided","编织")
	     :gsub("webs of fate","命运之网"):gsub("focus","集中"):gsub("parried","回避"):gsub("gestured","手势"):gsub("healing","治疗")
	     :gsub("shifted","相位"):gsub("absorbed","护盾"):gsub("teleported","传送"):gsub("to time","时间"):gsub("reflected","反射")
	     :gsub("linked","链接"):gsub("to bones","骨盾"):gsub("deflected","偏折"):gsub("to ice","冰块"):gsub("resonance","共振"):gsub("refused","拒绝")
	     :gsub("resilience","坚韧"):gsub("to stone","石头"):gsub("redirected","转移")
	     :gsub("turned into osmosis","渗透")
	     :gsub("to entropy","熵"):gsub("treason","背叛"):gsub("quantum shifted","量子转移")

	return desc
end
