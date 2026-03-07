# MIAAD – Integración de Datos 2026 (Mini repo – Tareas 5/6/7)

Repositorio para cumplir:
- **Tarea Clase 5**: proyecto dbt con capas (staging/intermediate/mart) + sources + DAG.
- **Tarea Clase 6**: tests (genéricos + dbt-expectations + singular) + documentación + DAG.
- **Tarea Clase 7**: evidencia end-to-end (Airbyte → MotherDuck, dbt, Prefect, Metabase).

---

## Arquitectura (resumen)

**Fuentes**
1) **PokeAPI** (API pública) → tabla `pokemon`  
2) **MySQL local** (Docker) → tabla `pokemon_type_dim`

**Ingesta**
- Airbyte OSS: 2 conexiones hacia **MotherDuck** (DuckDB).

**Transformación**
- dbt (DuckDB / MotherDuck): staging → intermediate → mart (OBT).

**Orquestación**
- Prefect: dispara syncs de Airbyte por API + ejecuta `dbt build`.

**BI**
- Metabase + DuckDB driver conectado a MotherDuck.

---

## Estructura del repo

- `infra/` → MySQL docker + init SQL (tabla `pokemon_type_dim`)
- `dbt/` → proyecto dbt completo (sources, staging, intermediate, mart, tests)
- `flows/` → Prefect flow (orquesta Airbyte + dbt)
- `metabase/` → docker-compose + plugins (DuckDB driver)
- `docs/` → mini informe / evidencias + screenshots

---

## Requisitos

- Docker + Docker Compose
- Airbyte OSS funcionando (abctl/kind según instalación del curso)
- Python (venv) con prefect + requests
- dbt-duckdb instalado para el proyecto
- Token MotherDuck disponible (SSO o variable/archivo según configuración)

---

## Paso a paso (reproducible)

### 1) Levantar MySQL (fuente 2)

```bash
cd infra
docker compose up -d
docker exec -it mysql_pokemon mysql -uroot -proot -e "use pokemon_db; show tables;"
```

### 2) Airbyte → crear Sources + Connections

En Airbyte UI:
- Source A: **PokeAPI**
- Source B: **MySQL** (host accesible desde Airbyte, user `airbyte`, pass `airbyte`, db `pokemon_db`)
- Destination: **MotherDuck**

Crear 2 conexiones:
- `PokeAPI → MotherDuck`
- `MySQL → MotherDuck`

Ejecutar **Sync** y verificar tablas en MotherDuck.

📸 Evidencia sugerida:
- `docs/screenshots/airbyte_connections_mysql_pokeapi.png`

---

### 3) dbt (Tareas 5/6)

```bash
cd dbt
dbt deps
dbt build
```

Generar docs (para screenshot del DAG):

```bash
dbt docs generate
dbt docs serve
```

📸 Evidencias sugeridas:
- `docs/screenshots/dbt_docs_dag.png`
- `docs/screenshots/dbt_build_success.png`

---

### 4) Prefect (Tarea 7)

Crear `.env` a partir de `.env.example` (**NO** commitear `.env`):
- `AIRBYTE_URL`
- `AIRBYTE_CLIENT_ID` / `AIRBYTE_CLIENT_SECRET`
- `AIRBYTE_CONNECTION_IDS` (IDs reales de las 2 conexiones)
- `DBT_PROJECT_DIR` (ruta a `dbt/`)

Levantar server y ejecutar flow:

```bash
prefect config set PREFECT_API_URL=http://127.0.0.1:4200/api
prefect server start
```

En otra terminal:

```bash
cd <raiz-del-repo>
set -a; source .env; set +a
python flows/pipeline_manual.py
```

📸 Evidencia sugerida:
- `docs/screenshots/prefect_flow_run_success.png`

---

### 5) Metabase (Tarea 7)

```bash
cd metabase
docker compose up -d
```

En Metabase:
- Agregar DB: DuckDB (MotherDuck driver)
- Conectar a `md:airbyte_curso` (o el nombre del DB usado)
- Crear dashboard con ≥ 5 visualizaciones y ≥ 2 filtros

📸 Evidencia sugerida:
- `docs/screenshots/metabase_pokemon_dashboard.png`

---

## Evidencias (Tarea 7)

Ver carpeta: `docs/screenshots/`

- Airbyte: conexiones MySQL + PokeAPI → MotherDuck
- dbt: DAG + `dbt build` OK
- Prefect: corrida exitosa del flow
- Metabase: dashboard con 5 visualizaciones + 2 filtros

---

## Modelo dbt (resumen)

- `models/staging/`: `stg_pokemon`, `stg_pokemon_type_dim`
- `models/intermediate/`: `int_pokemon_enriched`
- `models/marts/`: `mart_pokemon_obt` (OBT)

Tests:
- genéricos (unique, not_null, relationships)
- dbt-expectations (rangos / sets / row count)
- singular tests (SQL) en `dbt/tests/`
