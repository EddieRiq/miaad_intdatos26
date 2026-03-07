-- Falla si devuelve filas: stats no pueden ser negativos
select *
from "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt"
where hp < 0 or attack < 0 or defense < 0 or speed < 0