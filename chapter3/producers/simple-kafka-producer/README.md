# Producer

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

# Consumer

## Simple Consumer

```shell
# 실행 시 오류 발생
[main] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] (Re-)joining group
[main] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Join group failed with org.apache.kafka.common.errors.MemberIdRequiredException: The group member needs to have a valid member id before actually entering a consumer group
[main] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] (Re-)joining group
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Finished assignment for group at generation 1: {consumer-test-new-group-1-c0affef4-65b0-4558-9004-855af760f35a=Assignment(partitions=[test-0, test-1, test-2])}
[main] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Successfully joined group with generation 1
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Adding newly assigned partitions: test-1, test-0, test-2
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Found no committed offset for partition test-1
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Found no committed offset for partition test-0
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Found no committed offset for partition test-2
[main] INFO org.apache.kafka.clients.consumer.internals.SubscriptionState - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Resetting offset for partition test-1 to offset 2.
[main] INFO org.apache.kafka.clients.consumer.internals.SubscriptionState - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Resetting offset for partition test-0 to offset 7.
[main] INFO org.apache.kafka.clients.consumer.internals.SubscriptionState - [Consumer clientId=consumer-test-new-group-1, groupId=test-new-group] Resetting offset for partition test-2 to offset 0.
```

## Kafka Consumer Sync Commit

- `poll()` 로 받은 모든 메시지 처리 후 `commitSync()` 호출한다.
 - 마지막 레코드 오프셋을 커밋한다.
- 자동 커밋, 비동기 오프셋 커밋과 달리 동기 시간만큼 대기하여 처리량이 낮아진다.

### Sync Commit for each record

- 레코드마다 commitSync() 호출한다.
- 토픽, 파티션과 오프셋, 메타데이터의 해시맵 ` Map<TopicPartition, OffsetAndMetadata>`
- 처리한 오프셋에 1을 더해 커밋한다.

## Kafka Consumer Async Commit
- `commitAsync()` 로 비동기 처리
- 콜백 함수로 결과(오프셋 또는 에러)를 받을 수 있다.
  - 주기적으로 호출됨
```shell
[main] INFO org.example.SimpleConsumer - Commit succeeded for offsets {test-1=OffsetAndMetadata{offset=2, leaderEpoch=null, metadata=''}, test-0=OffsetAndMetadata{offset=12, leaderEpoch=0, metadata=''}, test-2=OffsetAndMetadata{offset=0, leaderEpoch=null, metadata=''}}
[main] INFO org.example.SimpleConsumer - Commit succeeded for offsets {test-1=OffsetAndMetadata{offset=2, leaderEpoch=null, metadata=''}, test-0=OffsetAndMetadata{offset=12, leaderEpoch=0, metadata=''}, test-2=OffsetAndMetadata{offset=0, leaderEpoch=null, metadata=''}}
[main] INFO org.example.SimpleConsumer - ConsumerRecord(topic = test, partition = 1, leaderEpoch = 0, offset = 2, CreateTime = 1702966257036, serialized key size = 6, serialized value size = 2, headers = RecordHeaders(headers = [], isReadOnly = false), key = Pangyo, value = 29)
[main] INFO org.example.SimpleConsumer - Commit succeeded for offsets {test-1=OffsetAndMetadata{offset=3, leaderEpoch=0, metadata=''}, test-0=OffsetAndMetadata{offset=12, leaderEpoch=0, metadata=''}, test-2=OffsetAndMetadata{offset=0, leaderEpoch=null, metadata=''}}
[main] INFO org.example.SimpleConsumer - Commit succeeded for offsets {test-1=OffsetAndMetadata{offset=3, leaderEpoch=0, metadata=''}, test-0=OffsetAndMetadata{offset=12, leaderEpoch=0, metadata=''}, test-2=OffsetAndMetadata{offset=0, leaderEpoch=null, metadata=''}}
```

## Kafka Consumer Exact Partition

- `assign()` 사용한다.
- 컨슈머에 파티션을 직접 할당할 경우 리밸런싱이 일어나지 않는다.
- 컨슈머에 할당된 파티션을 확인할 땐 `assignment()` 사용한다.

## Kafka Consumer Offset Commit Shutdown Hook
- `wakeup()` 로 `WakeupException` 발생시킨다.
- 자바 앱 셧다운 훅에서 `wakeup()` 호출한다.
- `WakeupException` 예외처리 후 리소스(consumer)를 정리한다.
```shell
# SIGTERM 받을 시에 훅 실행됨
[Thread-0] INFO org.example.SimpleConsumer - Shutdown hook
[main] WARN org.example.SimpleConsumer - Wakeup consumer
```

## Kafka Admin Clinet

### describeConfigs()

- 브로커(노드)의 구성 키-값을 가져옴