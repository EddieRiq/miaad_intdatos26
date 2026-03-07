
    
    

select
    pokemon_id as unique_field,
    count(*) as n_records

from "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt"
where pokemon_id is not null
group by pokemon_id
having count(*) > 1


