require 'rest-client'
require 'json'
require './battle'

API_URL = "https://pokeapi.co/api/v2"

# transform the json stats data from the pokemon
# into a more understable structure
#
# Parameters:
#   stats: part of the pokemon json response that contains the stats
# Returns:
#   f_stats: a dictionary with ("name of stat" => base_value) format
def format_stats(stats)
    f_stats = {}
    stats.each {
      |stat| f_stats[stat["stat"]["name"]] = stat["base_stat"]
    }
    f_stats["base_hp"] = f_stats["hp"] 
    return f_stats
end

# transform the json types data from the pokemon
# into a more understable structure with its damage relations
#
# Parameters:
#   types: part of the pokemon json response that contains the types
# Returns:
#   f_types: a dictionary with ("type" => relations) format
def format_types(types)
    f_types = {}
    types.each {
      |type| type_name = type["type"]["name"]
      f_types[type_name] = get_type_relations(type_name)
    } 
    return f_types
end

# send a GET request and transform the response into
# JSON format
#
# Parameters:
#   request: requested URL
# Returns:
#   data: json format response from request
def get(request)
    response = RestClient.get request
    data = JSON.parse response
    return data
end

# send a GET request and transform the relations response into
# an easier format
#
# Parameters:
#   id: id or name of type
# Returns:
#   formated_damage_relations: damage relations for type
def get_type_relations(id)
    request = "#{API_URL}/type/#{id}"
    relations = get(request)["damage_relations"]
    formated_damage_relations = {}

    relations.each {
      |relation| relation_name = relation[0]
      relation_types = []

      if not relation[1].nil? 
        relation[1].each {
        |type| relation_types.append(type["name"])
        }
      end

      formated_damage_relations[relation_name] = relation_types
    }

    return formated_damage_relations
end


# GET info from the pokemon with the given id
#
# Parameters:
#   id: id or name from pokemon 
# Returns:
#   pokemon: return a dictionary with pokemon needed information
def get_pokemon(id)
    request = "#{API_URL}/pokemon/#{id}"
    data = get(request)
    pokemon = {"name" => data["name"],
                "stats" => format_stats(data["stats"]),
                "types" => format_types(data["types"])
    }
    return pokemon
end
