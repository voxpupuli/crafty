# Default OpenVox Example

## Start basic OpenVox setup

```shell
docker compose --profile openvox up -d
```

## Test an agent

when the openvox-profile is up and healthy, start the test-profile

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
docker compose --profile openvox down
docker compose --profile hdm down
docker compose --profile test down

docker volume rm oss_openvoxserver
docker volume rm oss_openvoxserver-ssl
docker volume rm oss_openvoxserver-ca
docker volume rm oss_openvoxdb
docker volume rm oss_openvoxdb-postgres
docker volume rm oss_agent-ssl
```

## Generate additional certificates

After the OPenVox stack is running, execute the following commant to generate an additional certificate.
It will be put in the openvoxserver-ssl volume, or any other volume you may have mounted for `/etc/puppetlabs/puppet/ssl`.

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

One can then mount the openvoxserver-ssl or whatever mount one have to the additional container, which shall use the certs.
But in general this is a bad idea, but for testing this might work.

For the puppetboard, one also can specify the certs as base64 strings. To get the strings do:

```bash
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/ca.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem | base64
```
