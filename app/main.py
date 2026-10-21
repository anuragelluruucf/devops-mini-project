import os
from fastapi import FastAPI
from pydantic import BaseModel, Field
from app.model import predict

app = FastAPI(title="ml-inference-demo", version=os.getenv("APP_VERSION", "dev"))


class Flower(BaseModel):
    sepal_length: float = Field(gt=0)
    sepal_width: float = Field(gt=0)
    petal_length: float = Field(gt=0)
    petal_width: float = Field(gt=0)


@app.get("/healthz")
def healthz():
    return {"status": "ok", "version": app.version}


@app.post("/predict")
def do_predict(f: Flower):
    return predict([f.sepal_length, f.sepal_width, f.petal_length, f.petal_width])
