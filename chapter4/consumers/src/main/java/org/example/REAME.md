# Consumers

## consumer - multi worker (ConsumerWithMultiWorkerThread)
- ExecutorService 사용하여 구현
- records를 poll하고 각 record를 worker thread에서 처리

## multi thread consumer (MultiConsumerThread)
- consumer run()에 레코드 poll과 처리를 구현하고
- consumer를 여러 스레드 생성하여 실행

## metrics()
- consumer의 metrics를 확인하는 예제
- poll() 이전에 metrics를 수집하고, 랙을 만들고 컨슈머 시작했는데 처음엔 NaN으로 나오고 다 소비 후 0만 찍힘
```shell
...
[pool-1-thread-1] INFO org.example.ConsumerWorker - consumer-thread-0: NaN
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: NaN
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: NaN
[pool-1-thread-3] INFO org.apache.kafka.clients.Metadata - [Consumer clientId=consumer-test-group-1, groupId=test-group] Cluster ID: 5lEd0iSVRTOj7nMe4n4cdw
[pool-1-thread-1] INFO org.apache.kafka.clients.Metadata - [Consumer clientId=consumer-test-group-3, groupId=test-group] Cluster ID: 5lEd0iSVRTOj7nMe4n4cdw
[pool-1-thread-2] INFO org.apache.kafka.clients.Metadata - [Consumer clientId=consumer-test-group-2, groupId=test-group] Cluster ID: 5lEd0iSVRTOj7nMe4n4cdw
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] Discovered group coordinator 3.37.55.69:9092 (id: 2147483647 rack: null)
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] Discovered group coordinator 3.37.55.69:9092 (id: 2147483647 rack: null)
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Discovered group coordinator 3.37.55.69:9092 (id: 2147483647 rack: null)
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] (Re-)joining group
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] (Re-)joining group
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] (Re-)joining group
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] Join group failed with org.apache.kafka.common.errors.MemberIdRequiredException: The group member needs to have a valid member id before actually entering a consumer group
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] (Re-)joining group
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] Join group failed with org.apache.kafka.common.errors.MemberIdRequiredException: The group member needs to have a valid member id before actually entering a consumer group
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] (Re-)joining group
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Join group failed with org.apache.kafka.common.errors.MemberIdRequiredException: The group member needs to have a valid member id before actually entering a consumer group
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] (Re-)joining group
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Finished assignment for group at generation 11: {consumer-test-group-1-6a8886f0-6fe2-4a11-a6f2-f179d6498880=Assignment(partitions=[test-0, test-1, test-2])}
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Join group failed with org.apache.kafka.common.errors.RebalanceInProgressException: The group is rebalancing, so a rejoin is needed.
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] (Re-)joining group
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Finished assignment for group at generation 12: {consumer-test-group-1-6a8886f0-6fe2-4a11-a6f2-f179d6498880=Assignment(partitions=[test-0]), consumer-test-group-3-5e185bd6-67d9-4ae8-b97d-0d8f152a4b6d=Assignment(partitions=[test-2]), consumer-test-group-2-1efb767b-27f8-46ef-bae5-cdabf8a6e669=Assignment(partitions=[test-1])}
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] Successfully joined group with generation 12
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Successfully joined group with generation 12
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.AbstractCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] Successfully joined group with generation 12
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] Adding newly assigned partitions: test-1
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Adding newly assigned partitions: test-0
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] Adding newly assigned partitions: test-2
[pool-1-thread-2] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-2, groupId=test-group] Setting offset for partition test-1 to the committed offset FetchPosition{offset=6, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[3.37.55.69:9092 (id: 0 rack: null)], epoch=0}}
[pool-1-thread-3] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-1, groupId=test-group] Setting offset for partition test-0 to the committed offset FetchPosition{offset=3, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[3.37.55.69:9092 (id: 0 rack: null)], epoch=0}}
[pool-1-thread-1] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-test-group-3, groupId=test-group] Setting offset for partition test-2 to the committed offset FetchPosition{offset=6, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[3.37.55.69:9092 (id: 0 rack: null)], epoch=0}}
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: ConsumerRecord(topic = test, partition = 1, leaderEpoch = 0, offset = 6, CreateTime = 1704788758125, serialized key size = -1, serialized value size = 4, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = lag2)
[pool-1-thread-1] INFO org.example.ConsumerWorker - consumer-thread-0: ConsumerRecord(topic = test, partition = 2, leaderEpoch = 0, offset = 6, CreateTime = 1704788759226, serialized key size = -1, serialized value size = 4, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = lag3)
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: ConsumerRecord(topic = test, partition = 0, leaderEpoch = 0, offset = 3, CreateTime = 1704788756905, serialized key size = -1, serialized value size = 4, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = lag1)
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: ConsumerRecord(topic = test, partition = 0, leaderEpoch = 0, offset = 4, CreateTime = 1704788763131, serialized key size = -1, serialized value size = 2, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = ya)
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: ConsumerRecord(topic = test, partition = 1, leaderEpoch = 0, offset = 7, CreateTime = 1704788760387, serialized key size = -1, serialized value size = 1, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = 4)
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: ConsumerRecord(topic = test, partition = 1, leaderEpoch = 0, offset = 8, CreateTime = 1704788760667, serialized key size = -1, serialized value size = 1, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = 5)
[pool-1-thread-1] INFO org.example.ConsumerWorker - consumer-thread-0: 0.0
[pool-1-thread-1] INFO org.example.ConsumerWorker - consumer-thread-0: 0.0
[pool-1-thread-1] INFO org.example.ConsumerWorker - consumer-thread-0: 0.0
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: 0.0
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: 0.0
[pool-1-thread-3] INFO org.example.ConsumerWorker - consumer-thread-2: 0.0
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: ConsumerRecord(topic = test, partition = 1, leaderEpoch = 0, offset = 9, CreateTime = 1704788761049, serialized key size = -1, serialized value size = 1, headers = RecordHeaders(headers = [], isReadOnly = false), key = null, value = 6)
[pool-1-thread-2] INFO org.example.ConsumerWorker - consumer-thread-1: 0.0
...
```