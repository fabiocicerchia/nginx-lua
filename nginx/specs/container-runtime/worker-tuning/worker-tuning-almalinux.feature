@domain:container-runtime @area:worker-tuning @from:1-27-5/almalinux
Feature: Worker process autotuning
  Operators can have nginx size its worker processes to the CPU the container may actually use.

  Background:
    Given Given the nginx-lua image based on AlmaLinux 9.6 is used

  @id:nginx.container-runtime.worker-tuning.021 @rule:container.workers.autotune-is-opt-in @inferred @source:nginx/1.27.5/almalinux/9.6-20250611/tpl/30-tune-worker-processes.sh
  Scenario: Worker processes are left unchanged unless autotune is requested
    Given nginx.conf sets "worker_processes auto;"
    And NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is unset
    When the operator starts the container with the default nginx command
    Then nginx.conf still contains "worker_processes auto;"

  @id:nginx.container-runtime.worker-tuning.022 @rule:container.workers.use-smallest-cpu-limit @inferred @source:nginx/1.27.5/almalinux/9.6-20250611/tpl/30-tune-worker-processes.sh
  Scenario Outline: With autotune on, worker count is the smallest of the online CPUs, cpuset and CPU quota limits
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the container is limited to a CPU quota of <quota> on a host with <online> online CPUs
    When the operator starts the container with the default nginx command
    Then nginx.conf contains "worker_processes <workers>;"
    And the original worker_processes line is kept as a comment

    Examples:
      | online | quota    | workers |
      | 8      | 2.5 CPUs | 3       |
      | 8      | 1 CPU    | 1       |
      | 4      | no quota | 4       |

  @id:nginx.container-runtime.worker-tuning.023 @rule:container.workers.read-only-config-is-reported @inferred @source:nginx/1.27.5/almalinux/9.6-20250611/tpl/30-tune-worker-processes.sh
  Scenario: A read-only nginx.conf is reported and startup continues
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And /etc/nginx/nginx.conf is on a read-only filesystem
    When the operator starts the container with the default nginx command
    Then the error output shows "can not modify /etc/nginx/nginx.conf (read-only file system?)"
    And nginx starts with the original worker_processes
