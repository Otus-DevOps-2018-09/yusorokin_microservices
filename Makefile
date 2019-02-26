
include .mk_vars

objects_reddit = ui comment post
objects_monitoring = prometheus mongodb_exporter alertmanager grafana telegraf
objects_logging = fluentd
objects = $(objects_reddit) $(objects_monitoring) $(objects_logging)
objects_bugged = ui comment post

.PHONY : all
all : build push

.PHONY : build
build : $(objects_reddit) $(objects_monitoring) $(objects_logging)

$(objects_reddit) :
	@echo "\e[93m\e[1m-- Building $@ image --\e[0m"
	@cd src/$@* && sh docker_build.sh

$(objects_monitoring) :
	@echo "\e[93m\e[1m-- Building $@ image --\e[0m"
	@docker build -t $(USER_NAME)/$@ monitoring/$@

$(objects_logging) :
	@echo "\e[93m\e[1m-- Building $@ image --\e[0m"
	@docker build -t $(USER_NAME)/$@ logging/$@

.PHONY : push
push :
	@echo "\e[93m\e[1m-- Pushing builded images --\e[0m"
	@echo "\e[93m\e[1m> Enter docker password:\e[0m"
	@docker login --username $(USER_NAME)
	@for img in $(objects) ; do \
		echo "\e[93m\e[1m>>> Pushing $${img}\e[0m" ; docker push $(USER_NAME)/$${img} ; \
	done

.PHONY : bugged
bugged : build_bugged push_bugged

.PHONY : build_bugged
build_bugged : $(objects_bugged)

$(objects_bugged) :
	@echo "\e[93m\e[1m-- Building $@:bugged image --\e[0m"
	@cd src_bugged/$@* && sh docker_build.sh

.PHONY : push_bugged
push_bugged:
	@echo "\e[93m\e[1m-- Pushing builded images --\e[0m"
	@echo "\e[93m\e[1m> Enter docker password:\e[0m"
	@docker login --username $(USER_NAME)
	@for img in $(objects_bugged) ; do \
		echo "\e[93m\e[1m>>> Pushing $${img}\e[0m" ; docker push $(USER_NAME)/$${img}:bugged ; \
	done
