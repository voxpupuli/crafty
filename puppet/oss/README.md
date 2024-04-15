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

## Generate additional certificates

After the puppet stack is running, execute the following commant to generate an additional certificate.
It will be put in the puppetserver-ssl volume, or any other volume you may have mounted for `/etc/puppetlabs/puppet/ssl`.

```bash
docker exec oss-puppet-1 puppetserver ca generate --certname puppetboard
```

Output:

```text
Successfully saved private key for puppetboard to /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem
Successfully saved public key for puppetboard to /etc/puppetlabs/puppet/ssl/public_keys/puppetboard.pem
Successfully submitted certificate request for puppetboard
Successfully saved certificate for puppetboard to /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem
Certificate for puppetboard was autosigned.
```

One can then mount the puppetserver-ssl or whatever mount one have to the additional container, which shall use the certs.
But in general this is a bad idea, but for testing this might work.

For the puppetboard, one also can specify the certs as base64 strings. To get the strings do:

```bash
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/ca.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem | base64
```
