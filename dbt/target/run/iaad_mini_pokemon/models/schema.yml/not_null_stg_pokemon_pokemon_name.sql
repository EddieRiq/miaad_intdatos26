
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pokemon_name
from "airbyte_curso"."dbt_main_staging"."stg_pokemon"
where pokemon_name is null



  
  
      
    ) dbt_internal_test