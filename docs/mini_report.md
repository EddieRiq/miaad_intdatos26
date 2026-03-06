
# Mini Informe (Clases 5–7)

## Objetivo
Construir un pipeline end-to-end con 2 fuentes (PokeAPI y MySQL) hacia MotherDuck, transformar con dbt (staging → intermediate → mart) y demostrar orquestación con Prefect y consumo en Metabase.

## Arquitectura
- Airbyte: PokeAPI + MySQL → MotherDuck
- dbt: staging (2) → intermediate (1) → mart OBT (1)
- Prefect: dispara Airbyte y corre `dbt build`
- Metabase: dashboard con ≥5 charts y 2 filtros

## Modelado (OBT)
La tabla final `main_marts.mart_pokemon_obt` consolida métricas del Pokémon (stats y tipos) más un atributo de enriquecimiento (`type_1_group`) desde MySQL.

## Calidad
Se incluyen tests genéricos y dbt-expectations (rangos, sets) además de 2 singular tests.

## Evidencias
Adjuntar:
- DAG de dbt docs
- dbt build OK
- Airbyte MySQL connection OK
- Prefect run OK
- Dashboard Metabase
