FROM python:3.9-slim

RUN pip install flask

COPY app.py /app.py

WORKDIR /

EXPOSE 80

CMD ["python", "app.py"]
