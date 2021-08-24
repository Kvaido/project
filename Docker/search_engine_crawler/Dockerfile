FROM python:3.6.0-alpine

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir -r /app/requirements.txt -r /app/requirements-test.txt

ENV MONGO=mongodb
ENV MONGO_PORT=27017
ENV RMQ_QUEUE=mqqueue
ENV RMQ_HOST=rabbitmq
ENV RMQ_USERNAME=guest
ENV RMQ_PASSWORD=guest
ENV CHECK_INTERVAL=10
ENV EXCLUDE_URLS=".*github.com"
ENV PYTHONUNBUFFERED 1


CMD ["/bin/bash"]
ENTRYPOINT EXCLUDE_URLS='.*github.com' python crawler/crawler.py https://vitkhab.github.io/search_engine_test_site/

