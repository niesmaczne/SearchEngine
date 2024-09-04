FROM docker.io/library/python:3.12-alpine

WORKDIR /searchengine

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY main.py main.py

ENTRYPOINT ["python3", "/searchengine/main.py"]
