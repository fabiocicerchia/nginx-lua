@domain:container-runtime @area:worker-tuning @from:1-31-2/debian
Feature: Worker process tuning
  Lets an operator size nginx workers to the CPUs actually available to the container.

  Background:
    Given Given the operator runs the debian 13.5 nginx 1.31.2 image

  @id:nginx.container-runtime.worker-tuning.052 @rule:container.workers.autotune-uses-smallest-cpu-limit @inferred @source:nginx/1.31.2/debian/13.5/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: With autotune enabled, worker processes match the smallest CPU limit
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set
    And the host has 8 CPUs and the container is limited to 2.5 CPUs
    When the operator starts the container with the command "nginx"
    Then nginx.conf has "worker_processes 3;"
    And the original worker_processes line is kept as a comment
