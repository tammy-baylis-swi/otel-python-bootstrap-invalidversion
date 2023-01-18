import requests

from flask import Flask
from opentelemetry import trace

app = Flask(__name__)
tracer = trace.get_tracer(__name__)

@app.route("/test/")
def test_trace():
    """Makes request traced by autoinstrumentation
    and span started manually with OTel SDK"""
    with tracer.start_as_current_span("test_manual_outer"):
        current_span = trace.get_current_span()
        current_span.set_attribute("test.custom_attribute", "outer-foo-bar")
        requests.get("https://news.ycombinator.com/")
        return "Done"
