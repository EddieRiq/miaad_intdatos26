
with src as (
  select * from {{ source('raw_pokeapi','pokemon') }}
)
select
  id::int as pokemon_id,
  lower(trim(name)) as pokemon_name,
  height::int as height_dm,
  weight::int as weight_hg,
  base_experience::int as base_experience,
  lower(json_extract_string(types, '$[0].type.name')) as type_1,
  lower(json_extract_string(types, '$[1].type.name')) as type_2,
  json_extract(stats, '$[0].base_stat')::int as hp,
  json_extract(stats, '$[1].base_stat')::int as attack,
  json_extract(stats, '$[2].base_stat')::int as defense,
  json_extract(stats, '$[5].base_stat')::int as speed
from src
