






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and base_experience >= 0 and base_experience <= 2000
)
 as expression


    from "airbyte_curso"."dbt_main_staging"."stg_pokemon"
    

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







