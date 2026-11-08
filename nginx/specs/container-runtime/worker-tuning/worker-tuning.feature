@domain:container-runtime @area:worker-tuning @from:1-25-1/ubuntu
Feature: Worker process tuning from CPU limits
  Lets operators size nginx workers to the CPUs a container is actually allowed to use.

  Background:
    Given Given the nginx-lua 1.25.1 Ubuntu 22.04 image

  @id:nginx.container-runtime.worker-tuning.003 @rule:runtime.workers.autotune-uses-smallest-cpu-limit @inferred @source:nginx/1.25.1/ubuntu/22.04/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: Worker count follows the smallest CPU limit when autotune is on
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set
    And the host has 8 CPUs and the container is limited to 2 CPUs
    When the operator starts the container with the command nginx
    Then nginx.conf sets worker_processes 2
    And the previous worker_processes line is kept as a comment

  @id:nginx.container-runtime.worker-tuning.004 @rule:runtime.workers.autotune-is-opt-in @inferred @source:nginx/1.25.1/ubuntu/22.04/tpl/30-tune-worker-processes.sh#ME
  Scenario: Worker count is not touched unless autotune is requested
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is not set
    When the operator starts the container with the command nginx
    Then nginx.conf keeps its original worker_processes value
