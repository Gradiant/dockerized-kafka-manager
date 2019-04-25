#!/bin/sh

exec /opt/kafka-manager/bin/kafka-manager \
    -Dconfig.file=/opt/kafka-manager/conf/application.conf "${KM_ARGS}" "${@}"
