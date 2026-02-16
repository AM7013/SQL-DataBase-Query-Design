FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY etl_pipeline.py .
COPY cleaned_data_v1.csv .

CMD ["python", "etl_pipeline.py"]