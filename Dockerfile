ARG PYTHON_VERSION=3.10
ARG MARIADB_CLIENT_VERSION=10.5


FROM python:${PYTHON_VERSION}-slim-bullseye

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    mariadb-client-${MARIADB_CLIENT_VERSION} && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Provide the default MLflow variables to be overwritten as envs
# Reference for default values: https://mlflow.org/docs/latest/cli.html#mlflow-server
ENV MLFLOW_HOST=0.0.0.0
ENV MLFLOW_PORT=5000
ENV MLFLOW_BACKEND_STORE_URI="./mlruns"
ENV MLFLOW_DEFAULT_ARTIFACT_ROOT="./mlruns"
ENV MLFLOW_REGISTRY_STORE_URI=${MLFLOW_BACKEND_STORE_URI}
ENV MLFLOW_SERVE_ARTIFACTS=True

# Settings for the SQL queries
ENV MLFLOW_SQLALCHEMYSTORE_POOL_SIZE=10
ENV MLFLOW_SQLALCHEMYSTORE_MAX_OVERFLOW=10

CMD ["/bin/bash", "-c", "mlflow server"]