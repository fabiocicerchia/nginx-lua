@domain:container-runtime @area:worker-tuning @from:1-31-5/amazonlinux
Feature: Worker process tuning
  Operators let nginx size its worker processes to the CPU allowance of the container.

  @id:nginx.container-runtime.worker-tuning.056 @rule:runtime.workers.autotune-from-cpu-limit @inferred @source:nginx/1.31.5/amazonlinux/2023.12.20260817.0/tpl/30-tune-worker-processes.sh
  Scenario: Worker processes follow the smallest CPU allowance when auto-tuning is on
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set
    And the container is limited to 2 CPUs
    When the operator starts the container
    Then nginx.conf has "worker_processes 2;"
    And the original worker_processes line is kept as a comment
