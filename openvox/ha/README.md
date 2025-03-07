# OpenVox HA Example

## Start the OpenVox compose

```shell
docker compose --profile openvox up -d

# check if compose is ready
docker compose ps
```

### Generate the certificate for the LB

Once this compose file is up and running execute:

```shell
docker exec -ti ha-ca-1 puppetserver ca generate --certname openvox-lb --subject-alt-names openvox,localhost

cp server-data/openvox-ca-ssl/certs/ca.pem                nginx-ssl/ca.pem
cp server-data/openvox-ca-ssl/certs/openvox-lb.pem        nginx-ssl/cert_puppet.pem
cp server-data/openvox-ca-ssl/private_keys/openvox-lb.pem nginx-ssl/priv_puppet.pem
```

## Start the LB compose

```shell
docker compose --profile lb up -d
```

## Test an agent

```shell
docker compose --profile test run testing agent -t
```

## Clean up

```shell
./clean.sh
```
