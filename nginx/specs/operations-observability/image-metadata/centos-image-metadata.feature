@domain:operations-observability @area:image-metadata @from:1-18-0/centos
Feature: Identifying a CentOS image build
  Lets operators and registries see which build, base OS and run command an image corresponds to without starting it.

  @id:nginx.operations-observability.image-metadata.003 @rule:ops.metadata.label-schema-labels @inferred @source:nginx/1.18.0/centos/8.2.2004/Dockerfile#LABEL
  Scenario Outline: Image labels name the nginx version, base OS and how to run it
    Given the image tagged fabiocicerchia/nginx-lua:<tag> was built with a build date, version and VCS ref
    When the operator inspects the image labels
    Then org.label-schema.description is "Nginx 1.18.0 with LUA support based on centos <base>."
    And org.label-schema.docker.cmd is "docker run -p 80:80 -d fabiocicerchia/nginx-lua:<tag>"
    And org.label-schema.build-date, org.label-schema.version and org.label-schema.vcs-ref carry the values given at build time
    And the environment lists VER_NGINX=1.18.0 and VER_LUA_NGINX_MODULE=0.10.15

    Examples:
      | tag                   | base     |
      | 1.18.0-centos7.8.2003 | 7.8.2003 |
      | 1.18.0-centos8.1.1911 | 8.1.1911 |
      | 1.18.0-centos8.2.2004 | 8.2.2004 |
