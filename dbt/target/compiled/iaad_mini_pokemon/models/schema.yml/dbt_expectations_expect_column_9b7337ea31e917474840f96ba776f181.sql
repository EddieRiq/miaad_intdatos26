






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and weight_per_height >= 0 and weight_per_height <= 1000
)
 as expression


    from "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt"
    

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







