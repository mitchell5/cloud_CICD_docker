from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello with the updated code": "From the cloud!"}
