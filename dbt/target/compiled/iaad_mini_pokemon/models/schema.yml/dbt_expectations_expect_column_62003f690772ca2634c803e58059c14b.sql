

with all_values as (

    select
        type_group as value_field

    from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
    

),
set_values as (

    select
        cast('neutral' as TEXT) as value_field
    union all
    select
        cast('hot' as TEXT) as value_field
    union all
    select
        cast('wet' as TEXT) as value_field
    union all
    select
        cast('electric' as TEXT) as value_field
    union all
    select
        cast('nature' as TEXT) as value_field
    union all
    select
        cast('cold' as TEXT) as value_field
    union all
    select
        cast('combat' as TEXT) as value_field
    union all
    select
        cast('toxic' as TEXT) as value_field
    union all
    select
        cast('earth' as TEXT) as value_field
    union all
    select
        cast('air' as TEXT) as value_field
    union all
    select
        cast('mystic' as TEXT) as value_field
    
    
),
validation_errors as (
    -- values from the model that are not in the set
    select
        v.value_field
    from
        all_values v
        left join
        set_values s on v.value_field = s.value_field
    where
        s.value_field is null

)

select *
from validation_errors

