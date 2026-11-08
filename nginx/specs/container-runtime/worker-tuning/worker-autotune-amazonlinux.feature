@domain:container-runtime @area:worker-tuning @from:1-29-1/amazonlinux
Feature: Worker process tuning
  Lets an operator size nginx workers to the CPU actually available to the container.

  Background:
    Given the Amazon Linux nginx-lua image

  @id:nginx.container-runtime.worker-tuning.030 @rule:container.workers.autotune-opt-in-uses-smallest-cpu-limit @inferred @source:nginx/1.29.1/amazonlinux/2023.9.20250929.0/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: Worker count follows the smallest CPU limit when autotune is enabled
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set
    And the container is limited to 2 CPUs by quota on a 8 CPU host
    When the operator starts the container
    Then worker_processes in nginx.conf is set to 2
    And the original line is kept as a comment
