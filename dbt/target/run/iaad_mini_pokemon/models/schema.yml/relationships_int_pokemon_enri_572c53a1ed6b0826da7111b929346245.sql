
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select type_1 as from_field
    from "airbyte_curso"."dbt_main_staging"."int_pokemon_enriched"
    where type_1 is not null
),

parent as (
    select type_name as to_field
    from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test