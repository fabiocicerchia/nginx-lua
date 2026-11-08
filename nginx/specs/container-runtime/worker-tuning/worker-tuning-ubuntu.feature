@domain:container-runtime @area:worker-tuning @from:1-28-0/ubuntu
Feature: Worker process autotuning
  Serves operators who want nginx sized to the CPUs a container is actually allowed to use.

  @id:nginx.container-runtime.worker-tuning.026 @rule:container.workers.autotune-opt-in @inferred @source:nginx/1.28.0/ubuntu/24.04/tpl/30-tune-worker-processes.sh
  Scenario: Worker processes are left unchanged unless autotune is requested
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is not set
    When the operator starts the container with the nginx command
    Then nginx.conf keeps its worker_processes line

  @id:nginx.container-runtime.worker-tuning.027 @rule:container.workers.limited-to-smallest-cpu-limit @inferred @source:nginx/1.28.0/ubuntu/24.04/tpl/30-tune-worker-processes.sh
  Scenario Outline: Worker count follows the smallest CPU limit available
    Given autotune is requested
    And the host has <online> CPUs and the container is limited to <limit>
    When the operator starts the container with the nginx command
    Then nginx.conf has "worker_processes <workers>;"
    And the previous line is kept as a comment

    Examples:
      | online | limit              | workers |
      | 8      | 2 CPUs via quota   | 2       |
      | 8      | 1.5 CPUs via quota | 2       |
      | 8      | cpuset of 0-3      | 4       |
      | 4      | no limit           | 4       |

  @id:nginx.container-runtime.worker-tuning.028 @rule:container.workers.readonly-config-skipped @inferred @source:nginx/1.28.0/ubuntu/24.04/tpl/30-tune-worker-processes.sh
  Scenario: Autotune is skipped when nginx.conf is read-only
    Given autotune is requested
    And nginx.conf cannot be modified
    When the operator starts the container with the nginx command
    Then an error message "can not modify /etc/nginx/nginx.conf (read-only file system?)" is printed
    And nginx still starts with the original setting
