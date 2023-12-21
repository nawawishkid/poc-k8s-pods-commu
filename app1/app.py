import os
from fastapi import FastAPI
import httpx

app = FastAPI()
app2_url = os.environ.get("APP2_URL")


@app.post("/send")
async def send_message(message: str):
    async with httpx.AsyncClient() as client:
        print(f"Sending message to {app2_url}...")
        response = await client.post(app2_url, params={"message": message})
    return {"response_from_app2": response.json()}
