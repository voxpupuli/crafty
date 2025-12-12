#!/bin/bash

docker compose --profile openvox down
docker compose --profile hdm down
docker compose --profile test down --remove-orphans

rm -rf openvoxserver-ca
rm -rf openvoxserver-data
rm -rf openvoxserver-ssl

docker volume rm oss_openvoxdb-postgres
docker volume rm oss_hdm-db
docker volume rm oss_agent-ssl
