@domain:auto-configuration @area:worker-tuning @from:src/30-tune-worker-processes
Feature: Tuning worker processes to available CPUs
  Lets an operator have nginx size its worker processes to the CPUs actually available to the container, instead of the host's total.

  Background:
    Given Given the nginx configuration at /etc/nginx/nginx.conf contains a worker_processes directive

  @id:src.auto-configuration.worker-tuning.001 @rule:worker-tuning.autotune.limited-by-available-cpus @inferred @source:src/30-tune-worker-processes.sh#get_quota_v2
  Scenario Outline: Worker processes match the smallest CPU limit the container has
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set
    And the host reports <online> online CPUs
    And the container is limited to <limit> CPUs by a CPU quota or CPU set
    When the operator starts the container
    Then nginx.conf contains the line "worker_processes <workers>;"
    And the previous worker_processes line is kept as a comment
    And the original file is saved as nginx.conf.bak

    Examples:
      | online | limit                       | workers |
      | 16     | none                        | 16      |
      | 16     | 2 (quota 200000/100000)     | 2       |
      | 16     | 1.5 CPUs quota (rounded up) | 2       |
      | 16     | cpuset 0-3                  | 4       |
      | 16     | cpuset 0,2,4                | 3       |
