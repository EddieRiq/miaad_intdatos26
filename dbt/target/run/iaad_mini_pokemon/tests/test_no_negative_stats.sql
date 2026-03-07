
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Falla si devuelve filas: stats no pueden ser negativos
select *
from "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt"
where hp < 0 or attack < 0 or defense < 0 or speed < 0
  
  
      
    ) dbt_internal_test