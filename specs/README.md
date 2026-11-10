# Specifications of nginx-lua

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Operations
Running and maintaining nginx-lua in deployed environments.

- **Container runtime**: [Running the nginx-lua container](operations/container-runtime/container-runtime-behaviour.feature) (2)
- **Developer workflow**: [Safe updates and releases](operations/developer-workflow/maintainer-release-and-update-safeguards.feature) (4)
