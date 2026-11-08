@domain:container-runtime @area:worker-tuning @from:1-29-0/amazonlinux
Feature: Worker process tuning
  Lets an operator size nginx workers to the CPU actually available to the container.

  Background:
    Given Given the Amazon Linux nginx-lua image 1.29.0

  @id:nginx.container-runtime.worker-tuning.029 @rule:runtime.workers.autotune-uses-lowest-cpu-limit @inferred @source:nginx/1.29.0/amazonlinux/2023.8.20250715.0/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario Outline: Tuned worker count follows the lowest CPU limit
    Given the autotune option is enabled
    And the container has 8 online CPUs and a CPU quota of 2.5 CPUs
    When the operator starts the container with the default command
    Then nginx.conf has "worker_processes 3;"
    And the previous worker_processes line is kept commented out

    Examples:
      | online CPUs | quota            | worker_processes |
      | 8           | 2.5 CPUs         | 3                |
      | 8           | none             | 8                |
      | 4           | cpuset of 2 CPUs | 2                |
