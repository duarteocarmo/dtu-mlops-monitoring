FROM python:3.10

COPY src/ /src/
COPY README.md README.md
COPY requirements.txt requirements.txt
COPY pyproject.toml pyproject.toml
COPY Makefile Makefile

ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4318/"
ENV OTEL_SERVICE_NAME="mlops-demo"

WORKDIR /

RUN make install

EXPOSE 80

ENTRYPOINT ["python", "-m", "uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "80"]
