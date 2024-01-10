# (Apache Kafka w/Java) w/Terraform

2장에서 필요한 인프라 구성을 terraform 프로젝트로 생성

## 워크플로

- 기본적인 local 명령과 tfstate

```sh
# 실습 준비
tf init
tf plan -out planfile
tf apply planfile

# HACK: provisioner의 broker와 zookeeper 실행은 안되는 경우가 많다
[ec2-user@ip-xxx-yyy-zzz-aaa ~]$ cd kafka_2.12-2.5.0
[ec2-user@ip-xxx-yyy-zzz-aaa ~]$ bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
[ec2-user@ip-xxx-yyy-zzz-aaa ~]$ bin/kafka-server-start.sh -daemon config/server.properties
[ec2-user@ip-xxx-yyy-zzz-aaa ~]$ jps

# 실습 종료
tf destroy -auto-approve
```

# 4.3.2 Burrow

## install docker

```bash
# https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9

# docker ce

$ sudo amazon-linux-extras install docker 
# enter yes in prompt

$ sudo service docker start
$ sudo usermod -a -G docker ec2-user

# docker compose
$ sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose

```

## install burrow stack(burrow - telegraf - elasticsearch - grafana)

```sh
$ scp -r -i kafka.pem docker-config/* ec2-user@<ec2-ip>:~/burrow

# ssh to ec2
[ec2-user@ipp-xxx-yyy-zzz-aaa ~]$ mkdir burrow
[ec2-user@ipp-xxx-yyy-zzz-aaa ~]$ cd burrow
[ec2-user@ipp-xxx-yyy-zzz-aaa burrow]$ sed -i 's/YOUR-IP/xxx.yyy.zzz.aaa/g' docker-compose.yml
[ec2-user@ipp-xxx-yyy-zzz-aaa burrow]$ mkdir elasticsearch-data tmp grafana-storage grafana-plugins
[ec2-user@ipp-xxx-yyy-zzz-aaa burrow]$ chmod 777 grafana-storage grafana-plugins
[ec2-user@ipp-xxx-yyy-zzz-aaa burrow]$ docker-compose up -d

# test burrow
[ec2-user@ipp-xxx-yyy-zzz-aaa burrow]$ curl localhost:8000/burrow/admin
```

## 그라파나에서 대시보드로 확인

### Datasource
- elasticsearch 추가
  - Connection URL: http://elasticsearch:9200
  - Elasticsearch Details:
    - Index name: burrow-*
    - Pattern: No pattern(default)
    - Time field name: @timestamp

### Dashboard

- Lucene Query: measurement_name="burrow_partition"
- Metrics: Max burrow_partition.lag
- Group by: Terms tag.topic.keyword
- Then by: Terms tag.partition.keyword
- Then by: Terms tag.group.keyword
- Then by: Date Histogram(@timestamp) 10s