@domain:build-quality @area:hardening @from:1-19-3/ubuntu
Feature: Hardened nginx binary
  Assures security-minded users that the shipped nginx binary is built with stack protection, fortify and full RELRO/PIE.

  @id:nginx.build-quality.hardening.001 @rule:build.hardening.hardened-compiler-flags @inferred @source:nginx/1.19.3/ubuntu/20.10/tpl/Makefile#core @questionable
  Scenario Outline: The shipped nginx binary carries hardening flags
    Given the nginx 1.19.3 image for Ubuntu <release>
    When a security reviewer runs "nginx -V" in the container
    Then the configure arguments <flags>

    Examples:
      | release | flags                                                                                       |
      | 20.04   | include "-fstack-protector-strong", "-D_FORTIFY_SOURCE=2", "-z,relro -Wl,-z,now" and "-pie" |
      | 20.10   | show an empty --with-cc-opt and --with-ld-opt                                               |
