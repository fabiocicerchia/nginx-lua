@domain:container-runtime @area:worker-tuning @from:1-29-1/debian
Feature: Worker process tuning
  Operators can have nginx size its workers to the CPUs the container may really use.

  Background:
    Given Given the nginx-lua Debian 13 image is started with the default nginx command

  @id:nginx.container-runtime.worker-tuning.031 @rule:container-runtime.worker-tuning.opt-in-autotune-uses-smallest-cpu-limit @inferred @source:nginx/1.29.1/debian/13.1/tpl/30-tune-worker-processes.sh
  Scenario: With autotune on, workers match the smallest CPU limit the container has
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the host has 8 CPUs
    And the container is limited to 2.5 CPUs
    When the operator starts the container
    Then nginx.conf sets "worker_processes 3;"
    And the previous worker_processes line is kept as a comment
