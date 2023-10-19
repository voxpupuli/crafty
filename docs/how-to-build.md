# How to build a container

If you wanna build for example puppetserver or puppetdb for puppet7, you can do it like this:
Check the latest deb package version [here](https://apt.puppet.com/pool/jammy/puppet7/p/index.html). The containers are based on Ubuntu 22.04 at the moment.

If you checked the version and it is available as Ubuntu package, just create a tag and push it.

```bash
git tag 7.13.0
git push --tags
```

The build will be triggerd on any new tag. The tag has to match the version, because it is used internally as version referrence.

The build system watches for tags which begin with a 7 for puppet7-release and 8 for puppet8-release.
