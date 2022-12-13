require './pokemon'
require './battle'


# creates a list of pokemons
#
# Parameters:
#   pokemon_amount: length of the list of pokemons
# Returns:
#   pokemons: a list of pokemons
def create_pokemons(pokemon_amount)
    pokemons = []
    (0..pokemon_amount).each do |_|
        pokemons.append(get_pokemon(rand(1..152)))
    end
    return pokemons
end

# execute a round of fights in pairs between
# the pokemons in the list
#
# Parameters:
#   pokemons: a list of pokemons (length must be power of 2)
# Returns:
#   winners: winners of the fights
def round(pokemons)
    winners = []
    (0..(pokemons.length()/2 - 1)).each do |i|
        puts "#{pokemons[2*i]["name"]} vs #{pokemons[2*i + 1]["name"]}"
        puts
        if pokemons[2*i]['stats']['speed'] > pokemons[2*i + 1]['stats']['speed']
            puts "#{pokemons[2*i]["name"]} is faster than #{pokemons[2*i + 1]["name"]}"
            turn = 0
        else
            puts "#{pokemons[2*i + 1]["name"]} is faster than #{pokemons[2*i]["name"]}"
            turn = 1
        end
        
        while not is_defeated(pokemons[2*i]) and not is_defeated(pokemons[2*i + 1])
            next_turn = (turn + 1) % 2
            pokemons[2*i + next_turn] = attack(pokemons[2*i + turn], pokemons[2*i + next_turn])
            puts "#{pokemons[2*i + next_turn]["name"]} hp is: #{pokemons[2*i + next_turn]['stats']['hp']}"
            turn = next_turn
        end

        if is_defeated(pokemons[2*i])
            winner = pokemons[2*i + 1]
            puts "#{winner["name"]} won the #{i + 1}° battle"
        else
            winner = pokemons[2*i]
            puts "#{winner["name"]} won the #{i + 1}° battle"
        end
        winner['stats']['hp'] = winner['stats']['base_hp']
        winners.append(winner)
        puts
        puts
    end
    return winners
end

# execute tournament
#
# Parameters:
#   pokemon_amount: amount of pokemons in tournament (length must be power of 2)
# Returns:
#   None: prints the winner!
def tournament(pokemon_amount)
    pokemons = create_pokemons(pokemon_amount)
    round_number = 1
    while pokemons.length() > 1
        puts "---- ROUND #{round_number} ----"
        puts
        pokemons = round(pokemons)
        round_number = round_number + 1
    end

    puts "#{pokemons[0]["name"]} won the tournament!"
end


tournament(8)