
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  




    with grouped_expression as (
    select
        
        
    
  type_1_group is not null as expression


    from "airbyte_curso"."dbt_main_staging"."int_pokemon_enriched"
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors




  
  
      
    ) dbt_internal_test