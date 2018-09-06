FROM hseeberger/scala-sbt:8u171_2.12.6_1.1.6 as builder
ARG VERSION=1.3.3.17

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

ENV KM_VERSION=$VERSION
ENV KM_CONFIGFILE="conf/application.conf"

RUN cd / && git clone https://github.com/yahoo/kafka-manager
RUN cd /kafka-manager && git checkout tags/${KM_VERSION} && sbt clean dist
#&&  echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && ./sbt clean dist 


FROM  openjdk:8u171-jre-alpine
ARG VERSION=1.3.3.17

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

ENV KM_VERSION=${VERSION}
ENV ZK_HOSTS=localhost:2181
ENV KM_CONFIGFILE="conf/application.conf"

COPY --from=builder /kafka-manager/target/universal/kafka-manager-${KM_VERSION}.zip /
RUN apk add --no-cache bash && unzip  -d / /kafka-manager-${KM_VERSION}.zip && ln -s /kafka-manager-${KM_VERSION} /kafka-manager &&\
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"\n' > /kafka-manager-${KM_VERSION}/km.sh && \
    chmod +x /kafka-manager-${KM_VERSION}/km.sh && \
    rm -fr /kafka-manager-${KM_VERSION}/share && \
    echo "akka.logger-startup-timeout = 30s" >> /kafka-manager-${KM_VERSION}/conf/application.conf

WORKDIR /kafka-manager
VOLUME /kafka-manager/conf

EXPOSE 9000
ENTRYPOINT ["./km.sh"]
