# (Apache Kafka w/Java) w/Terraform

2장에서 필요한 인프라 구성을 terraform 프로젝트로 생성

## 워크플로
- 기본적인 local 명령과 tfstate
```sh
# 실습 준비
tf init
tf plan -out planfile
tf apply planfile
# 실습 종료
tf destroy -auto-approve
```