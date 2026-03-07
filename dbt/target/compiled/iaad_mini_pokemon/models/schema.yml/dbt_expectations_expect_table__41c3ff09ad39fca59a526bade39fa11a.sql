



    with grouped_expression as (
    select
        
        
    
  
( 1=1 and count(*) >= 18 and count(*) <= 18
)
 as expression


    from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
    

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





