# Release Process

## Overview

`Tint` uses [release-please](https://github.com/googleapis/release-please) for automated versioning and releases. When commits following [Conventional Commits](https://www.conventionalcommits.org/) are pushed to `main`, release-please creates a pull request that updates `CHANGELOG.md`. Merging that PR triggers a GitHub Release with a git tag that consumers can reference in their `Package.swift`.

## Repository Setup

In your GitHub repository settings:

1. Go to **Settings → Actions → General**
2. Under "Workflow permissions", enable **"Allow GitHub Actions to create and approve pull requests"**

## How the Pipeline Works

```
Push to main (conventional commits)
        │
        ▼
   CI workflow runs
   (build + test)
        │
        ▼ (on success)
   Release workflow triggers
        │
        ▼
   release-please creates/updates PR
   (updates CHANGELOG.md)
        │
        ▼ (PR merged)
   release-please creates GitHub Release
```

## Configuration Files

| File | Purpose |
|------|---------|
| `release-please-config.json` | Release-please behavior: release type, version bump rules |
| `.release-please-manifest.json` | Current version tracker |
| `.github/workflows/ci.yml` | CI pipeline: build + test |
| `.github/workflows/release.yml` | Release automation |

## Consuming Releases

Reference releases in your `Package.swift`:

```swift
.package(url: "https://github.com/alleato-llc/tint.git", from: "0.1.0")
```

Swift Package Manager resolves tags automatically, so each release-please tag makes a new version available to consumers.

## Conventional Commits

Release-please determines version bumps from commit messages:

| Commit Type | Version Bump | Example |
|-------------|-------------|---------|
| `feat:` | Minor (0.x.0) | `feat: add color space conversion` |
| `fix:` | Patch (0.0.x) | `fix: handle invalid hex string` |
| `feat!:` or `BREAKING CHANGE:` | Major (x.0.0) | `feat!: change Color initializer` |
| `docs:`, `chore:`, `ci:`, `test:`, `refactor:` | No bump | `docs: update README` |

## Local Hook Setup

A `commit-msg` git hook validates that commit messages follow Conventional Commits format before they reach the remote. Run the setup script once after cloning:

```bash
./scripts/setup-hooks.sh
```

This sets `core.hooksPath` to the `hooks/` directory in the repository. The hook rejects messages that don't match `<type>[scope][!]: <description>` and allows merge/revert commits through unchanged.

## Troubleshooting

### release-please PR not created

- Verify conventional commit messages on `main`
- Check that the CI workflow completed successfully (release workflow triggers on CI success)
- Ensure workflow permissions are configured (see Repository Setup)
