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
