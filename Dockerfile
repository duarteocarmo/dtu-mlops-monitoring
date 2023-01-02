FROM python:3.9

COPY requirements.txt /tmp/
RUN pip install --upgrade pip 
RUN pip install torch --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install -r /tmp/requirements.txt

RUN mkdir -p /src
COPY src/ /src/
RUN pip install -e /src

# Honeycomb
ENV OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
ENV OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team=cFqh5eb7eCvjzViKhPpRcF"
ENV OTEL_SERVICE_NAME="email-data-extraction"

WORKDIR /

EXPOSE 80

CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "80"]
