FROM golang:1.11.3 AS base

ENV APPPATH $GOPATH/src/github.com/percona
WORKDIR $APPPATH
ENV EXP_V v0.6.2

RUN mkdir -p ${APPPATH} && cd ${APPPATH}
RUN wget https://github.com/percona/mongodb_exporter/archive/${EXP_V}.tar.gz
RUN tar xzf ${EXP_V}.tar.gz && mv mongo* mongodb_exporter

ENV APPPATH $GOPATH/src/github.com/percona/mongodb_exporter
WORKDIR $APPPATH

RUN make build
RUN mv mongodb_exporter /mongodb_exporter

FROM scratch

COPY --from=base /mongodb_exporter /

EXPOSE      9216
ENTRYPOINT  ["/mongodb_exporter"]
