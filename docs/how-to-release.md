# Release

On a fork or as a maintainer do:

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
