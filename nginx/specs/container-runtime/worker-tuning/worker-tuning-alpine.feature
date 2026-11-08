@domain:container-runtime @area:worker-tuning @from:1-31-7/alpine
Feature: Sizing nginx workers to the container's CPU allowance
  Lets an operator opt in to a worker count that respects CPU limits instead of the host's core count.

  Background:
    Given the container image nginx-lua on Alpine 3.24.2

  @id:nginx.container-runtime.worker-tuning.061 @rule:container.workers.limited-by-smallest-cpu-allowance @inferred @source:nginx/1.31.7/alpine/3.24.2/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario Outline: Worker count follows the smallest CPU allowance the container has
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the host has <online> CPUs
    And the container is limited to <limit>
    When the operator starts the container
    Then nginx.conf sets worker_processes to <workers>
    And the original worker_processes line is kept as a comment

    Examples:
      | online | limit                   | workers |
      | 8      | no limit                | 8       |
      | 8      | a CPU quota of 2.5 CPUs | 3       |
      | 8      | a cpuset of CPUs 0-1    | 2       |
      | 2      | a CPU quota of 4 CPUs   | 2       |
