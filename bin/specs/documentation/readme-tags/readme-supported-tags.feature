@domain:documentation @area:readme-tags @from:bin/readme-tags
Feature: Listing the supported image tags in the README
  Gives image users a list, one line per supported distribution, of every tag they can pull and the Dockerfile behind it, so they can pick a tag without asking the registry.

  Background:
    Given the supported versions are nginx mainline 1.31.8 and nginx stable 1.30.6
    And the supported distributions are almalinux, alpine, amazonlinux, debian, fedora and ubuntu, each pinned to one release (alpine 3.24.3, debian 13.7)

  @id:bin.documentation.readme-tags.006 @rule:docs.readme-tags.one-entry-per-distro @inferred @source:bin/readme-tags.py#main
  Scenario: The tag listing has one entry for each supported distribution, in a fixed order
    When the maintainer generates the README tag listing
    Then the output has exactly 6 markdown list entries
    And the entries appear in the order almalinux, alpine, amazonlinux, debian, fedora, ubuntu
    And each entry starts with "- [" and puts every tag in backticks, separated by ", "

  @id:bin.documentation.readme-tags.007 @rule:docs.readme-tags.mainline-only @inferred @source:bin/readme-tags.py#main @questionable
  Scenario: Only nginx mainline images are listed; stable tags do not appear
    When the maintainer generates the README tag listing
    Then every entry lists tags for nginx 1.31.8
    And no entry lists a tag that contains 1.30 or 1.30.6

  @id:bin.documentation.readme-tags.008 @rule:docs.readme-tags.entry-links-dockerfile @inferred @source:bin/common.py#print_tags
  Scenario Outline: Each entry links to the Dockerfile that builds those tags
    When the maintainer generates the README tag listing
    Then the <distro> entry links to https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.31.8/<distro>/<release>/Dockerfile

    Examples:
      | distro | release |
      | alpine | 3.24.3  |
      | debian | 13.7    |
      | fedora | 45      |

  @id:bin.documentation.readme-tags.009 @rule:docs.readme-tags.alpine-carries-default-aliases @inferred @source:bin/common.py#generate_tags
  Scenario: Only the alpine entry lists the latest and bare version tags
    When the maintainer generates the README tag listing
    Then the alpine entry lists `latest`, `1`, `1.31` and `1.31.8`
    And no other entry lists `latest` or a tag without a distribution name
    And every entry lists `<distro>`, `1-<distro>`, `1.31-<distro>`, `1.31.8-<distro>` and the same three version levels followed by the distribution release

  @id:bin.documentation.readme-tags.010 @rule:docs.readme-tags.tags-shortest-first @inferred @source:bin/common.py#print_tags
  Scenario: Within an entry, tags are listed shortest first, then alphabetically, without the repository name
    When the maintainer generates the README tag listing
    Then the alpine entry starts with `1`, `1.31`, `1.31.8`, `alpine`, `latest`
    And no tag in the listing starts with "fabiocicerchia/nginx-lua:"
    And no tag appears twice in the same entry
