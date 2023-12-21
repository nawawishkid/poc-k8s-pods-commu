from fastapi import FastAPI

app = FastAPI()


@app.post("/receive")
async def receive_message(message: str):
    return {"received_message": message}
