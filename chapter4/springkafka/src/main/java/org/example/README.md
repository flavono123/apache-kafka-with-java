# 스프링 카프카

## 기본 카프카 템플릿

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

## 커스텀 카프카 템플릿
- send 안됨
- default 외에 2가지 템플릿이 더 있다:
  - ReplyingKafkaTemplate: 컨슈머로부터 데이터 전달 여부 확인할 수 있다.
  - RoutingKafkaTemplate: 토픽 별로 옵션을 다르게 전송할 수 있다.