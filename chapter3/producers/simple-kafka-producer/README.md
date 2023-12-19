# Simple Producer

```shell
# 토픽 생성
$ bin/kafka-topics.sh --create \
  --bootstrap-server my-kafka:9092 \
  --partitions 3 \
  --topic test
```

```shell
# SimpleProducer.main() 실행 후 메시지 확인
$ bin/kafka-console-consumer.sh \
  --bootstrap-server my-kafka:9092 \
  --topic test \
  --from-beginning
```