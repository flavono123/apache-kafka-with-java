# Consumers

## consumer - multi worker (ConsumerWithMultiWorkerThread)
- ExecutorService 사용하여 구현
- records를 poll하고 각 record를 worker thread에서 처리

## multi thread consumer (MultiConsumerThread)
- consumer run()에 레코드 poll과 처리를 구현하고
- consumer를 여러 스레드 생성하여 실행