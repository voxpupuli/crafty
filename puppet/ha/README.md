# Puppet HA Example

## Start the Puppet compose

```shell
docker compose --profile puppet up -d

# check if compose is ready
docker compose ps
```

### Generate the certificate for the LB

Once this compose file is up and running execute:

```shell
docker exec -ti ha-ca-1 puppetserver ca generate --certname puppet-lb --subject-alt-names puppet,localhost

cp server-data/puppet-ca-ssl/certs/ca.pem               nginx-ssl/ca.pem
cp server-data/puppet-ca-ssl/certs/puppet-lb.pem        nginx-ssl/cert_puppet.pem
cp server-data/puppet-ca-ssl/private_keys/puppet-lb.pem nginx-ssl/priv_puppet.pem
```

## Start the LB compose

```shell
docker compose --profile lb up -d
```

## Test an agent

```shell
docker compose --profile test run testing puppet agent -t
```

## Clean up

```shell
./clean.sh
```
