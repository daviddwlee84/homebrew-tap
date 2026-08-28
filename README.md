# homebrew-tap

Homebrew tap for daviddwlee84's CLI tools.

## Install

```bash
brew install daviddwlee84/tap/translate
brew install daviddwlee84/tap/dev-cli
```

`dev-cli` installs the `dev` executable and generated bash, zsh, and fish
completions. Agent skills remain an explicit user action (`dev skill install`)
and are never written during `brew install`.

## Updating a source formula

1. Publish an immutable SemVer tag in the source repository.
2. Download GitHub's public tag archive and calculate its SHA-256.
3. Update the formula URL and checksum.
4. Run `brew style`, `brew audit --strict --online`, install from source, and
   `brew test` before publishing the tap change.

Do not move a published tag; release a new version and update the formula.
