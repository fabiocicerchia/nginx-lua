@domain:auto-configuration @area:local-resolvers @from:src/15-local-resolvers
Feature: Exposing system DNS resolvers to nginx configuration
  Operators who opt in get the container's DNS nameservers as a ready-to-use list for nginx resolver directives in templates.

  @id:src.auto-configuration.local-resolvers.001 @rule:auto-configuration.local-resolvers.exposed-when-enabled @inferred @source:src/15-local-resolvers.envsh#NGINX_LOCAL_RESOLVERS
  Scenario Outline: Nameservers from resolv.conf are exposed to templates when enabled, with IPv6 bracketed
    Given the operator has enabled local resolver detection
    And the system resolver configuration lists the nameservers <resolv_conf_nameservers>
    When the container starts
    Then the resolver list available to templates is "<resolver_list>"
    And the list is space-separated, in resolver order, with IPv6 addresses in brackets and no trailing space

    Examples:
      | resolv_conf_nameservers  | resolver_list             |
      | 192.0.2.53               | 192.0.2.53                |
      | 192.0.2.53, 2001:db8::53 | 192.0.2.53 [2001:db8::53] |
      | no nameserver lines      | (empty)                   |

  @id:src.auto-configuration.local-resolvers.002 @rule:auto-configuration.local-resolvers.disabled-by-default @inferred @source:src/15-local-resolvers.envsh#NGINX_ENTRYPOINT_LOCAL_RESOLVERS
  Scenario: No resolver list is produced unless detection is enabled
    Given the operator has not enabled local resolver detection
    When the container starts
    Then no resolver list is available to templates
