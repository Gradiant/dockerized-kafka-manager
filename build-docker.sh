#!/bin/bash

VERSION=1.3.3.18
docker build --build-arg VERSION=$VERSION -t gradiant/kafka-manager:$VERSION .
