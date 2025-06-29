# ELT Pipeline with Apache Airflow and dbt

A simple Extract, Load, Transform (ELT) pipeline project that uses Apache
Airflow for orchestration, PostgreSQL for data storage, and dbt for data transformation. The project is organized into
several branches, each focusing on a specific implementation.

## Architecture Overview

This project implements a modern ELT pipeline with the following components:

- **Source Database**: PostgreSQL instance containing sample film and user data
- **Destination Database**: PostgreSQL instance for storing transformed data
- **ELT Script**: Python script that extracts data from source and loads it to destination
- **Apache Airflow**: Orchestrates the entire pipeline workflow
- **dbt**: Transforms and models the data in the destination database
- **Docker**: Containerized deployment for all services

## Project Structure

```
PythonProject/
├── airflow/
│   ├── airflow.cfg          # Airflow configuration
│   └── dags/
│       └── elt_dag.py       # Main Airflow DAG
├── custom_postgres/         # dbt project
│   ├── models/
│   │   └── example/         # dbt models
│   ├── macros/              # dbt macros
│   └── dbt_project.yml      # dbt configuration
├── elt/
│   ├── Dockerfile           # ELT script container
│   └── elt_script.py        # Data extraction and loading script
├── source_db_init/
│   └── init.sql             # Source database initialization
├── docker-compose.yaml      # Service orchestration
├── Dockerfile               # Main application container
└── start.sh                 # Startup script
```

## Resources

- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
- [dbt Documentation](https://docs.getdbt.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
