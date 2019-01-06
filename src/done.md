* Ругалось на отсутствие gcc. Добавил в `post-py/Dockerfile` команду `RUN apk update && apk add build-base`.
* Сборка ui началась именно с первого шага. Возможно имелось в виду то, что образ ruby:2.2 уже имелся

# Задание со * (1)
```
docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest && \
docker run -d --network=reddit --network-alias=new_post -e POST_DATABASE_HOST=new_post_db yurich00/post:1.0 && \
docker run -d --network=reddit --network-alias=new_comment -e COMMENT_DATABASE_HOST=new_comment_db yurich00/comment:1.0 && \
docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=new_post -e COMMENT_SERVICE_HOST=new_comment yurich00/ui:1.0
```

# Задание со * (2)
## Размер контейнера ui
```
FROM ruby:2.3-alpine
RUN apk update \
    && apk add build-base \
    && rm -rf /var/cache/apk/*
...
RUN bundle install && apk del build-base
```

`yurich00/ui            3.0_alpine          20e811537624        2 seconds ago       136MB`

/etc/docker/daemon.json
```
{
    "experimental": true
}
```

```
yurich00/ui            2.0_alpine          0f6ab492035c        7 seconds ago       136MB
yurich00/post          2.0_alpine          ad4917ef894f        4 minutes ago       109MB
yurich00/comment       2.0_alpine          190278e4f748        13 minutes ago      134MB
```
