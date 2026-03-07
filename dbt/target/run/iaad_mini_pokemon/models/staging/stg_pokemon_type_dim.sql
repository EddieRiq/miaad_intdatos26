
  
  create view "airbyte_curso"."dbt_main_staging"."stg_pokemon_type_dim__dbt_tmp" as (
    select
  lower(trim(type_name)) as type_name,
  lower(trim(type_group)) as type_group
from "airbyte_curso"."main"."pokemon_type_dim"
  );
