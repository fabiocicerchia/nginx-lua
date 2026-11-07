@domain:documentation @area:readme-tags @from:bin/common
Feature: Listing image tags in the README
  Shows users which tags exist for each distro and links each one to the Dockerfile it was built from.

  @id:bin.documentation.readme-tags.001 @rule:docs.readme-tags.line-per-build @inferred @source:bin/common.py#print_tags @questionable
  Scenario: Each listed build shows its tags shortest first and links to its Dockerfile
    Given nginx 1.31.8 on alpine 3.24.3 is the mainline build
    When the maintainer generates the README tag list
    Then the line reads - [`1`, `1.31`, `1.31.8`, `alpine`, `latest`, `1-alpine`, `1.31-alpine`, `1.31.8-alpine`, `1-alpine3.24.3`, `1.31-alpine3.24.3`, `1.31.8-alpine3.24.3`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.31.8/alpine/3.24.3/Dockerfile)
