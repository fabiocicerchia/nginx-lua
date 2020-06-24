## Update Dockerfiles

```bash
./bin/dockerfile-generate.sh
```

## Update Supported Versions

```bash
./bin/generate_supported_versions.sh | tee supported_versions
```

## Run Linter

```bash
./bin/test-lint.sh
```

## Run Security Audits

```bash
./bin/test-security.sh
```
