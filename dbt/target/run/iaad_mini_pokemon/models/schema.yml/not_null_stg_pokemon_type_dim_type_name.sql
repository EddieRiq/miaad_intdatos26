
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select type_name
from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
where type_name is null



  
  
      
    ) dbt_internal_test