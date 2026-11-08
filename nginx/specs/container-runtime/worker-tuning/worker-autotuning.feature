@domain:container-runtime @area:worker-tuning @from:1-29-6/amazonlinux
Feature: Tuning nginx workers to available CPUs
  Lets an operator size nginx worker processes to the CPUs the container may use.

  Background:
    Given the amazonlinux nginx-lua image for nginx 1.29.6

  @id:nginx.container-runtime.worker-tuning.043 @rule:container-runtime.workers.autotune-uses-smallest-limit @inferred @source:nginx/1.29.6/amazonlinux/2023.10.20260216.1/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario Outline: Autotune uses the smallest of the host, cpuset and quota CPU limits
    Given autotune is requested
    And the host has <host> CPUs
    And the container is limited to <limit>
    When the operator starts the container with the default nginx command
    Then nginx.conf contains "worker_processes <workers>;"

    Examples:
      | host | limit                   | workers |
      | 8    | a CPU quota of 2.5 CPUs | 3       |
      | 8    | a cpuset of CPUs 0-1    | 2       |
      | 8    | no limit                | 8       |
