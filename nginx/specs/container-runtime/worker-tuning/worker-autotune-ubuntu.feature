@domain:container-runtime @area:worker-tuning @from:1-30-1/ubuntu
Feature: Worker process tuning
  Lets an operator size nginx workers to the CPUs actually granted to the container.

  Background:
    Given the nginx-lua image for Ubuntu 26.04 is started with the default nginx command

  @id:nginx.container-runtime.worker-tuning.046 @rule:container-runtime.worker-tuning.limited-by-cpu-allocation @inferred @source:nginx/1.30.1/ubuntu/26.04/tpl/30-tune-worker-processes.sh
  Scenario Outline: Auto-tuned worker count is the smallest CPU limit that applies
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the host has <online> CPUs and the container is limited to <limit>
    When the operator starts the container
    Then nginx.conf has "worker_processes <workers>;"
    And the previous worker_processes line is kept as a comment

    Examples:
      | online | limit                 | workers |
      | 8      | no limit              | 8       |
      | 8      | CPU quota of 1.5 CPUs | 2       |
      | 8      | cpuset of CPUs 0-2    | 3       |
