-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

--------------------------------------------------------------------------
-- Sher'Tul
--------------------------------------------------------------------------

newLore{
	id = "shertul-fortress-1",
	category = "sher'tul",
	name = "first mural painting", always_pop = true,
	image = "shertul_fortress_lore1.png",
	lore = function() return [[你能在这壁画上看到一个黑暗和痛苦的世界。有着强大领域的上古巨神们在互相厮杀，大地在他们脚下龟裂。下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：'Στην　αρχή, ο　κόσμος　είναι　γεμάτη　με　το　σκοτάδι　θεών　και　ανταγωνισμού,　προκειμένου　να　τα　αντίστοιχα　εδάφη　τους.']] or [[#{italic}#'刚开始世界充满了黑暗，众神为了各自的领土而竞争。'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-2",
	category = "sher'tul",
	name = "second mural painting", always_pop = true,
	image = "shertul_fortress_lore2.png",
	lore = function() return [[在这幅画上有一位铁塔一样的巨神，他目光如炬，右手高举着太阳。众神逃离他，害怕他手中的光芒。下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Αλλά　το　ελαστικό　αυτοκινήτου　Amacker　έχει　έρθει,　έχει　εκφοβίσει　τους　ανθρώπους　θαρραλέα,　ψεύτικο　δέος　Θεών　στην　υποβολή ενδοτική στη 　όξα　του.Μετά από　βαθύ　αναπνοή　ανυψωμένο　επάνω　υψηλό　του　ο　ήλιος　επάνω　από τον　κόσμο,　εν　λόγω: «Το　φως　του　ήλιου,　δηλαδή Ι,　σε　αυτήν　την　ακτίνα　θα　φωτίσει　τον　κόσμο.]] or[[#{italic}#'但阿马克泰尔来了,他的勇武震慑了众人,伪神们慑服于他的荣耀。他深呼吸后把太阳高举到了世界之上，说：“阳光所至，即我所至，这光芒将照亮全世界。”#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-3",
	category = "sher'tul",
	name = "third mural painting", always_pop = true,
	image = "shertul_fortress_lore3.png",
	lore = function() return [[这幅画显示了真神将一个小巧的遗迹托在手心，并指向远方的大陆。你猜这遗迹也许就是夏·图尔。下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Έγιναν　Sher'Tul　και　amaketaier,　να　μας　δώσει　μέσω　της　δύναμης　της　αυτο-θα,　μας　είπε　ότι:　"στον　κόσμο,　γίνονται　όλα　για　τον　εαυτό　του.　”]] or [[#{italic}#'并且阿马克泰尔制造了夏·图尔，给予我们完成自我意志的力量，他对我们说：“走向世界，为自己取得一切。”'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-4",
	category = "sher'tul",
	name = "fourth mural painting", always_pop = true,
	image = "shertul_fortress_lore4.png",
	lore = function() return [[你在壁画上看到一个巨大的水晶之城，有数个浮空岛悬浮在周围。在画面的最前端坐着的是夏·图尔人，他向天空笔直的举起手臂。下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Έχουμε　κατακτήσει　τον　κόσμο,　κατασκευάζουμε　τα　ψηλά　κτήρια　για　σε,　τη　μητρόπολη　παραίσθησης　χαλαζία　και　το　φρούριο　ουρανού　αερολύματος,　αλλά　μ　ρικοί άνθρωποι　δεν　ικανοποιούν　...... ]] or [[#{italic}#'我们征服了世界，为自己建造高楼大厦，水晶般梦幻的都市和悬浮天空的堡垒，但有些人还不满足……'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-5",
	category = "sher'tul",
	name = "fifth mural painting", always_pop = true,
	image = "shertul_fortress_lore5.png",
	lore = function() return [[这幅壁画显示了九个夏·图尔人肩并肩站着，每人手里都高举着一件一模一样的黑色武器。你的注意力集中在画面中间——被红袍者举起的符文法杖上。它看起来很眼熟……下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Τυφλή μας　στην　εν　λόγω　υπεροπτική　δίκαιη,　απορρίπτουμε　ότι　άπληστους　της　υποδούλωσης. Έχουμε　δημιουργήσει ένα　ισχυρό όπλο　-　Λεπίδα　του　σκοτώνοντας　τον　Θεό,　και　εξέλεξε　εννέα　ελίτ　να　τα　χρησιμοποιήσουν.]] or [[#{italic}#'我们无视那高傲的公平，我们拒绝那贪婪的奴役。我们给自己打造了强大的武器——弑神之刃，并选出了九名精英来使用它们。'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-6",
	category = "sher'tul",
	name = "sixth mural painting", always_pop = true,
	image = "shertul_fortress_lore6.png",
	lore = function() return [[你在这幅画上看到一场史诗战争——夏·图尔的战士们在和10倍大于他们的神祗战斗。下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Οι　θεοί　νικήθηκαν,　την　ψυχή　τους　στην　ανυπαρξία.　Ήπειρος　είναι　τελικά　αυτό　που　έχουμε.　Αλλά　υπάρχει　ένας　θεός　υπάρχει　...]] or [[#{italic}#'那些神祗被一个个击败，他们的灵魂化为虚无。大陆终于为我们所拥有。但是还有一位神祗存在……'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-7",
	category = "sher'tul",
	name = "seventh mural painting", always_pop = true,
	image = "shertul_fortress_lore7.png",
	lore = function() return [[你看到红袍夏·图尔人用那根又黑又亮的法杖攻击巨大的神祗。碎肉撒了一地，鲜血染遍了整个黄金王座。神祗眼中的神采似乎消散了……下面有一行文字 ]]..(not game.player:attr("speaks_shertul") and [[不明意义的文字：Αληθινό　ελαστικό　αυτοκινήτου　Amacker　Θεών　που　χύθηκε　τελικά　κάτω　από το　χρυσό　θρόνο　του,　αν　και　χιλ　άδες　άνθρωποι　πέθαναν　κάτω　από　το　πόδι　του, έπεσε　τελικά　από　τον　ουρανό. 
]] or [[#{italic}#'真神阿马克泰尔最终倒在了他的黄金王座下，虽然数以千计的人死在他的脚下，他最终还是陨落了。'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-8",
	category = "sher'tul",
	name = "eighth mural painting", always_pop = true,
	image = "shertul_fortress_lore8.png",
	lore = function() return [[这幅巨大的壁画上，真神被摊开在地上，那根黑色的法杖穿透了他的胸口。夏·图尔人围绕着他，有的在切他的肢体，有的在割他的舌头，还有的在用锁链捆绑他。一位高个子夏·图尔人对他的眼睛射出了一束激光，他在用锋利的长戟切割真神的眼睛。远处，一个夏·图尔法师在地上召唤了一道沟壑。下面有只有一句]]..(not game.player:attr("speaks_shertul") and [[Πηγή του κακού]] or [[#{italic}#'罪恶之源。'#{normal}#]])
	end,
}

newLore{
	id = "shertul-fortress-9",
	category = "sher'tul",
	name = "ninth mural painting", always_pop = true,
	image = "shertul_fortress_lore9.png",
	lore = function() return [[最后的这块壁画似乎损坏的很严重，上面有深深的划痕和腐蚀的痕迹。你所能看到的似乎是火焰的画面。]] end,
}

newLore{
	id = "shertul-fortress-takeoff",
	category = "sher'tul",
	name = "Yiilkgur raising toward the sky", always_pop = true,
	image = "fortress_takeoff.png",
	lore = [[伊克格重新激活了夏·图尔要塞，它从湖底伸向天空。]],
}

newLore{
	id = "shertul-fortress-caldizar",
	category = "sher'tul",
	name = "a living Sher'Tul?!", always_pop = true,
	image = "inside_caldizar_fortress.png",
	lore = [[不管怎样，你传送到了另一个异次元的夏·图尔要塞。在那里，你看到了一位活着的夏·图尔人。]],
}

newLore{
	id = "first-farportal",
	category = "sher'tul",
	name = "lost farportal", always_pop = true,
	image = "farportal_entering.png",
	lore = function() return game.player.name..[[大胆地进入了一个夏·图尔传送门。]] end,
}
