## 카프카 커넥트

### 분산 모드 커넥트

- 파일 소스 커넥트 생성

```shell
# data from file local-file-source-connector.json
$ curl -X POST \
  -H "Content-Type: application/json" \
  --data @local-file-source-connector.json \
  http://localhost:8083/connectors
```

- 삭제

```shell
$ curl -X DELETE \
  http://localhost:8083/connectors/local-file-source

# 삭제 확인
$ curl -X GET \
  http://localhost:8083/connectors
```