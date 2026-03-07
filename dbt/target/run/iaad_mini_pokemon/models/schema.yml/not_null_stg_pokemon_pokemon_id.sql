
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pokemon_id
from "airbyte_curso"."dbt_main_staging"."stg_pokemon"
where pokemon_id is null



  
  
      
    ) dbt_internal_test