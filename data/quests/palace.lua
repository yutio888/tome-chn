questCHN["No Fumes Without Fire"] = {
	name = "无火不起烟",
	description = function(desc)
		
		desc = desc:gsub("The time for revenge is at hand! The Tribe stands crippled under your assaults.","复仇的时刻终于到了！气之部族在你的攻击下濒临瘫痪！")
		desc = desc:gsub("Enter the Palace of Fumes and crush their leaders once and for all!","攻入烟雾宫殿，彻底粉碎他们的领袖！")
		desc = desc:gsub("For Kruk!","为了克鲁克！")
		desc = desc:gsub("For the Prides!","为了部落！")
		desc = desc:gsub("For the Garkul!","为了加库尔！")
		desc = desc:gsub("Council Member Nashal is dead.","议会成员Nashal死了。")
		desc = desc:gsub("Council Member Tormak is dead.","议会成员Tormak死了。")
		desc = desc:gsub("Council Member Pendor is dead.","议会成员Pendor死了。")
		desc = desc:gsub("Council Member Palaquie is dead.","议会成员Palaquie死了。")
		desc = desc:gsub("Council Member Tantalos is dead.","议会成员Tantalos死了。")
		desc = desc:gsub("You have destroyed the Council and shattered the Tribe.","你摧毁了他们的议会，气之部族分崩离析！")

		return desc
	end}
