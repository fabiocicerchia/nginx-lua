# Specifications of nginx-lua / src

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Automatic configuration
Self-tuning of nginx settings to the environment it runs in.

- **IPv6 listening**: [Listening on IPv6 by default](auto-configuration/ipv6-listen/ipv6-default-listen.feature) (3)
- **DNS resolver detection**: [Exposing system DNS resolvers to nginx configuration](auto-configuration/local-resolvers/local-resolvers.feature) (2)
- **Environment-based templates**: [Rendering nginx config from environment-based templates](auto-configuration/template-substitution/env-templates.feature) (5)
- **Worker process tuning**: [Tuning worker processes to available CPUs](auto-configuration/worker-tuning/worker-process-tuning.feature) (1)

## Container startup
What happens automatically when the nginx-lua container starts, before the server accepts traffic.

- **Entrypoint flow**: [Starting the container](container-startup/entrypoint-flow/container-entrypoint.feature) (5)
- **Startup logging**: [Quieting startup logs](container-startup/startup-logging/container-startup-logging.feature) (1)

## Developer tooling
Build, test and helper scripts used by people working on the project.

- **Build and make targets**: [Building a trustworthy image](developer-tooling/build-targets/build-integrity.feature) (3)
