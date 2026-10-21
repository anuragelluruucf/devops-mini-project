"""Train a small Iris classifier once at startup (demo model, ~ms to train)."""
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier

_iris = load_iris()
CLASSES = list(_iris.target_names)
MODEL = RandomForestClassifier(n_estimators=50, random_state=42).fit(_iris.data, _iris.target)


def predict(features: list[float]) -> dict:
    proba = MODEL.predict_proba([features])[0]
    idx = int(proba.argmax())
    return {"species": CLASSES[idx], "confidence": round(float(proba[idx]), 3)}
