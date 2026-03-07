
    
    

select
    type_name as unique_field,
    count(*) as n_records

from "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim"
where type_name is not null
group by type_name
having count(*) > 1


