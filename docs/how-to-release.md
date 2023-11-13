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
Then open a PR, discuss and merge.

After the merge, as a maintainer on upstream do:

```
git switch main
git pull -r
git tag v1.0.0
git push --tags
```

# Tags

Each puppetserver and puppetdb is accompanied by a build_versions.json file containing information about puppet releases and versions built when a tag is pushed or a change is made to the main branch.

To enhance clarity and organization, we are transitioning from our previous tagging approach and will now distinguish the container tag from the puppet version. The new tags will follow the format v1.0.0. The CI build process operates within a matrix, leveraging the data from the JSON file to construct the specified versions. As a result, two Docker tags are currently generated: 1.0.0-7 corresponds to the Puppet Release 7 build, while 1.0.0-8 aligns with Release 8. These tags offer a more streamlined and informative representation of our build versions.
