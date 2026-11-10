# Specifications of nginx-lua / bin

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Dependency management

Tracking, resolving and fetching the upstream components that go into the nginx-lua images.

- **Build environment variables**: [Generating the pinned dependency environment](dependencies/build-environment/deps-env-generation.feature) (6)
- **License inventory**: [Generating the license-scan dependency declarations](dependencies/license-inventory/fossa-dependency-declarations.feature) (3)

## Image build

Producing the container images and the packages they are made from.

- **Base packages**: [Packaging nginx for each distribution](image-build/base-packages/nginx-base-packaging.feature) (4)
- **Dockerfile generation**: [Generating Dockerfiles for every supported nginx and OS combination](image-build/dockerfile-generation/dockerfile-generation-generate-dockerfiles.feature) (2), [Dockerfile generation](image-build/dockerfile-generation/dockerfile-generation.feature) (2)
- **Image building**: [Building images for an OS and architecture](image-build/image-building/building-images.feature) (3), [Building reproducible images](image-build/image-building/image-building.feature) (1)
- **Image metadata**: [Publishing image metadata documents](image-build/image-metadata/image-metadata-docs.feature) (2)

## Publishing and distribution

Getting built images to registries with the right names and tags.

- **Image cleanup**: [Cleaning up temporary per-architecture tags](publishing/image-cleanup/dockerhub-temp-tag-cleanup.feature) (4)
- **Registry mirroring**: [Mirroring published images to GitHub Container Registry](publishing/registry-mirroring/ghcr-mirroring.feature) (3)
- **Registry push**: [Publishing multi-architecture manifests](publishing/registry-push/multi-arch-manifests.feature) (2), [Pushing per-architecture images to the registry](publishing/registry-push/registry-push-docker-push.feature) (2), [Publishing per-architecture images and multi-arch manifests](publishing/registry-push/registry-push.feature) (1)
- **Tag scheme**: [Image tag scheme](publishing/tagging/image-tag-scheme-generate-tags.feature) (5), [Image tag scheme](publishing/tagging/image-tag-scheme.feature) (3)

## Performance and quality

Measuring how the images behave.

- **Test base**: [Checking that built packages install and run](quality/test-base/package-install-check.feature) (4)

## Release and documentation

Keeping release notes, docs and release readiness current.

- **Changelog**: [Generating release notes](release-docs/changelog/release-changelog.feature) (6)
- **README and tag tables**: [Listing published image tags for the README](release-docs/readme-and-tags-docs/readme-tag-listing-readme-tags.feature) (1), [README tag listing](release-docs/readme-and-tags-docs/readme-tag-listing.feature) (1), [Tags page](release-docs/readme-and-tags-docs/tags-page.feature) (1)
- **Release validation**: [Validating a GitHub release before it ships](release-docs/release-validation/release-validation.feature) (2)
- **Supported versions**: [Publishing the supported versions list](release-docs/supported-versions/supported-versions-generation.feature) (3), [Supported versions matrix](release-docs/supported-versions/supported-versions-matrix.feature) (1)

## Shared tooling

Common helpers underpinning the other scripts.

- **Retry and resilience**: [Retrying registry operations that hit rate limits](shared-tooling/retry-resilience/rate-limit-retry.feature) (3)

## Supply-chain security

Proving images are trustworthy and free of known vulnerabilities.

- **Image signing**: [Signing per-architecture images](supply-chain-security/image-signing/per-arch-image-signing.feature) (4), [Signing multi-arch manifests](supply-chain-security/image-signing/signing-multi-arch-manifests.feature) (6)
- **Image verification**: [Verifying a published image before use](supply-chain-security/image-verification/verify-published-image.feature) (5), [Verifying signed manifests](supply-chain-security/image-verification/verifying-signed-manifests.feature) (1)
- **Vulnerability scanning**: [Vulnerability gate before publishing an image](supply-chain-security/vulnerability-scanning/image-vulnerability-gate.feature) (4)
