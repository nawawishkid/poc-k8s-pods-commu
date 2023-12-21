FROM python:3.9

COPY . /app
WORKDIR /app

RUN pip install fastapi uvicorn httpx

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
