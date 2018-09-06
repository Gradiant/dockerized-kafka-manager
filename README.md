This is a docker image of (kafka-manager)[https://github.com/yahoo/kafka-manager].

# Acknowledge

This image is based in the  (sheepkiller image)[https://hub.docker.com/r/sheepkiller/kafka-manager/] but with a smaller footprint ( base docker image is openjdk:8u171-jre-alpine).

## Howto

You can provide zookeeper location through ZK_HOSTS (if not provided default value is "localhost:2181")

```
docker run -d -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" gradiant/kafka-manager
```

You can use KM_ARGS environment variables to change listening port (default is 9000):

```
docker run -d -e KM_ARGS="-Dhttp.port=9090" gradiant/kafka-manager
```

You can also override conf with local configuration files:
```
docker run -d -v /path/to/confdir:/kafka-manager/conf gradiant/kafka-manager
```



