require 'find'
require 'json'


ignore = [
    "Ancient Storm Sapphire",
    "Withered Force"
]

json = JSON.parse File.read(".te4-path")

chn_path = json["chn_path"]
te4_path = json["te4_path"]
dlc_path = json["dlc_path"]


files = []
Find.find("#{te4_path}/data/general/objects/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/ashes-urhrok/tome-ashes-urhrok/data/general/objects/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/cults/tome-cults/data/general/objects/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}
Find.find("#{dlc_path}/orcs/tome-orcs/data/general/objects/"){|fp|
    if /\.lua/ =~ fp then
        files << fp
    end
}

names_mp = {}

files.each{|fp|
    in_entity = 0
    File.open(fp).each{|line|
        line.force_encoding("utf-8")
        mh = /newEntity/.match(line)
        in_entity = 5 if mh
        next if in_entity <= 0
        in_entity -= 1
        mh = /(?<=(\bname = \"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
        next unless mh
        mh = mh.to_s
        if /arrows/ =~ mh then
            mh = mh.gsub(/quiver of /,"")
        end
        if /shots/ =~ mh then
            mh = mh.gsub(/pouch of /,"")
        end
        names_mp[mh.to_s] = fp
    }
}

Find.find("#{chn_path}/data/objects/object_detail"){|fp|
    if /\.lua/ =~ fp then
        File.open(fp).each{|line|
            line.force_encoding("utf-8")
            mh = /(?<=(enName = \"))[a-zA-Z,-.'\% ]+(?=\",)/.match(line)
            mh = mh.to_s.gsub(/%-/,"-")
            next unless mh
            names_mp.delete(mh.to_s)
        }
    end
}

Find.find("#{chn_path}/data/tinkers"){|fp|
    if /\.lua/ =~ fp then
        File.open(fp).each{|line|
            line.force_encoding("utf-8")
            mh = /(?<=(tinkerCHN\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
            next unless mh
            names_mp.delete(mh.to_s)
        }
    end
}

File.open("#{chn_path}/data/objects/artifact.lua").each{|line|
    line.force_encoding("utf-8")
    mh = /(?<=(originName = \"))[a-zA-Z,-.' ]+(?=\",)/.match(line)
    next unless mh
    names_mp.delete(mh.to_s)
}

File.open("#{chn_path}/data/objects/object_detail/egos.lua").each{|line|
    line.force_encoding("utf-8")
    mh = /(?<=(egosCHN\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
    next unless mh
    names_mp.delete(mh.to_s)
}

File.open("#{chn_path}/data/lore_list.lua").each{|line|
    line.force_encoding("utf-8")
    mh = /(?<=(loreCat\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
    names_mp.delete(mh.to_s) if mh
    mh = /(?<=(loreList\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
    names_mp.delete(mh.to_s) if mh
}

File.open("#{chn_path}/data/elixir_ingredients.lua").each{|line|
    line.force_encoding("utf-8")
    mh = /(?<=(i_ingredient\[\"))[a-zA-Z,-.' ]+(?=\"\])/.match(line)
    next unless mh
    names_mp.delete(mh.to_s)
}

File.open("#{chn_path}/data/objects/object_detail/objects.lua").each{|line|
    line.force_encoding("utf-8")
    line.scan(/(?<=(gsub\(\"))([a-zA-Z,-.' ]+)(?=\")/) { |mh|
        mh = mh[1].to_s
        names_mp.delete(mh)
    }
}

ignore.each{|x|
    names_mp.delete(x)
}

names_mp.each{|k,v|
    puts "Untranslated object name: [#{k}], location: #{v}"
}
