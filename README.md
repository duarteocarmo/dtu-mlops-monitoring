<img src="https://designguide.dtu.dk/-/media/subsites/designguide/design-basics/logo/dtu_logo_hvid.jpg" width=220  align="right">

# OpenTelemetry FastAPI demo

### Set up the API

1. Clone this repo 
1. Make sure you are running in a virtual environment (e.g., `python3 -m venv .env`)
2. Activate it (e.g. `source .env/bin/activate`)
3. Install dependencies (we use [pip-tools](https://github.com/jazzband/pip-tools) for dependency management)

```shell
(.env) $ make install-dev
```

4. Run the tests

```shell
(.env) $ make test
```

5. For more help:
```shell
(.env) $ make help


