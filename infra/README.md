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