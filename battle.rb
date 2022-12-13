NORMAL_ATTACK = 0
SPECIAL_ATTACK = 1
DAMAGE_OPTIONS = {"no_damage_from" => 0, "half_damage_from" => 1.0/2, "double_damage_from" => 2}
MAX_DEFENSE = 255
MAX_SPECIAL_DEFENSE = 255

# function handle the special attack
#
# Parameters:
#   special_attack_stat: special attack stat from attacker pokemon
#   attack_type: type of the special attack
#   receiver_pokemon: pokemon info structure
# Returns:
#   receiver_pokemon: pokemon structure modified hp after attack
def special_attack(special_attack_stat, attack_type, receiver_pokemon)

    pokemon_hp = receiver_pokemon["stats"]["hp"]
    pokemon_defense = receiver_pokemon["stats"]["special-defense"]
    base_damage = special_attack_stat * (1 - (pokemon_defense.to_f / MAX_SPECIAL_DEFENSE)) + 1
    damage_multiplier = Float::INFINITY
    DAMAGE_OPTIONS.keys.each {
        |damage_option|
        receiver_pokemon["types"].keys.each {
            |type|
            if receiver_pokemon["types"][type][damage_option].include? attack_type
                damage_multiplier = [damage_multiplier, DAMAGE_OPTIONS[damage_option]].min
            end
        }
    }
    if damage_multiplier > 2
        damage_multiplier = 1
    end
    curr_hp = pokemon_hp - base_damage.to_i * damage_multiplier
    receiver_pokemon["stats"]["hp"] = curr_hp.ceil()
    puts "#{receiver_pokemon["name"]} received a #{attack_type} special attack of #{base_damage.to_i} base points with a multiplier of #{damage_multiplier} "
    return receiver_pokemon
end


# function handle the normal attack
#
# Parameters:
#   attack_stat: attack stat from attacker pokemon
#   receiver_pokemon: pokemon info structure
# Returns:
#   receiver_pokemon: pokemon structure modified hp after attack
def normal_attack(attack_stat, receiver_pokemon)

    pokemon_hp = receiver_pokemon["stats"]["hp"]
    pokemon_defense = receiver_pokemon["stats"]["defense"]
    damage = attack_stat * (1 - (pokemon_defense.to_f / MAX_DEFENSE)) + 1
    curr_hp = pokemon_hp - damage.to_i
    receiver_pokemon["stats"]["hp"] = curr_hp.ceil()
    puts "#{receiver_pokemon["name"]} received a normal attack of #{damage.to_i} points"
    return receiver_pokemon
end

# function that random select attack or special-attack
# to attack a pokemon
#
# Parameters:
#   attacker_pokemon: pokemon info structure
#   receiver_pokemon: pokemon info structure
# Returns:
#   receiver_pokemon: pokemon structure modified hp after attack
def attack(attacker_pokemon, receiver_pokemon)
    attack_option = rand(2)

    case attack_option
    when NORMAL_ATTACK
        attack_stat = attacker_pokemon["stats"]["attack"]
        
        return normal_attack(attack_stat, receiver_pokemon)
    when SPECIAL_ATTACK
        special_attack_stat = attacker_pokemon["stats"]["special-attack"]
        attack_type = attacker_pokemon["types"].keys.sample

        return special_attack(special_attack_stat, attack_type, receiver_pokemon)
    end

end

# verify if the pokemon's hp is zero
#
# Parameters:
#   pokemon: pokemon info structure
# Returns:
#   bool: True or False
def is_defeated(pokemon)
    return pokemon["stats"]["hp"] <= 0
end