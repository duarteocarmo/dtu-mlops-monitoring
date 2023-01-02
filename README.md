<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Danmarks_Tekniske_Universitet_%28logo%29.svg/1413px-Danmarks_Tekniske_Universitet_%28logo%29.svg.png" width=100  align="right">

# OpenTelemetry FastAPI demo

This demo shows how to monitor a [FastAPI](https://fastapi.tiangolo.com/) application with [OpenTelemetry](https://opentelemetry.io/). 

You might be interested in this if you are running a FastAPI application, and are interested in monitoring some metrics regarding that microservice. 

[Signoz](https://signoz.io/) provides an opensource frontend to visualize your FastAPI metrics. 

### Run Signoz, locally

1. Make sure you have Docker and Docker compose installed. Check [this](https://get.docker.com/) if you don't. 
2. In a directory of your choosing, clone the SigNoz repository and cd into the signoz/deploy directory by entering the following commands:
```shell
$ git clone -b main https://github.com/SigNoz/signoz.git && cd signoz/deploy/
```
3. To install SigNoz, enter the `docker-compose up` command, specifying the following:
```shell
$ docker-compose -f docker/clickhouse-setup/docker-compose.yaml up -d
```
4. Navigate to `http://localhost:3301` in your machine. 
5. Log in, etc. 


### Set up the API

1. Clone this repo 
1. Make sure you are running in a virtual environment (e.g., `python3 -m venv .env`)
2. Activate it (e.g. `source .env/bin/activate`)
3. Install dependencies (we use [pip-tools](https://github.com/jazzband/pip-tools) for dependency management)

```shell
(.env) $ make install-dev
```

4. Run the api

```shell
(.env) $ make api
```

5. Navigate to `Services` in the Signoz application (e.g., `http://localhost:3301/services`)
6. `mlops-demo` should pop up. 
7. Go ahead and explore :)


### Play with the API

For other options in the repo:
```shell
(.env) $ make help
```





