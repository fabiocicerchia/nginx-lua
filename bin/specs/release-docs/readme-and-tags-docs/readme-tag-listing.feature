@domain:release-docs @area:readme-and-tags-docs @from:bin/common
Feature: README tag listing
  Gives readers a ready-made README line linking each tag set to its Dockerfile.

  @id:bin.release-docs.readme-and-tags-docs.001 @rule:release-docs.readme.tag-line-links-dockerfile @inferred @source:bin/common.py#print_tags
  Scenario: The README line lists the tags without the repository name and links the Dockerfile
    Given nginx 1.30.1 is the stable version on debian 13
    When the maintainer prints the tags for that image
    Then one markdown bullet is printed
    And tags appear without the "fabiocicerchia/nginx-lua:" prefix, each in backticks
    And the link points to https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.30.1/debian/13/Dockerfile
