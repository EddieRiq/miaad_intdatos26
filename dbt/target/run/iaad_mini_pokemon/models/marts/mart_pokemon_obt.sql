
  
    
    

    create  table
      "airbyte_curso"."dbt_main_marts"."mart_pokemon_obt__dbt_tmp"
  
    as (
      select
  pokemon_id,
  pokemon_name,
  type_1,
  type_2,
  type_1_group,
  base_experience,
  hp,
  attack,
  defense,
  speed,
  height_dm,
  weight_hg,
  round(weight_hg / nullif(height_dm,0)::double, 3) as weight_per_height
from "airbyte_curso"."dbt_main_staging"."int_pokemon_enriched"
    );
  
  