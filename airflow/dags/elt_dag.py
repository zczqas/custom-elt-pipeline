from datetime import datetime, timedelta
from airflow import DAG
from docker.types import Mount
from airflow.providers.standard.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator
import subprocess


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


def run_elt_script():
    script_path = "/opt/airflow/elt_script/elt_script.py"
    result = subprocess.run(["python3", script_path], capture_output=True, text=True)
    if result.returncode != 0:
        raise Exception(f"ELT script failed with error: {result.stderr}")
    else:
        print(result.stdout)


dag = DAG(
    "elt_and_dag",
    default_args=default_args,
    description="A simple ELT workflow with dbt",
    start_date=datetime(2025, 6, 29),
    catchup=False,
    tags={"elt", "dbt"},
)

task1 = PythonOperator(
    task_id="run_elt_script",
    python_callable=run_elt_script,
    dag=dag,
)

task2 = DockerOperator(
    task_id="dbt_run",
    image="ghcr.io/dbt-labs/dbt-postgres:latest",
    command=["run", "--profiles-dir", "/root", "--project-dir", "/opt/dbt"],
    auto_remove="success",
    docker_url="unix://var/run/docker.sock",
    network_mode="bridge",
    mounts=[
        Mount(
            source="/home/zcz/PycharmProjects/PythonProject/custom_postgres",
            target="/opt/dbt",
            type="bind",
        ),
        Mount(
            source="/home/zcz/.dbt",
            target="/root",
            type="bind",
        ),
    ],
    dag=dag,
)

task1 >> task2
