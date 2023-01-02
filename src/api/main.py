import hashlib
import random
from loguru import logger

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
    logger.info("Received request")

    # make predictions
    label = random.choice(["happy", "sad"])
    label_probability = random.random()
    logger.info("Made prediction")

    # save some features to opentelemetry
    current_span.set_attribute("message", features.message)  # <- Saves attribute
    current_span.set_attribute("label_probability", label_probability)
    current_span.set_attribute("label", label)

    response = ResponseModel(label=label, label_probability=label_probability)
    logger.info("Built response")

    return response
