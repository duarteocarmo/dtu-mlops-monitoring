import hashlib
import random

import fastapi
from fastapi.responses import RedirectResponse
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import (
    OTLPSpanExporter,
)
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

from .models import RequestModel, ResponseModel

# set up tracing and open telemetry
provider = TracerProvider()
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
tracer = trace.get_tracer(__name__)

# instrument FastAPI
app = fastapi.FastAPI(title="demo")
FastAPIInstrumentor.instrument_app(app)


@app.get("/")
async def root():
    return RedirectResponse("/docs")


@app.post("/predict/", response_model=ResponseModel)
def predict(features: RequestModel):
    # get the current span
    current_span = trace.get_current_span()

    # hash input
    input_hash = hashlib.md5(features.message.encode("utf-8")).hexdigest()

    # save hash to opentelemetry
    current_span.set_attribute(
        "app.demo.input_hash", input_hash
    )  # <- Saves attribute

    # return predictions

    label = random.choice(["happy", "sad"])
    label_probability = random.random()

    response = ResponseModel(label=label, label_probability=label_probability)

    return response
