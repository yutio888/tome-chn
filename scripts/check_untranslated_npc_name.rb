require 'find'
require 'json'

json = JSON.parse File.read(".te4-path")

chn_path = json["chn_path"]
te4_path = json["te4_path"]
dlc_path = json["dlc_path"]


npc_files = []
Find.find("#{te4_path}/data/general/npcs/"){|fp|
	if /\.lua/ =~ fp then
		npc_files << fp
	end
}
Find.find("#{dlc_path}/ashes-urhrok/tome-ashes-urhrok/data/general/npcs/"){|fp|
	if /\.lua/ =~ fp then
		npc_files << fp
	end
}
Find.find("#{dlc_path}/cults/tome-cults/data/general/npcs/"){|fp|
	if /\.lua/ =~ fp then
		npc_files << fp
	end
}
Find.find("#{dlc_path}/orcs/tome-orcs/data/general/npcs/"){|fp|
	if /\.lua/ =~ fp then
		npc_files << fp
	end
}

names_mp = {}

npc_files.each{|fp|
	File.open(fp).each{|line|
		line.force_encoding("utf-8")
		mh = /(?<=(name = \"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
		next unless mh
		names_mp[mh.to_s] = fp
	}
}

File.open("#{chn_path}/data/npc_name.lua").each{|line|
	line.force_encoding("utf-8")
	mh = /(?<=(npcNameCHN\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
	next unless mh
	names_mp.delete(mh.to_s)
}

names_mp.each{|k,v|
	puts "Untranslated npc name: [#{k}], location: #{v}"
}



