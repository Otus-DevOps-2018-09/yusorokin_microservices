FROM python:3.6.0-alpine

WORKDIR /app
ADD . /app

RUN apk add --no-cache build-base gcc musl-dev && \
    pip install -r /app/requirements.txt && \
    apk del build-base gcc musl-dev

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
