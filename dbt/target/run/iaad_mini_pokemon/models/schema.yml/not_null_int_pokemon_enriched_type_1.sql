
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select type_1
from "airbyte_curso"."dbt_main_staging"."int_pokemon_enriched"
where type_1 is null



  
  
      
    ) dbt_internal_test