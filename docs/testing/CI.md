# Continuous Integration

How to run Tint's test suite in CI environments.

## Pipeline

```
swift build ──> swift test
```

Both unit tests and BDD tests run via Swift Testing in a single `swift test` invocation. No GUI session or special permissions are required — Tint is a library with no UI test dependencies.

## GitHub Actions

Example workflow for GitHub Actions:

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: swift build

      - name: Test
        run: swift test
```

### Selective Test Runs

```yaml
      # Unit tests only
      - run: swift test --filter TintTests

      # BDD tests only
      - run: swift test --filter TintBDDTests

      # Release build validation
      - run: swift build -c release
```

## Requirements

- **macOS 14+** (required by Tint's platform target)
- **Swift 6.2+** (required by Package.swift tools version)
- No additional dependencies to install — PickleKit is fetched automatically by SPM

## Running Locally

```bash
# Full suite
swift test

# With verbose output
swift test --verbose

# Single scenario
CUCUMBER_SCENARIOS="Write text to buffer" swift test --filter TintBDDTests
```
