require 'find'
require 'json'

json = JSON.parse File.read(".te4-path")

chn_path = json["chn_path"]
te4_path = json["te4_path"]
dlc_path = json["dlc_path"]


files = []
Find.find("#{te4_path}/data/general/grids/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/ashes-urhrok/tome-ashes-urhrok/data/general/grids/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/cults/tome-cults/data/general/grids/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/orcs/tome-orcs/data/general/grids/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}

Find.find("#{te4_path}/data/zones/"){|fp|
    if /grids\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/ashes-urhrok/tome-ashes-urhrok/data/zones/"){|fp|
    if /grids\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/cults/tome-cults/data/zones/"){|fp|
    if /grids\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/orcs/tome-orcs/data/zones/"){|fp|
    if /grids\.lua/ =~ fp then
        files << fp
    end
}

names_mp = {}

files.each{|fp|
    in_grid = 0
    File.open(fp).each{|line|
        line.force_encoding("utf-8")
        mh = /newEntity/.match(line)
        in_grid = 3 if mh
        next if in_grid <= 0
        in_grid -= 1
        mh = /(?<=(name = \"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
        names_mp[mh.to_s] = fp if mh
        mh = /(?<=(name=\"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
        names_mp[mh.to_s] = fp if mh
    }
}

File.open("#{chn_path}/data/tooltips/grids.lua").each{|line|
    line.force_encoding("utf-8")
    mh = /(?<=(gridCHN\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
    next unless mh
    names_mp.delete(mh.to_s)
}

names_mp.each{|k,v|
    puts "Untranslated grid name: [#{k}], location: #{v}"
    # puts "gridCHN[\"#{k}\"] = \"#{k}\""
}
