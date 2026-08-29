from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "FastAPI fonctionne sur Jetson Nano !"}

@app.get("/test")
def test():
    return {"status": "OK"}
