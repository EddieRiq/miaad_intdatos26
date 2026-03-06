
import os
import time
import subprocess
import requests
from dotenv import load_dotenv

from prefect import flow, task, get_run_logger

load_dotenv()

AIRBYTE_URL = os.getenv("AIRBYTE_URL", "http://localhost:8000").rstrip("/")
CLIENT_ID = os.getenv("AIRBYTE_CLIENT_ID")
CLIENT_SECRET = os.getenv("AIRBYTE_CLIENT_SECRET")
CONNECTION_IDS = [c.strip() for c in os.getenv("AIRBYTE_CONNECTION_IDS", "").split(",") if c.strip()]
DBT_PROJECT_DIR = os.getenv("DBT_PROJECT_DIR", "").rstrip("/")

def _headers(token: str) -> dict:
    return {
        "authorization": f"Bearer {token}",
        "accept": "application/json",
        "content-type": "application/json",
    }

@task
def get_access_token() -> str:
    logger = get_run_logger()
    url = f"{AIRBYTE_URL}/api/public/v1/applications/token"
    payload = {"client_id": CLIENT_ID, "client_secret": CLIENT_SECRET, "grant-type": "client_credentials"}
    r = requests.post(url, json=payload, timeout=60)
    r.raise_for_status()
    token = r.json()["access_token"]
    logger.info("Airbyte token OK")
    return token

@task
def airbyte_trigger_sync(token: str, connection_id: str) -> str:
    logger = get_run_logger()
    url = f"{AIRBYTE_URL}/api/public/v1/jobs"
    payload = {"connectionId": connection_id, "jobType": "sync"}
    r = requests.post(url, json=payload, headers=_headers(token), timeout=60)
    if r.status_code >= 400:
        logger.error(f"Airbyte error {r.status_code}: {r.text}")
    r.raise_for_status()
    job_id = r.json().get("jobId") or r.json().get("id")
    logger.info(f"Triggered Airbyte sync: connection={connection_id} job={job_id}")
    return str(job_id)

@task
def airbyte_wait_job(token: str, job_id: str, poll_s: int = 10, timeout_s: int = 1800) -> None:
    logger = get_run_logger()
    url = f"{AIRBYTE_URL}/api/public/v1/jobs/{job_id}"
    t0 = time.time()
    while True:
        r = requests.get(url, headers=_headers(token), timeout=60)
        r.raise_for_status()
        status = (r.json().get("status") or "").lower()
        logger.info(f"Job {job_id} status={status}")
        if status in ("succeeded", "failed", "cancelled"):
            if status != "succeeded":
                raise RuntimeError(f"Airbyte job {job_id} ended with status={status}")
            return
        if time.time() - t0 > timeout_s:
            raise TimeoutError(f"Airbyte job {job_id} timed out")
        time.sleep(poll_s)

@task
def dbt_build() -> None:
    logger = get_run_logger()
    if not DBT_PROJECT_DIR:
        raise ValueError("DBT_PROJECT_DIR not set")
    cmd = ["dbt", "build"]
    logger.info(f"Running: {' '.join(cmd)} in {DBT_PROJECT_DIR}")
    subprocess.run(cmd, cwd=DBT_PROJECT_DIR, check=True)

@flow(name="iaad_mini_end_to_end")
def pipeline():
    if not CLIENT_ID or not CLIENT_SECRET:
        raise ValueError("AIRBYTE_CLIENT_ID / AIRBYTE_CLIENT_SECRET not set")
    if len(CONNECTION_IDS) < 2:
        raise ValueError("AIRBYTE_CONNECTION_IDS must contain at least 2 connection IDs")
    token = get_access_token()
    job_ids = [airbyte_trigger_sync(token, cid) for cid in CONNECTION_IDS]
    for jid in job_ids:
        airbyte_wait_job(token, jid)
    dbt_build()

if __name__ == "__main__":
    pipeline()
