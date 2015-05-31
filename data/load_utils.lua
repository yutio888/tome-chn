function string.he_she(actor)
	if actor.female then return "她"
	elseif actor.neuter then return "它"
	else return "他"
	end
end

function string.his_her(actor)
	if actor.female then return "她的"
	elseif actor.neuter then return "他的"
	else return "他的"
	end
end

function string.him_her(actor)
	if actor.female then return "她"
	elseif actor.neuter then return "它"
	else return "他"
	end
end

function string.his_her_self(actor)
	if actor.female then return "她自己"
	elseif actor.neuter then return "它自己"
	else return "他自己"
	end
end
