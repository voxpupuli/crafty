pushd test
docker compose down
rm -fr ssl
popd

pushd lb
docker compose down
rm -fr ssl/*.pem
popd

pushd puppet
docker compose down
rm -fr data
popd
