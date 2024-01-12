# Puppet HA Example

## Start the Puppet compose

```shell
cd puppet
docker compose up -d

# check if compose is ready
docker compose ps
```

### Generate the certificate for the LB

Once this compose file is up and running execute:

```shell
# if still in ./puppet

docker exec -ti puppet-ca-1 puppetserver ca generate --certname puppet-lb --subject-alt-names puppet,localhost

cp data/puppet-ca-ssl/certs/ca.pem               ../lb/ssl/ca.pem
cp data/puppet-ca-ssl/certs/puppet-lb.pem        ../lb/ssl/cert_puppet.pem
cp data/puppet-ca-ssl/private_keys/puppet-lb.pem ../lb/ssl/priv_puppet.pem
```

## Start the LB compose

```shell
cd ../lb
docker compose up -d
```

## Test an agent

```shell
cd ../test
docker compose run testing puppet agent -t
```

## Clean up

```shell
# if still in ./test

cd ..

./clean.sh
```
