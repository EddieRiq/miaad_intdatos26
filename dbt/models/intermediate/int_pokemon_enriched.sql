
with p as (
  select * from {{ ref('stg_pokemon') }}
),
t as (
  select * from {{ ref('stg_pokemon_type_dim') }}
)
select
  p.*,
  t.type_group as type_1_group
from p
left join t
  on p.type_1 = t.type_name;
