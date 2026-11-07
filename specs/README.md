# Specifications of nginx-lua

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Container Runtime
How the published image behaves when a user runs it.

- **Default configuration**: [Running the nginx-lua container](container-runtime/default-config/running-the-container.feature) (4)

## Image Build
Producing nginx-lua images and packages across distributions and architectures.

- **Dockerfile generation**: [Skipping image work when nothing relevant changed](image-build/dockerfile-generation/skipping-unchanged-builds.feature) (1)

## Observability
Seeing what the server and image are doing.

- **Image metadata**: [Reading image metadata labels](observability/image-metadata/image-metadata-labels.feature) (3)

## Release & Distribution
Publishing, signing and keeping released artifacts up to date.

- **Automated dependency updates**: [Refreshing upstream entrypoints and dependencies](release-distribution/automated-updates/refreshing-upstream-entrypoints.feature) (4)
- **GitHub releases**: [Publishing GitHub releases per nginx track](release-distribution/github-releases/github-releases-per-track.feature) (2)

## Scripting & Extensibility
Running custom Lua and JavaScript logic inside the web server.

- **Lua runtime**: [Using Lua and nginx modules shipped in the image](scripting/lua-runtime/lua-tooling-in-the-image.feature) (1)
