@domain:container-runtime @area:worker-tuning @from:1-25-1/almalinux
Feature: Worker process autotuning
  Lets an operator size nginx workers to the CPUs the container may use.

  Background:
    Given the AlmaLinux 9.2 nginx-lua image is started

  @id:nginx.container-runtime.worker-tuning.001 @rule:runtime.workers.autotune-opt-in-limits-to-cpu-allowance @inferred @source:nginx/1.25.1/almalinux/9.2-20230718/tpl/30-tune-worker-processes.sh
  Scenario Outline: Worker processes follow the container CPU allowance when autotune is enabled
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the container is limited to <limit> on a host with 8 CPUs
    When the operator starts the container with the default nginx command
    Then nginx.conf declares "worker_processes <workers>;"
    And the previous worker_processes line is kept as a comment

    Examples:
      | limit             | workers |
      | 2 CPUs by quota   | 2       |
      | 1.5 CPUs by quota | 2       |
      | cpuset of 0-2     | 3       |
      | no limit          | 8       |

  @id:nginx.container-runtime.worker-tuning.002 @rule:runtime.workers.autotune-off-by-default @inferred @source:nginx/1.25.1/almalinux/9.2-20230718/tpl/30-tune-worker-processes.sh
  Scenario: Worker processes are left unchanged unless autotune is requested
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is not set
    When the operator starts the container with the default nginx command
    Then nginx.conf keeps its original worker_processes line
