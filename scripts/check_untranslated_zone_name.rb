require 'find'
require 'json'

json = JSON.parse File.read(".te4-path")

chn_path = json["chn_path"]
te4_path = json["te4_path"]
dlc_path = json["dlc_path"]


files = []
Find.find("#{te4_path}/data/general/events/"){|fp|
	if /\.lua/ =~ fp then
		files << fp
	end
}
Find.find("#{dlc_path}/ashes-urhrok/tome-ashes-urhrok/data/general/events/"){|fp|
	if /\.lua/ =~ fp then
		files << fp
	end
}
Find.find("#{dlc_path}/cults/tome-cults/data/general/events/"){|fp|
	if /\.lua/ =~ fp then
		files << fp
	end
}
Find.find("#{dlc_path}/orcs/tome-orcs/data/general/events/"){|fp|
	if /\.lua/ =~ fp then
		files << fp
	end
}

names_mp = {}

files.each{|fp|
	in_zone = 0
	File.open(fp).each{|line|
		line.force_encoding("utf-8")
		mh = /Zone\.new/.match(line)
		in_zone = 3 if mh
		next if in_zone <= 0
		in_zone -= 1
		mh = /(?<=(name = \"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
		next unless mh
		names_mp[mh.to_s] = fp
	}
}

File.open("#{chn_path}/data/zone_name.lua").each{|line|
	line.force_encoding("utf-8")
	mh = /(?<=(zoneName\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
	next unless mh
	names_mp.delete(mh.to_s)
}

names_mp.each{|k,v|
	puts "Untranslated npc name: [#{k}], location: #{v}"
}



