FROM hseeberger/scala-sbt:8u171_2.12.6_1.1.6 as builder
ARG VERSION=1.3.3.23

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

ENV KM_VERSION=$VERSION
ENV KM_CONFIGFILE="conf/application.conf"

RUN cd / && \
    wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz && \
    tar -xvzf ${KM_VERSION}.tar.gz
RUN cd /kafka-manager-${KM_VERSION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist
RUN unzip -d /tmp /kafka-manager-${KM_VERSION}/target/universal/kafka-manager-${KM_VERSION}.zip
RUN mv /tmp/kafka-manager-${KM_VERSION} /builded-kafka-manager
RUN rm -fr /builded-kafka-manager/share
COPY entrypoint.sh /builded-kafka-manager/

FROM  openjdk:8u171-jre-alpine
ARG VERSION=1.3.3.18

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

ENV KM_VERSION=${VERSION}
ENV ZK_HOSTS=localhost:2181

COPY --from=builder /builded-kafka-manager /opt/kafka-manager
RUN apk add --no-cache bash
WORKDIR /opt/kafka-manager

EXPOSE 9000
ENTRYPOINT ["/opt/kafka-manager/entrypoint.sh"]
