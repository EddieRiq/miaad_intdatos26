
select
  lower(trim(type_name)) as type_name,
  lower(trim(type_group)) as type_group
from {{ source('raw_mysql','pokemon_type_dim') }};
