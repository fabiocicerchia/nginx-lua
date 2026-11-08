@domain:container-runtime @area:worker-tuning @from:1-30-5/almalinux
Feature: Sizing nginx workers to available CPUs
  Lets operators opt in to nginx worker count matching the CPUs the container may really use.

  Background:
    Given the AlmaLinux nginx-lua image is started with the command nginx

  @id:nginx.container-runtime.worker-tuning.048 @rule:container-runtime.worker-tuning.limited-to-smallest-cpu-limit @inferred @source:nginx/1.30.5/almalinux/10.2-20260902/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario Outline: Worker count follows the smallest CPU limit that applies
    Given autotune is requested
    And the machine has <online> CPUs
    And the container is limited to <limit> CPUs
    When the operator starts the container
    Then nginx.conf has "worker_processes <workers>;"
    And the previous worker_processes line is kept as a comment

    Examples:
      | online | limit                         | workers |
      | 16     | 2                             | 2       |
      | 16     | 1.5 (quota 150000 per 100000) | 2       |
      | 4      | 8                             | 4       |
