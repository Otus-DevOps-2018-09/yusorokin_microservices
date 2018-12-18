# yusorokin_microservices
yusorokin microservices repository


## Homework 12

### Основное задание
* Настроил интеграция с travis;
* Установил docker, docker-compose, docker-machine;
* Запустил первый контейнер hello-world;
* Научился выводить список контейнеров (docker ps) и образов (docker images);
* Познакомился с командами docker start и attach;
* Изучил параметры запуска контейнера (-i, -t, -d);
* Использовал docker exec;
* Создал новый образ из измененного контейнера командой docker commit;
* Изучил docker kill, stop, system df, rm, rmi;
* Удалил все контейнеры и образы.

### Задание со *
Описание контейнера в отличие от образа содержит в себе:
* Описание образа, из которого он был запущен;
* Параметра сети;
* Подключенные тома;
* Состояние контейнера;
* Пути к директориям контейнера (логи, хранилище, подключенные директории и пр.);
* Параметры запуска;
* Параметры хоста.

Описание образа в отличие от контейнера содержит:
* Описание образа;
* Описание репозитория образов;
* Описание родительского образа.


## Homework 13

### Основное задание
* Создал новый проект в GCE;
* Настроил gcloud для работы с новым проектом;
* Установил docker-machine;
* Создал в GCE машину с помощью docker-machine;
* Переключился на работу с удаленным докером `eval $(docker-machine env docker-host)`;
* Проверил изоляцию PID namespace:
* * ```
    docker run --rm -ti tehbilly/htop
    docker run --rm --pid host -ti tehbilly/htop
    ```
* * При использовании `--pid host` контейнер получает доступ к процессам хоста;
* Включил изоляцию user namespace:
* * В файл `/etc/docker/daemon.json` записал строки:
    ```
    {
      "userns-remap": "default"
    }
    ```
* * Перезапустил демон докера;
* * При запуске докер создал пользователя dockremap:
    ```
    $ id dockremap
    uid=112(dockremap) gid=116(dockremap) groups=116(dockremap)
    ```
* * Пользователю был присвоен диапазон пидов:
    ```
    $ grep dockremap /etc/subuid
    dockremap:231072:65536

    $ grep dockremap /etc/subgid
    dockremap:231072:65536
    ```
* * Запустил контейнер hello-world, при этом в /var/lib/docker/ создался каталог с именем `<UID>.<GID>`, который является по сути копией /var/lib/docker/ с правами под нового пользователя:
    ```
    $ sudo ls -ld /var/lib/docker/231072.231072/
    drwx------ 11 231072 231072 11 Jun 21 21:19 /var/lib/docker/231072.231072/

    $ sudo ls -l /var/lib/docker/231072.231072/
    total 14
    drwx------ 5 231072 231072 5 Jun 21 21:19 aufs
    drwx------ 3 231072 231072 3 Jun 21 21:21 containers
    drwx------ 3 root   root   3 Jun 21 21:19 image
    drwxr-x--- 3 root   root   3 Jun 21 21:19 network
    drwx------ 4 root   root   4 Jun 21 21:19 plugins
    drwx------ 2 root   root   2 Jun 21 21:19 swarm
    drwx------ 2 231072 231072 2 Jun 21 21:21 tmp
    drwx------ 2 root   root   2 Jun 21 21:19 trust
    drwx------ 2 231072 231072 3 Jun 21 21:19 volumes
    ```
* * Благодаря этому обеспечивается лучшая изоляция процессов и их доступа к файлам, при этом процессы не знают о своих ограничениях. Тем самым предотвращается эскалация привилегий;
* Создал файлы шаблонов для деплоя приложения;
* Создал Dockerfile по инструкции и запустил сборку образа `docker build -t reddit:latest .`;
* Запустил контейнер `docker run --name reddit -d --network=host reddit:latest`;
* Получил ошибку при проверке о недоступности хоста, добавил правило файерволла через gcloud;
* Проверил работу приложения в контейнере;
* Добавил тэг к созданному образу `docker tag reddit:latest <your-login>/otus-reddit:1.0`;
* Загрузил образ в Docker hub `docker push <your-login>/otus-reddit:1.0`;
* Запустил контейнер на локальной машине `docker run --name reddit -d -p 9292:9292 <your-login>/otus-reddit:1.0`;
* Пожкспериментировал с командами докера в конце задания.

### Задание со *
* Создал директории:
    ```
    ├── docker-monolith
    │   ├── infra
    │   │   ├── ansible
    │   │   ├── packer
    │   │   └── terrafrom
    ```
* Написал плейбуки ansible для установки питона, пип, докера и запуска контейнера с приложением;
* Описал создание образа с помощью packer и создал образ;
* Описал в terraform инфраструктуру с деплоем приложения через ansible через провижининг terraform;
* Провижининг в терраформ можно отключить переменно `do_provision = false` и провижинить через ансибл самостоятельно.
