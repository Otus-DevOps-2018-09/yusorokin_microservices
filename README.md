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


## Homework 14

### Основное задание
* Добавил каталог src с сервисами, распакованными внутри;
* Добавил Dockerfile-ы для сервисов post-py, comment, ui;
* Скачал последний образ MongoDB через docker pull;
* Собрал образы всех сервисов;
* Сборка ui началась не с первого шага, так для шагов, идентичным сборке comment были использованы образы из кеша;
* Создал сеть `docker network create reddit`;
* Запустил контейнеры в созданной ранее сети и проверил работу приложения;
* Выполнил задание со * (1);
* Поменял содержимое ui/Dockerfile для уменьшения размера образа;
* Сборка началась со второго шага, так как базовый образ присутствовал, но команда RUN была изменена;
* Выполнил задание со * (2);
* Создал раздел `docker volume create reddit_db` и подключил его к монго `-v reddit_db:/data/db `;
* Запустил контейнеры, создал пост, перезапустил контейнеры и убедился, что созданный ранее пост на месте.

### Задание со * (1)
* Запустил приложение с новыми сетевыми алиасами и переопределенными переменными окружения алиасов, проверил работоспособность:
    ```
    docker run -d --network=reddit \
        --network-alias=new_post_db \
        --network-alias=new_comment_db mongo:latest && \
    docker run -d --network=reddit \
        --network-alias=new_post \
        -e POST_DATABASE_HOST=new_post_db yurich00/post:1.0 && \
    docker run -d --network=reddit \
        --network-alias=new_comment \
        -e COMMENT_DATABASE_HOST=new_comment_db yurich00/comment:1.0 && \
    docker run -d --network=reddit \
        -p 9292:9292 \
        -e POST_SERVICE_HOST=new_post \
        -e COMMENT_SERVICE_HOST=new_comment yurich00/ui:1.0
    ```

### Задание со * (2)
* Уменьшил образы до минимума, используя базовые образы `ruby:2.3-alpine` и `python:3.6.0-alpine`, минимальный набор пакетов и очистку кеша apk;
* В результате получились следующие образы:
    ```
    yurich00/ui        2.0_alpine  0f6ab492035c  7 seconds ago   136MB
    yurich00/post      2.0_alpine  ad4917ef894f  4 minutes ago   109MB
    yurich00/comment   2.0_alpine  190278e4f748  13 minutes ago  134MB
    ```
* Файлы полученных образов называются `Dockerfile.small`.


## Homework 15

### Основное задание
* Запустил контейнер с параметром `--network none`, проверил, что единственный доступный сетевой интерфейс у контейнера - это loopback;
* Запустил контейнер с параметром `--network host`, сравнил вывод команды ifconfig контейнера с выводом ifconfig хоста. Отличие только в том, что у контейнера после адреса IPv6 следует идентификатор области (сетевой интерфейс): <p>inet6 addr: fe80::42:f8ff:fe94:c1eb<strong><u>%32710</u></strong>/64 Scope:Link</p>
* Запустил несколько раз `docker run --network host -d nginx`, следующие после первого контейнера, контейнеры завершали свое выполнение. Причину узнал, когда запустил еще один контейнер в интерактивном режиме `docker run --network host -ti nginx`:
    ```
    2019/01/07 14:27:46 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
    nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
    2019/01/07 14:27:46 [emerg] 1#1: still could not bind()
    nginx: [emerg] still could not bind()
    ```
* На докер-хосте выполнил команду `sudo ln -s /var/run/docker/netns /var/run/netns`;
* Запуская контейнеры в неймспейсах `none` и `host`, и выполняя `ifconfig` в каждом неймспейсе получил следующее:
    * `null`:
    ```
    # sudo ip netns
    68a75034bdca

    # ip netns exec 68a75034bdca ifconfig
    lo ...
    ```
    * `host`:
    ```
    # sudo ip netns
    default

    # ip netns exec default ifconfig
    br-6630cc1a9a9e ...
    docker0 ...
    ens4 ...
    lo ...
    ```
* Запустил проект с драйвером сети `bridge`:
    ```
    docker run -d --network=reddit mongo:latest
    docker run -d --network=reddit <your-dockerhub-login>/post:1.0
    docker run -d --network=reddit <your-dockerhub-login>/comment:1.0
    docker run -d --network=reddit -p 9292:9292 <your-dockerhub-login>/ui:1.0
    ```
* Контейнеры не увидели друг-друга в сети, т.к. обращение было настроено по именам, а алиасов или имен контейнеров при запуске указано не было;
* Запустил контейнеры с алиасами:
    ```
    docker run -d --network=reddit --network-alias=post_db --networkalias=comment_db mongo:latest
    docker run -d --network=reddit --network-alias=post <your-login>/post:1.0
    docker run -d --network=reddit --network-alias=comment <your-login>/comment:1.0
    docker run -d --network=reddit -p 9292:9292 <your-login>/ui:1.0
    ```
* Создал сети и запустил в них контейнеры:
    ```
    docker network create back_net --subnet=10.0.2.0/24
    docker network create front_net --subnet=10.0.1.0/24

    docker run -d --network=front_net -p 9292:9292 --name ui <your-login>/ui:1.0
    docker run -d --network=back_net --name comment <your-login>/comment:1.0
    docker run -d --network=back_net --name post <your-login>/post:1.0
    docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
    ```
* Схема не заработала, т.к. Docker при инициализации контейнера может подключить к нему только 1
сеть;
* Подключил контейнеры `post` и `comment` ко второй сети и приложение заработало:
    ```
    docker network connect front_net post
    docker network connect front_net comment
    ```
* Установил на докер-хосте bridge-utils;
* Выполнил `docker network ls`, получил список созданных сетей;
* Выполнил `ifconfig | grep br`, увидел список мостов;
* Посмотрел информацию о мостах с помощью `brctl show <interface>`;
* Выполнил `sudo iptables -nL -t -v nat`, посмотрел информацию о маршрутах iptables;
* Выполнил `ps ax | grep docker-proxy`, нашел процесс docker-proxy;
* Установил docker-compose;
* Создал docker-compose.yml;
* Выполнил:
    ```
    export USERNAME=<your-login>
    docker-compose up -d
    docker-compose ps
    ```
* Проверил работу приложения;
* Создал файл .env, внес туда переменные окружения версии образов приложения, порт UI и имя пользователя в Docker Hub. Продублировал файл в .env.example, внес .env в .gitignore;
* Узнал, как образуется имя запускаемого контейнера - имя текущей директории + имя образа + номер п/п. Имя контейнера можно изменить с помощью директивы container_name;
* Выполнил задание со *.

### Задание со *
* Создал docker-compose.override.yml;
* Примонтировал в нем к каждому контейнеру его директорию с кодом приложения, что позволило вносить правки в код при запущенном контейнере;
* Переопределил команду для запуска руби-приложений директивой `command: puma --debug -w 2`.


## Homework 16

### Основное задание
* Создал сервер GitLab использовав Terraform, скрипты лежат в директории `gitlab-ci/terraform`;
* Развернул GitLab на созданном сервере с помощью Ansible (`gitlab-ci/ansible`). Плейбук для поднятия сервиса - `site.yml`, он включает в себя:
* * Установку python и pip;
* * Установку docker;
* * Создание требуемых директорий;
* * Копирование шаблона docker-compose;
* * Установку требуемых пакетов pip для работы с docker-compose;
* * Поднятие контейнера Gitlab;
* Произвел настройку GitLab, создал группу и проект;
* Добавил созданный проект в remotes в локальный репозиторий, пушнул локальный репозиторий в гитлаб;
* Создал скрипт `.gitlab-ci.yml` и пушнул его в гитлаб;
* Запустил runner на хосте с гитлаб;
* Зарегистрировал раннер и увидел, что пайплайн успешно выполнился;
* Склонировал репозиторий https://github.com/express42/reddit.git в текуший репозиторий, пушнул его в гитлаб;
* Изменил код скрипта `.gitlab-ci.yml`, добавив тестирование руби-приложения;
* Создал скрипт `reddit/simpletest.rb`, добавил гем `rack-test` в `Gemfile`;
* Пушнул все изменения в гитлаб, проверил статус пайплайна;
* Выполнил задания со *.

### Задание со *
* Написал плейбук для поднятия GitLab Runner, который выполняет:
* * Установку python, pip и пакета pip docker;
* * Запуск раннера в докере;
* * Проверку уже зарегистрированного раннера и регистрацию его, если он не был ранее зарегистрирован;
* Синтегрировал Slack и GitLab в канал `https://devops-team-otus.slack.com/messages/CDAKS754G`.


## Homework 17

### Основное задание
* Создал новый проект example2 в GitLab, включил раннер в этом проекте;
* Добавил в `.gitlab-ci.yml` окружение dev;
* Определил два новых этапа staging и production с запуском в ручном режиме;
* Определил для этих этапов ограничения в виде регулярных выражений `/^\d+\.\d+\.\d+/`, для запуска этих этапов только если запушен тег;
* Добавил задание branch_review с условием запуска только если пуш был в ветку, отличную от master;
* Выполнил задания со *.

### Задания со *
* Изменил задание `branch_review` для создания окружения в GCP:
* * Создал в GitLab CI переменные:
    ```
    GC_CRED - json-ключ для сервисного аккаунта google;
    GC_PROJECT - ID проекта;
    GC_ZONE - зона, где будет создан инстанс;
    ```
* * В качестве образа задания использовал `google/cloud-sdk:latest`;
* * Настроил соединение с gcloud с помощью заданного в переменной GC_CRED ключа от сервисного аккаунта;
* * Установил docker-machine;
* * Создал с помощью docker-machine инстанс в GCP с docker на борту;
* * Приаттачил docker-engine на раннере с engine на созданной в облаке машине;
* * Добавил параметр окружения `on_stop: stop_branch_review` для запуска задания удаления машины в облаке при остановке текущего окружения;
* Для удаления удаленной машины создал новое задание `stop_branch_review` с запуском по кнопке:
* * Использовал тот же образ `google/cloud-sdk:latest`;
* * Настроил подключение через gcloud;
* * Описал удаление инстанса с помощью gcloud и остановку окружения GitLab;
* Описал сборку приложения `docker-monolith` в задании `build_job`:
* * Для сборки docker-in-docker пришлось переподнять раннер с параметром `--docker-volumes /var/run/docker.sock:/var/run/docker.sock` и использованием образа `docker`;
* * Использовал переменные `DOCKER_LOGIN` и `DOCKER_PASS` для хранение учтных данных;
* * Залогинился в docker с командой `echo ${DOCKER_PASS} | docker login --username ${DOCKER_LOGIN} --password-stdin`;
* * Собрал образ `docker-monolith` с тегом `${DOCKER_LOGIN}/reddit:${CI_COMMIT_SHA}`;
* * Пушнул собранный образ в свой докер-репозиторий;
* Деплой приложения описал также в задании `branch_review`:
* * Запустил контейнер с помощью приаттаченного ранее docker-engine созданной машины в облаке - `docker run -d -p 9292:9292 ${DOCKER_LOGIN}/reddit:${CI_COMMIT_SHA}`.


## Homework 18

### Основное задание
* Запустил Prometheus из готового образа;
* Ознакомился с веб-интерфейсом;
* Упорядочил директории;
* Создал докерфайл для Prometheus;
* Создал файл конфигурации `prometheus.yml`;
* Собрал образ prometheus;
* Собрал образы приложения reddit;
* Добавил сервис prometheus в `docker-compose.yml`;
* Поднял сервисы через docker-compose;
* Проверил в прометеус, что все таргеты в поднятом состоянии;
* Проверил healthcheck ui, он отображал 0, поправил алиасы БД;
* Остановил post, увидел, что сервис ui стал незодров, убедился, что это из-за post;
* Запустил post, мониторинг снова показал, что все хорошо;
* Определил node-exporter в `docker-compose.yml`;
* Добавил конфигурацию джоба в `prometheus.yml`, пересобрал прометеус;
* Перезапустил сервисы, посмотрел метрики node_exporter;
* Создал нагрузку на ЦП и убедился, что мониторнг отображает эту нагрузку;
* Пушнул образы в свой реджистри;
* Выполнил задания со *.

### Задание со * (1)
* Для мониторинга монги использовал percona/mongodb_exporter;
* Создал докерфайл с описанием билда;
* Добавил экспортер в `docker-compose.yml`;
* Добавил джоб в `prometheus.yml`.

### Задание со * (2)
* Добавил balckbox_exporter в `docker-compose.yml`;
* Добавил джоб balckbox_exporter в `prometheus.yml` с целью мониторить 200-е ответы от сервисов.

### Задание со * (3)
* Создал Makefile с возможностью собирать все образы сразу и каждый по отдельности, а также пушить их в реджистри.

### Ссылка на реджистри
https://hub.docker.com/u/yurich00/


## Homework 19

### Основное задание
* Выделил из файла docker-compose в файл docker-compose-monitoring описание сервисов мониторинга;
* Добавил описание сервиса cAdvisor в compose-файл, добавил таргет cAdvisor в prometheus.yml;
* Запустил проект, пощупал интерфейс cAdvisor;
* Добавил Grafana в compose-файл;
* Запустил и настроил графану;
* Скачал с сайта графаны дэшборд с мониторингом докера, импортировал его в графану, сохранил его также в папке monitoring/grafana/dashboards;
* Добавил в prometheus.yml таргет posr с метриками приложения;
* Перезапустил мониторинги, добавил несколько постов в приложение и проверил, что метрики post работают;
* Создал дэшборд `UI service monitoring`, добавил туда панель `UI HTTP Requests` с метрикой **ui_request_count**;
* Добавил панель `Rate of UI HTTP requests with error` с метрикой **rate(ui_request_count{http_status=~"^[45].*"}[1m])**, сгенерировал 400-х ошибок и убедился, что график их отображает;
* Посмотрел историю изменений дэшюорда;
* Изменил панель `UI HTTP Requests`, довив функцию rate к метрике (**rate(ui_request_count[5m])**), переименовал панель в `Rate of UI HTTP Requests`;
* Добавил новую панель `HTTP response time 95th percentile` с метрикой **histogram_quantile(0.95, sum(rate(ui_request_latency_seconds_bucket[5m])) by (le))**;
* Соханил дэшборд, экспортировал его и сохранил в папке monitoring/grafana/dashboards;
* Создал новый дэшборд `Business_Logic_Monitoring`, добавил на него панель `Posts Rate` с метрикой **rate(post_count[1h])**;
* Добавил панель `Comments Rate` с метрикой **rate(comment_count[1h])**, сохранил и экспортировал в папку с дэшбордами;
* Создал директорию monitoring/alertmanager, а в ней Dockerfile и config.yml;
* В config.yml описал интеграцию со Slack и маршрут алертинга, собрал образ;
* Добавил alertmanager в компоуз-файл;
* Создал в директории прометеус файл alerts.yml, где описал правило алертинга на падение инстансов;
* Добавил этот файл в Dockerfile, подключил его и описал подклчение к alertmanager в prometheus.yml, пересобрал образы;
* Перезапустил мониторинги и проверил работу алертов;
* Пушнул все собранные образы хаб;
* Выполнил часть заданий со *.

### Задание со * (1)
* Добавил в Makefile все собираемые образы;
* Метрики Docker Engine:
* * Прописал в настройках докер-демона (/etc/docker/daemon.json) `{ "metrics-addr" : "0.0.0.0:9323", "experimental" : true }`, перезапустил демон;
* * Добавил в promehteus.yml таргет с этими метриками;
* * Метрики включают в себя в основном состояние docker engine, нет детальной информации по контейнерам в отличие от cAdvisor;
* * Импортировал с сайта графаны готовый дэшборд `Docker Engine Metrics`, сохранил его также в папке со всеми остальными дэшбордами;
* Telegraf:
* * Создал каталог monitoring/grafana/telegraf и файл конфига telegraf.conf;
* * В telegraf.conf описал настройки экспортера метрик докера и отдачу в формате прометеус;
* * Описал сборку образа с добавлением файла конфига в него, добавил сервис телеграфа в компоуз-файл;
* * Добавил таргет в конфиг прометеуса;
* * Нашел дэшборд где-то в интернете, на сайте графаны под прометеус подобного не было;
* * Добавил дэшборд в репозиторий;
* Создал алерт на примере 95 процентиля;
* Настроил интеграцию alertmanager с Gmail, однако выяснил, что alertmanager не умеет в секреты, поэтому все секреты пришлось прописывать прямо в конфиге.

### Задание со * (2)
* Grafana Deploy:
* * Создал файл `monitoring/grafana/dashboard_provisoning/dashboards.yml` с описанием деплоя дэшбордов;
* * Создал файл `monitoring/grafana/datasources/prometheus.yml` с описанием датасорса prometheus;
* * Создал Dockerfile и описал в нем копирование всех файлов деплоя по нужным директориям;
* Stackdriver exporter:
* * В качестве экспортера использовал https://github.com/frodenas/stackdriver_exporter;
* * В компоуз-файле описал в качестве секрета json-файл для авторизации в GCP;
* * Описал сервис `stackdriver_exporter` с подключением секрета и настройками экспортера;
* * Создал небольшой дэшборд с несколькими метриками, сохранил в каталоге с дэшбордами;
* * Набор метрик получился следующий:
    ```
    stackdriver_exporter_build_info
    stackdriver_gce_instance_compute_googleapis_com_firewall_dropped_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_firewall_dropped_packets_count
    stackdriver_gce_instance_compute_googleapis_com_instance_cpu_reserved_cores
    stackdriver_gce_instance_compute_googleapis_com_instance_cpu_usage_time
    stackdriver_gce_instance_compute_googleapis_com_instance_cpu_utilization
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_read_ops_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_read_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_read_ops_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_write_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_throttled_write_ops_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_disk_write_ops_count
    stackdriver_gce_instance_compute_googleapis_com_instance_integrity_early_boot_validation_status
    stackdriver_gce_instance_compute_googleapis_com_instance_integrity_late_boot_validation_status
    stackdriver_gce_instance_compute_googleapis_com_instance_network_received_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_network_received_packets_count
    stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_bytes_count
    stackdriver_gce_instance_compute_googleapis_com_instance_network_sent_packets_count
    stackdriver_gce_instance_compute_googleapis_com_instance_uptime
    ```

### Ссылка на реджистри
https://hub.docker.com/u/yurich00/

### Канал Slack для алертов
https://devops-team-otus.slack.com/messages/CDAKS754G


## Homework 20

### Основное задание
* Обновил код приложения src;
* Добавил в Dockerfile post установку `gcc` и `musl-dev`;
* Пересобрал все образы приложения reddit;
* Создал докер-хост;
* Создал docker-compose-logging.yml;
* Elasticsearch не проставляет тэг latest своим образам, так как считает это плохой практикой, использовал версию 6.6.0 для Kibana и Elasticsearch;
* Elasticsearch не захотел заводиться с параметрами из ДЗ, нагуглил по коду ошибки, что нужно передать в окружение следующие параметры
    ```
    environment:
        transport.host: localhost
        network.host: 0.0.0.0
    ```
    и открыть порт 9300;
* Создал Dockerfile для fluentd в директории logging/fluentd;
* Там же создал fluent.conf, заполнил его и собрал образ fluentd;
* Запустил приложение и понаблюдал за логами post;
* Описал в компоуз файле использование для сервиса post логгирования через fluentd, переподнял контейнеры;
* Открыл Кибана и создал паттерн индексов (`И создадим индекс маппинг`, - такой опции я не нашел, судя по скрину она уже была устаревшей и ее выпилили);
* Ознакомился с интерфейсом Кибана, нашел логи post, попробовал использовать поиск по логам;
* Добавил во fluent.conf фильтр для парсинга JSON для сервиса post;
* Перезапустил fluent и убедился в кибана, что json-поле распарсилось;
* Добавил в компоуз-файле вывод логов в fluent для ui;
* Перезапустил приложение и проверил как собираются логи от ui;
* Добавил во fluent.conf фильтр для парсинга логов ui через регулярное выражение;
* Перезапустил сервисы логгирования и проверил как распарсились логи ui;
* Заменил фильтр для логов ui с регулярным выражением на grok-pattern;
* Добавил еще один парсинг через grok-pattern для парсинга оставшейся части лога ui;
* Выполнил задание со * (1);
* Добавил Zipkin в `docker-compose-logging.yml` (использовал версию 2.11.8, т.к. последняя версия багованая, не отображает время спанов);
* Добавил для каждого сервиса в `docker-compose.yml` переменую окружения ZIPKIN_ENABLED=true и пересоздал все сервисы;
* Открыл интерфейс zipkin и нашел запросы от ui_app;
* Запрос на загрузку главной страницы у меня состоял из двух спанов, в отличие от приведенного примера в ДЗ, у меня отсутствовал запрос от **post** к **db**;
* Выполнил задание со * (2).

### Задание со * (1)
* Добавил еще один grok-pattern для парсинга второй части лога ui. Фильтр `service.ui` стал выглядеть следующим образом:
```
<filter service.ui>
@type parser
format grok
<grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
</grok>
<grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IPV4:remote_addr} \| method=%{GREEDYDATA:method} \| response_status=%{INT:response_status}
</grok>
key_name message
reserve_data true
</filter>
```

### Задание со * (2)
* Склонировал забагованное приложение в каталог src_bugged;
* Добавил Dockerfile в сервисы и собрал образы с тегом `:bugged`;
* Создал копию 'docker-compose.yml', где изменил образы на bugged, поднял приложение;
* Нажал на созданный ранее пост, пост открылся с существенной задержкой;
* Открыл Zipkin и нашел в нем запрос загрузки поста, увидел, что он занимает `3.055s`;
* Виновником оказался спан post, запрос выполнялся немногим более трех секунд
```
http.method	GET
http.path	/post/5c6afe1cecfc09000e0c5c45
```
* Нашел в коде post_app.py функцию поиска поста `find_post` по маршруту `@app.route('/post/<id>')`, а в ней - строчки кода, вызывавшие задержку в три секунды
```python
max_resp_time = 3
...
median_time = time.sleep(max_resp_time)
```
* Закомментировал эти строчки и пост стал открываться за `53.005ms`.

### Ссылка на реджистри
https://hub.docker.com/u/yurich00/


## Homework 21

### Основное задание
* Описал манифесты сервисов reddit в директории kubernetes/reddit;
* Прошел The Hard Way, все созданные в ходе прохождения файлы сохранил в kubernetes/the_hard_way;
* Проверил, что `kubectl apply -f (ui, post, mongo, comment)` работает и поды создаются;
* Удалил кластер.

### Задание со *
* Создал директорию kubernetes/ansible;
* В качестве примера описал выполнение шагов `Installing the Client Tools` и `Provisioning Compute Resources`;
* Для шага `Provisioning Compute Resources` использовал `gce*` модули ansible, так как в модуле `gcp_compute_network` имеется баг, который при указании параметра `auto_create_subnetworks: false` создает сеть типа **legacy** вместо описанного в документации **custom**;
* Из-за использования модулей `gce*`, не удалось явно указать IP-адрес инстансам, как того требует The Hard Way, но, думаю, это не страшно.


## Homework 22

### Основное задание
* Установил и запустил minikube;
* Проверил, что нода создалась;
* Изучил файл конфига `~/.kube/config` и порядок настройки kubectl;
* Изменил файл деплоймента ui, запустил ui в кластере;
* Пробросил порт 9292 пода ui на порт 8080 моей машины, перешел на localhost:8080 и проверил, что страница ui открывается;
* Обновил деплойменты comment, post и mongo, в mongo дополнительно примонтировал раздел;
* Описал сервисы `comment-service.yml`, `post-service.yml` и `mongodb-service.yml`, запустил их;
* Пробросил порт ui 9292:9292, зашел на localhost:9292, увидел, что приложение не работает;
* В логах пода comment увидел, что нет доступа к comment_db;
* Создал два новых сервиса для mongo `comment-mongodb-service.yml` и `post-mongodb-service.yml`;
* Добавил в `mongo-deployment.yml` строчки `comment-db: "true"` и `post-db: "true"`;
* Прописал в переменных окружения деплойментов comment и post параметр подключения к mongp;
* Убедился, что приложение заработало;
* Удалил mongodb-service;
* Создал `ui-service.yml` с добавлением типа сервиса `type: NodePort` и указанием статичного порта;
* Запустил `minikube service ui`, открылось ссылка приложения;
* Нашел все запущенные компоненты аддона `dashboard` командой `kubectl get all -n kube-system --selector app=kubernetes-dashboard`;
* Зашел в дэшборд и ознакомился с его функциональностью;
* Создал и применил `dev-namespace.yml`, запустил приложение в неймспейсе **dev**;
* Добавил в `ui-deployment.yml` информацию об окружении, запустил и проверил, что она отображается;
* Зашел в консоль GKE и создал кластер с указанными параметрами, с разницей в том, что использовал дефолтную версию кластера, под `1.8.10-gke.0` кластер не смог развернуться, ругалось, что системные поды уже существуюти не позволяло им запуститься;
* Пока разбирался, почему не поднимается кластер 1.8.10-gke.0, изучил консоль GKE;
* Подключился к созданному кластеру, посмотрел, как изменился `~/.kube/config`, убедился, что kubecrl подключен к контексту кластера GKE;
* Создал dev неймспейс и развернул в нем приложение;
* Создал правило фаервола для ui;
* Зашел по адресу ноды и порту на сервис ui;
* Скриншот перед удалением кластера сделать забыл, но есть логи GCP https://www.radikal.kz/image/DLO;
* Включил панель управления Kubernetes для кластера;
* Выполнил `kubectl proxy` и перешел по ссылке http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/, вместо описанной в ДЗ нерабочей http://localhost:8001/ui;
* Получил ошибку RBAC;
* Назначил роль cluster-admin сервис-аккаунту дэшборда командой `kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard`;
* Перешел снова в панель у правления и убедился, что она работает.

### Задание со *
* Создал директорию kubernetes/terraform;
* Описал параметры создания кластера в файле `main.tf` по примеру из документации терраформ;
* Для биндинга сервис-аккаунта панели управления к роли cluster-admin, как уже выше описывал, я использовал команду `kubectl create clusterrolebinding kubernetes-dashboard  --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard`, но при добавлении параметра `-o yaml` команда сохраняет описание созданного объекта в YAML;
* Создал описанным выше способом файл `kubernetes-dashboard-rolebind.yaml`.

## Homework 23

### Основное задание
* Отключил kube-dns, изменив количество реплик в ноль, попробовал достучаться из comment в post, имя не зарезолвилось;
* Вернул количество реплик kube-dns как было;
* Настроил ui-service на использование балансировщика нагрузки (LoadBalancer);
* Применил изменения, проверил описание сервиса ui, перешел по адресу балансировщика и проверил работу приложения;
* Создал Ingress для сервиса ui;
* Изменил тип сервиса ui на NodePort;
* Добавил маршрутизацию трафика по пути /* на порт 9292 в Ingress;
* Выпустил самоподписанный сертифика для Ingress;
* Создал секрет в kubernetes с созадынным сертификатом;
* Отключил проброс HTTP в Ingress и подключил сертификат;
* Зашел на адрес приложения по HTTPS;
* Включил network-policy для кластера GKE;
* Создал сетевую политику, которая разрешает доступ к mongo только с comment;
* Обновил политику, добавив туда доступ к mongo для post;
* В итоге доступ запретить у меня не получилось;
* Создал несколько постов, удалил деплоймент mongo, создал его заново и убедился, что посты пропали;
* Создал диск в GCP с объемом в 25Gi и добавил новый раздел в деплоймент mongo;
* Применил изменения и убедился с помощью пересоздания деплоймента, что данные сохраняются;
* Создал описание PersistentVolume и добавил его в кластер;
* Создал описание PersistentVolumeClaim, добавил его также в кластер;
* Подключил PersistentVolumeClaim к деплойменту mongo, обновил деплоймент в кластере;
* Создал описание StorageClass’а и PersistentVolumeClaim с использованием этого класса;
* Подключил созданный PVC к деплойменту mongo;
* Проверил итоговую конфигурацию разделов.

### Задание со *
* Создал описание секрета в файле `ui-tls-secret.yaml`.


## Homework 24

### Основное задание
* Установил Helm, создал манифест тиллера, проинициализировал Helm;
* Создал директории под чарты, создал ui/Chart.yaml;
* Создал директорию ui/templates и перенес туда манифесты ui;
* Установил чарт ui;
* Шаблонизировал ui/templates/service.yaml, deployment.yaml и ingress.yaml, определил переменные в ui/values.yaml;
* Установил несколько релизов ui, проверил работу приложений;
* Кастомизировал переменными deployment.yaml, service.yaml и ingress.yaml, добавил новые переменные в values.yaml;
* Проапгрейдил релиз ui;
* Добавил шаблоны для post и comment;
* Описал функцию comment.fullname в _helpers.tpl, подменил названия на результат функции в нужных местах;
* Проделал аналогичное для ui и post;
* В директрии reddit/ создал необходимые файлы, загрузил зависимости;
* Нашел чарт монги, добавил его в файл зависимостей, обновил зависимости;
* Установил приложение с зависимостями;
* Добавил в ui/deployments.yaml шаблонизированные переменные окружения;
* Обновил зависимости и обновил релиз;
* Создал новый пул узлов в GKE под GitLab;
* Добавил репо гитлаба, скачал его чарт;
* Поправил необходимые конфиги;
* Установил чарт гитлаба, он не поднялся, уперся в лимиты по разммеру SSD в 100ГБ, поэтому пришлось подкрутить в конфиге размеры разделов:
```yaml
#postgresStorageSize: 30Gi
postgresStorageSize: 20Gi
#gitlabDataStorageSize: 30Gi
gitlabDataStorageSize: 20Gi
#gitlabRegistryStorageSize: 30Gi
gitlabRegistryStorageSize: 20Gi
```
* После этих манипуляций гитлаб запустился;
* Создал группу и проекты, добавил в переменные CI/CD группы даныне для входа в докер-хаб;
* Перенес исходники ui в Gitlab_ci/ui, проинициализировал репозиторий для гитлаба и пушнул код в него;
* Аналогичные действия сделал для post и comment;
* Перенес чарты в Gitlab_ci/reddit-deploy, пушнул в гитлаб;
* Создал Gitlab_ci/ui/.gitlab-ci.yml, пушнул, проверил пайплайн, повторил для post и comment;
* Обновил конфиг ингресса для ui;
* Создал ветку feature/3 в ui, обновил CI-скрипт, пушнул в гитлаб;
* Не деплоилось приложение из фича-бренча из-за ошибки совместимости версии тиллера, - изменил версию хельма на версию со своей машины в .gitlab-ci.yml (v2.13.0);
* Добавил в CI-скрипт стейдж удаления окружения, проверил работу пайплайна в гитлабе, проверил удаление окружения;
* Повторил те же шаги для post и comment;
* Создал reddit-deploy/.gitlab-ci.yml, пушнул в гитлаб, проверил пайплайн и окружения;
* Переместил файлы по описанным директориям, обновил .gitignore.

### Задание со *
* Создал в репозитории reddit-deploy триггер, токен триггера поместил в переменные CI/CD группы;
* В скрипте пайплайна reddit-deploy сделал, чтобы staging не запускался по триггеру, а production не запускался при пуше, отключил флаг ручного запуска;
* В скрипты пайплайна сервисов добавил функцию запуска триггера деплоя `run_deployment_to_prod`, описал новый стейдж **deploy** с использованием этой функции.


## Homework 25

### Основное задание
* Отключил в GKE Stackdriver Logging, Stackdriver Monitoring, включил Устаревшие права доступа;
* Установил ingress-контроллер nginx из helm-чарта;
* Добавил /etc/hosts имена хостов по адресу ингресса;
* Стянул чарт прометеуса из репозитория чартов хелм;
* Создал custom_values.yml;
* Установил прометеус;
* Включил в конфиге kube-state-metrics, обновил релиз;
* Включил node-exporter, обновил релиз, проверил метрики;
* Запустил релизы reddit-test, production и staging;
* Обновил конфиг, добавив джоб reddit-endpoints, обновил релиз;
* Добавил метки k8s и prometheus в конфиг релейбла;
* Добавил джоб reddit-production, обновил релиз;
* Разбил джоб reddit-endpoints на джобы по эндпойнтам ui, post и comment;
* Поставил grafana через helm;
* При входе указанный пароль не подошел, параметр `adminPassword=admin` не работает https://github.com/helm/charts/issues/7891, он создает секрет с паролем, но фактически не меняет пароль в графане, обошел это командой:
```bash
kubectl get secret grafana -o jsonpath='{.data.admin-password}' | \
base64 --decode | xargs -I {} kubectl exec -it grafana-59b795cfd8-hrjdf \
-- grafana-cli admin reset-admin-password --homepath /usr/share/grafana {}
```
* Добавил датасорс прометеуса, загрузил дэшборд кубернетиса;
* Добавил дэшборды, ранее созданные в предыдущих ДЗ (Business_Logic_Monitoring и UI_service_monitoring);
* Добавил на дэшборд UI_service_monitoring переменую namespace, в запросе вместо namespace использовал `kubernetes_namespace`;
* Добавил фильтр по переменной в графики дэшборда, то же самое проделал с дэшюордом Business_Logic_Monitoring;
* Все используемые в рамках этого ДЗ дэшборды сохранил в `kubernetes/grafana/dashboards`;
* Импортировал график №741;
* Выполнил задание со * (1);
* Выполнил задание со * (2);
* Для раздела про логгирование мощностей трех моих нод уже не хватало, поэтому добавил еще одну;
* Установил для нее лейбл elastichost=true;
* Создал директорию kubernetes/efk/, создал в ней необходимые манифесты и применил их;
* Установил кибану через хелм, настроил ее;
* Выполнил задание со * (3).

### Задание со * (1)
* Активировал alertmanager в чарте prometheus в `custom_values.yml`;
* Описал в разделе `alertmanagerFiles.alertmanager.yml` настройки alertmanager;
* В разделе `serverFiles.alerts` описал правила алертинга.

### Задание со * (2)
* Загрузил чарт Prometheus Operator в директорию `kubernetes/Charts/prometheus-operator`;
* Создал копию values.yaml, назвал ее custom_values.yml, далее все настройки выполнял в этой копии;
* Включил ингресс (`ingress.enabled=true`);
* Присвоил имя хоста (`hosts: ["prometheus-operator"]`);
* Настроил ServiceMonitor:
```yaml
  additionalServiceMonitors:
    - name: post-monitor
      selector:
        matchLabels:
          app: reddit
          component: post
      namespaceSelector:
        any: true
      endpoints:
        - port: post
```

### Задание со * (3)
* Создал в директории elasticsearch и fluentd в kubernetes/Charts, где описал чарты развертывания соответствующих сервисов;
* Там же создал директорию чарта efk, где описал зависимости от созданных ранее сервисов и добавил в зависимости kibana.
