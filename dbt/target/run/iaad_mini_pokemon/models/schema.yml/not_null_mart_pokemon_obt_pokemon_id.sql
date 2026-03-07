
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pokemon_id
from "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt"
where pokemon_id is null



  
  
      
    ) dbt_internal_test