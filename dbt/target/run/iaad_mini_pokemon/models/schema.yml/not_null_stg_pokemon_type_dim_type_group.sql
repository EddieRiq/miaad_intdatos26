
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select type_group
from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
where type_group is null



  
  
      
    ) dbt_internal_test