
# IAAD Mini TP (Clases 5–7) — Pokémon + MySQL + Airbyte + MotherDuck + dbt + Prefect + Metabase

Este repositorio es una versión **reducida** (pero completa) del TP, pensada para cumplir **Tarea Clase 5, 6 y 7**.

## Fuentes (2)
1. **PokeAPI** (Airbyte Source) → tabla `main.pokemon`
2. **MySQL** (Airbyte Source) → tabla `main.pokemon_type_dim` (dimensión de tipos)

Destino: **MotherDuck** (DuckDB cloud), por ejemplo `md:airbyte_curso`.

---

## 0) Requisitos
- Docker + docker compose
- Airbyte OSS (abctl) levantado en `http://localhost:8000`
- Cuenta MotherDuck y token válido
- Python 3.11 + venv
- `dbt-duckdb` instalado
- Prefect (server local) para la tarea clase 7

---

## 1) Levantar MySQL (fuente 2)
```bash
cd infra
docker compose up -d
```
Esto crea una base `pokemon_db` y la tabla `pokemon_type_dim` con 18 tipos y una categoría simple (`type_group`).

Verificar:
```bash
docker exec -it mysql_pokemon mysql -uroot -proot -e "use pokemon_db; select count(*) from pokemon_type_dim;"
```

---

## 2) Configurar Airbyte (2 connections)
### 2.1 Destination: MotherDuck
- Crear destination MotherDuck con tu token / db `airbyte_curso` (o la que uses).

### 2.2 Source A: PokeAPI
- Source: **PokeAPI**
- Stream: `pokemon` (full refresh overwrite)
- Connection: PokeAPI → MotherDuck

### 2.3 Source B: MySQL
- Host: `host.docker.internal` (si Airbyte corre en Docker/K8s), o tu IP local.
- Port: `3306`
- Database: `pokemon_db`
- User: `root`
- Password: `root`
- Seleccionar tabla: `pokemon_type_dim`
- Connection: MySQL → MotherDuck

> Nota: si `host.docker.internal` no funciona en Linux, usá la IP del host (ej: `192.168.x.x`) y asegurate que el pod de Airbyte tenga acceso.

---

## 3) dbt (Tarea 5 + 6)
### 3.1 Crear venv e instalar
```bash
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install dbt-duckdb prefect python-dotenv
```

### 3.2 Profiles (MotherDuck)
Copiar y editar:
- `profiles.yml.example` → `~/.dbt/profiles.yml`

Luego probar:
```bash
cd dbt
dbt debug
```

### 3.3 Dependencias (dbt-expectations)
```bash
dbt deps
```

### 3.4 Ejecutar todo (models + tests)
```bash
dbt build
```

### 3.5 DAG (dbt docs)
```bash
dbt docs generate
dbt docs serve --port 8088
```
Abrí `http://localhost:8088` → tab **DAG** y guardá captura en `docs/screenshots/dag.png`.

---

## 4) Prefect (Tarea Clase 7)
### 4.1 Variables (.env)
Copiar:
- `.env.example` → `.env`

Completar:
- `AIRBYTE_URL`
- `AIRBYTE_CLIENT_ID`
- `AIRBYTE_CLIENT_SECRET`
- `AIRBYTE_CONNECTION_IDS` (dos UUID de tus conexiones: PokeAPI y MySQL)
- `DBT_PROJECT_DIR` (ruta a `dbt/`)

### 4.2 Levantar Prefect UI
```bash
prefect server start
```

### 4.3 Ejecutar pipeline manual
En otra terminal:
```bash
source .venv/bin/activate
python flows/pipeline_manual.py
```

Sacar captura de ejecución exitosa:
- `docs/screenshots/prefect_run.png`

---

## 5) Metabase (Tarea Clase 7)
Levantar Metabase con driver DuckDB:
```bash
cd metabase
docker compose up -d
```

Abrir:
- `http://localhost:3000`

Agregar DB:
- Tipo: DuckDB
- MotherDuck Token: tu token
- Database file: `md:airbyte_curso`
- Init SQL:
  - `INSTALL httpfs; LOAD httpfs;`
  - `INSTALL motherduck; LOAD motherduck;`

Crear dashboard con ≥5 visualizaciones y 2 filtros.
Guardar captura:
- `docs/screenshots/metabase_dashboard.png`

---

## 6) Documento final (Tarea Clase 7)
Completar `docs/class7_evidence.md` y adjuntar capturas:
- Airbyte MySQL→MotherDuck funcionando
- dbt build OK + DAG
- Prefect run exitoso
- Metabase dashboard
