# OpenVox r10k Example

## Start the OpenVox compose

```shell
docker compose --profile openvox up -d

# check if compose is ready
docker compose ps
```

## Check code dir v1

```shell
docker exec -it r10k-compiler-003-1 ls -la /etc/puppetlabs/code
```

This should look like this:

```terminal
total 24
drwxr-xr-x  6 puppet puppet 4096 Mar  7 15:24 .
drwxr-xr-x  4 puppet puppet 4096 Mar  7 15:23 ..
drwxr-xr-x 10 puppet puppet 4096 Mar  7 15:24 production
```

## Run r10k

```shell
docker compose --profile r10k run --rm r10k
docker exec -it r10k-compiler-003-1 ls -la /etc/puppetlabs/code/environments
```

This should now look somewhat like this:

```terminal
total 24
drwxr-xr-x  6 puppet puppet 4096 Mar  7 15:28 .
drwxr-xr-x  4 puppet puppet 4096 Mar  7 15:23 ..
drwxr-xr-x 10 puppet puppet 4096 Mar  7 15:28 fix_static_validation
drwxr-xr-x 10 puppet puppet 4096 Mar  7 15:28 module2
drwxr-xr-x 10 puppet puppet 4096 Mar  7 15:28 production
drwxr-xr-x 10 puppet puppet 4096 Mar  7 15:28 server
```

## Clean up

```shell
./clean.sh
```
