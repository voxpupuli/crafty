# Default OSS Puppet Example

## Start basic pupppet setup

```shell
docker compose --profile puppet up -d
```

## Test an agent

when the puppet-profile is up and healthy, start the test-profile

```shell
docker compose --profile test run testing puppet agent -t
```

## Start hdm

```shell
docker compose --profile hdm up -d
```

then open up: <http://0.0.0.0:3000/>

## cleanup

```shell
docker compose --profile puppet down
docker compose --profile hdm down
docker compose --profile test down

docker volume rm oss_puppetserver
docker volume rm oss_puppetserver-ssl
docker volume rm oss_puppetserver-ca
docker volume rm oss_puppetdb
docker volume rm oss_puppetdb-postgres
docker volume rm oss_agent-ssl
```
