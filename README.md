# apt

Debian/Ubuntu packages built from source in GitHub Actions when upstream publishes a release.
Signed apt repository, served by GitHub Pages.

Packages: `zellij` (amd64, arm64).

## Use

```sh
sudo install -d -m 0755 /etc/apt/keyrings
sudo curl -fsSL https://yokotoka.github.io/apt/key.gpg -o /etc/apt/keyrings/yokotoka-apt.gpg
printf 'Types: deb\nURIs: https://yokotoka.github.io/apt/\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/yokotoka-apt.gpg\n' | sudo tee /etc/apt/sources.list.d/yokotoka.sources
sudo apt update && sudo apt install zellij
```

## Add a package

Create `packages/<name>/` with:

- `recipe.env`: `UPSTREAM=<owner>/<repo>` (the latest GitHub release tag, minus `v`, is the version).
- `build.sh <upstream-src-dir> <out-dir>`: builds from source, writes a `.deb` named after the package into `<out-dir>`. `VERSION` is in the environment and must be the deb version.

The daily workflow builds any package whose latest release is not yet in the repo, then publishes to `gh-pages` with `reprepro`.

Signing key is the `APT_SIGNING_KEY` repo secret (armored private key, no passphrase).
