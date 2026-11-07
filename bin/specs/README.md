# Specifications of nginx-lua / bin

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Third-Party Dependencies
Managing the nginx and Lua modules bundled into the images, their versions and the integrity of their sources.

- **Dependency manifest**: [Declaring the bundled third-party modules](dependencies/dependency-manifest/bundled-dependency-manifest.feature) (4)
- **License compliance**: [Exporting bundled dependencies for license scanning](dependencies/license-compliance/fossa-dependency-export.feature) (3)
- **Version resolution**: [Resolving pinned dependency versions](dependencies/version-resolution/resolving-pinned-dependency-versions.feature) (8)

## Documentation & Release Notes
Keeping user-facing docs in sync with what is published.

- **Changelog**: [Generating release changelogs](documentation/changelog/changelog-generation.feature) (6)
- **Image metadata docs**: [Publishing image inspection metadata](documentation/image-metadata-docs/image-metadata-docs.feature) (2), [Publishing image inspection metadata](documentation/image-metadata-docs/image-metadata-pages.feature) (3)
- **README tag listing**: [Listing the supported image tags in the README](documentation/readme-tags/readme-supported-tags.feature) (5), [Listing image tags in the README](documentation/readme-tags/readme-tag-listing.feature) (1), [Listing the available image tags](documentation/readme-tags/tags-listing.feature) (4)

## Image Build
Turning the definitions into container images for every distro and architecture.

- **Shared build tooling**: [Running image operations for mainline and stable](image-build/build-tooling/mainline-and-stable-runs.feature) (1)
- **Image building**: [Building nginx-lua images for one distribution and architecture](image-build/image-building/building-distro-images.feature) (3), [Building per-architecture images](image-build/image-building/building-images.feature) (3)
- **Multi-architecture bundles**: [Publishing multi-architecture images](image-build/multi-arch-manifests/multi-arch-bundling.feature) (3), [Publishing multi-architecture tags](image-build/multi-arch-manifests/multi-arch-manifests.feature) (2)

## Image Catalog & Versioning
Which nginx-lua images exist: supported nginx versions, operating systems, and the tag names users pull.

- **Image definitions**: [Generating per-distro image definitions](image-catalog/image-definitions/generating-image-definitions.feature) (5), [Generating per-distro Dockerfiles](image-catalog/image-definitions/image-definitions.feature) (2)
- **Image tags**: [Assigning image tags](image-catalog/image-tags/image-tags.feature) (4)
- **Supported versions**: [Refreshing the supported nginx and distribution versions](image-catalog/supported-versions/refresh-supported-versions.feature) (3)

## Operations & Maintenance
Housekeeping and performance tooling that supports the build pipeline.

- **Registry cleanup**: [Removing temporary per-architecture tags from Docker Hub](operations/registry-cleanup/docker-hub-per-arch-tag-cleanup.feature) (5)
- **Retry handling**: [Retrying registry-rate-limited signing steps](operations/retry-handling/rate-limit-retry-signing.feature) (4)

## Publishing & Distribution
Getting built images and packages into registries and release assets.

- **OS packages**: [Building native nginx packages](publishing/os-packages/building-os-packages.feature) (7)
- **Package install testing**: [Testing native nginx packages on a clean base system](publishing/package-testing/package-install-testing.feature) (5)
- **Registry mirroring**: [Mirroring published images to GitHub Container Registry](publishing/registry-mirroring/mirror-to-ghcr.feature) (4)
- **Registry push**: [Pushing images to Docker Hub](publishing/registry-push/pushing-images.feature) (2), [Pushing per-architecture images to Docker Hub](publishing/registry-push/registry-push.feature) (5)

## Supply-Chain Security
Proving images are authentic and free of known vulnerabilities.

- **Image signing**: [Signing multi-arch image indexes](supply-chain-security/image-signing/multi-arch-index-signing.feature) (6), [Signing per-architecture images](supply-chain-security/image-signing/per-arch-image-signing.feature) (6)
