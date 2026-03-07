-- Falla si devuelve filas: todo Pokémon debe tener type_1_group (según dim de tipos)
select *
from "airbyte_curso"."dbt_main_staging"."int_pokemon_enriched"
where type_1 is not null and type_1_group is null