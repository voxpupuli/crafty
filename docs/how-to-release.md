# Release

On a fork do:

```
git switch main
git pull -r
git switch -c release-v1.0.0
bundle config set --local path vendor/bundle
bundle install
CHANGELOG_GITHUB_TOKEN="token_MC_tokenface" bundle exec github_changelog_generator -u voxpupuli -p container-puppetserver --future-release v1.0.0
git commit -am 'Release v1.0.0'
git push origin release-v1.0.0
```
Then open a PR, discuss and mrege.

After the merge, as a maintainer on upstream do:

```
git switch main
git pull -r
git tag v1.0.0
git push --tags
```


# Tags

each puppetserver and puppetdb have a build_versions.json. There in are the puppet releases and versions which are build if a tag is pushed. Or a change to main.

We will break with the tags in the past and now devide the container tag from the puppet version. The new tags will be like `v1.0.0`.
The build ci runs in a matrix based on the json file and building the versions mentioned in there. Resulting in two docker tags 1.0.0-7 and 1.0.0-8 atm.
`-7` is the puppet release 7 build and `-8` is 8.
