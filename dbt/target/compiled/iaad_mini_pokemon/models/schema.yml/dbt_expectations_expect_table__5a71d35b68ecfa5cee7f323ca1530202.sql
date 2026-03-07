



    with grouped_expression as (
    select
        
        
    
  
( 1=1 and count(*) >= 1 and count(*) <= 20000
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





