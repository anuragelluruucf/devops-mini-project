from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    r = client.get("/healthz")
    assert r.status_code == 200 and r.json()["status"] == "ok"


def test_predict_setosa():
    r = client.post("/predict", json={"sepal_length": 5.1, "sepal_width": 3.5,
                                      "petal_length": 1.4, "petal_width": 0.2})
    assert r.status_code == 200 and r.json()["species"] == "setosa"


def test_validation():
    r = client.post("/predict", json={"sepal_length": -1, "sepal_width": 3,
                                      "petal_length": 1, "petal_width": 1})
    assert r.status_code == 422
