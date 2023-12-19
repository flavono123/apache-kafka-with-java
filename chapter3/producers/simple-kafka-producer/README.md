## Simple Producer

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

## Kafka Producer Key Value

```shell
# SimpleProducer.main() 실행 후 메시지 확인
$ bin/kafka-console-consumer.sh \
  --bootstrap-server my-kafka:9092 \
  --topic test \
  --from-beginning \
  --property print.key=true \
  --property key.separator="-" 
null-testMessage
Pangyo-testMessage
null-testMessage
```

## Kafka Producer Custom Partitioner 

```shell
# 파티션 0만 컨슘
$ bin/kafka-console-consumer.sh \
  --bootstrap-server my-kafka:9092 \
  --topic test \
  --from-beginning \
  --property print.key=true \
  --property key.separator="-" \
  --partition 0
null-testMessage
Pangyo-23
Pangyo-23
Pangyo-24
gyopan-24
^CProcessed a total of 5 messages

# 파티션 1만 컨슘
$ bin/kafka-console-consumer.sh \
  --bootstrap-server my-kafka:9092 \
  --topic test \
  --from-beginning \
  --property print.key=true \
  --property key.separator="-" \
  --partition 1
null-testMessage
Pangyo-testMessage
```

## Kafka Producer Sync Callback

```shell
# 실행 로그
...
# test 토픽, 파티션 0, 오프셋 5
[main] INFO org.example.SimpleProducer - test-0@5

```

## Producer Async Callback

```shell
# 실행 로그
...
# 다른 스레드에서 실행
[kafka-producer-network-thread | producer-1] INFO org.example.ProducerCallback - test-0@6
```