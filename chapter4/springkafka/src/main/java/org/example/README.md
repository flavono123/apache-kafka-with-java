# 스프링 카프카

## 스프링 카프카 프로듀서

### 기본 카프카 템플릿

```yaml
# application.yaml
spring.kafka.producer.acks
spring.kafka.producer.batch-size
spring.kafka.producer.bootstrap-servers
spring.kafka.producer.buffer-memory
spring.kafka.producer.client-id
spring.kafka.producer.compression-type
spring.kafka.producer.key-serializer
spring.kafka.producer.properties.*
spring.kafka.producer.retries
spring.kafka.producer.transaction-id-prefix
spring.kafka.producer.value-serializer
```

### 커스텀 카프카 템플릿

- send 안됨
- default 외에 2가지 템플릿이 더 있다:
  - ReplyingKafkaTemplate: 컨슈머로부터 데이터 전달 여부 확인할 수 있다.
  - RoutingKafkaTemplate: 토픽 별로 옵션을 다르게 전송할 수 있다.

## 스프링 카프카 컨슈머

### 리스너
- MessageListener: 하나의 레코드 처리
- BatchMessageListener: `poll()` 처럼 ConsumerRecords 처리
- 파생 리스너:
    - Acknowlegding(매뉴얼 커밋)
    - ConsumerAware(Consumer 인스턴스 직접 제어)
    - `AcknowledgingMessageListener`
    - `ConsumerAwareMessageListener`
    - `AcknowledgingConsumerAwareMessageListener`
    - `BatchAcknowledgingMessageListener`
    - `BatchConsumerAwareMessageListener`
    - `BatchAcknowledgingConsumerAwareMessageListener`
  
### 컨슈머 커밋 구현
  - primitive; 자동 커밋, 동기 커밋, 비동기 커밋
  - 스프링 카프카
      - RECORD: 각 레코드마다 커밋
      - BATCH: 배치마다(`poll()` 호출 이후) 커밋, AckMode의 기본 값
      - TIME: 일정 시간마다 커밋, AckTime 설정 필요
      - COUNT: 일정 개수마다 커밋, AckCount 설정 필요
      - COUNT_TIME: TIME 또는 COUNT 중 먼저 도달한 것으로 커밋
      - MANUAL: Acknowledgment.acknowledge() 호출 시 다음 poll()에서 커밋
        - 매번 호출하면 BATCH와 동일
        - Acknowledging 리스너에서 사용
      - MANUAL_IMMEDIATE: Acknowledgment.acknowledge() 호출 시 즉시 커밋
        - Acknowledging 리스너에서 사용
  
### 기본 리스너 컨테이너

```yaml
# application.yaml
spring.kafka.consumer.auto-commit-interval
spring.kafka.consumer.auto-offset-reset
spring.kafka.consumer.bootstrap-servers
spring.kafka.consumer.client-id
spring.kafka.consumer.enable-auto-commit
spring.kafka.consumer.fetch-max-wait
spring.kafka.consumer.fetch-min-size
spring.kafka.consumer.group-id
spring.kafka.consumer.heartbeat-interval
spring.kafka.consumer.key-deserializer
spring.kafka.consumer.max-poll-records
spring.kafka.consumer.properties.*
spring.kafka.consumer.value-deserializer

spring.kafka.listener.ack-count
spring.kafka.listener.ack-mode
spring.kafka.listener.ack-time
spring.kafka.listener.client-id
spring.kafka.listener.concurrency
spring.kafka.listener.idle-event-interval
spring.kafka.listener.log-container-config
spring.kafka.listener.monitor-interval
spring.kafka.listener.no-poll-threshold
spring.kafka.listener.poll-timeout
spring.kafka.listener.type
```
```