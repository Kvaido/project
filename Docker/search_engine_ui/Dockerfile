FROM python:3.6.0-alpine

WORKDIR /app/ui
ADD . /app

RUN pip install --no-cache-dir -r /app/requirements.txt -r /app/requirements-test.txt

ENV MONGO=mongodb
ENV MONGO_PORT=27017
ENV FLASK_APP=ui.py

CMD ["/bin/bash"]
ENTRYPOINT gunicorn -b 0.0.0.0 ui:app

