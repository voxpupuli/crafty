#!/bin/bash

docker compose --profile openvox down

docker volume rm r10k_code_dir
docker volume rm r10k_ssl_dir
docker volume rm r10k_ca_dir
