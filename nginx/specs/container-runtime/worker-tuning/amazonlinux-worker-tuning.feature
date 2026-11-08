@domain:container-runtime @area:worker-tuning @from:1-27-2/amazonlinux
Feature: Sizing nginx workers to the container's CPU allowance
  Operators can opt in to having worker_processes matched to the CPUs actually available to the container.

  Background:
    Given the nginx-lua image based on Amazon Linux 2023

  @id:nginx.container-runtime.worker-tuning.016 @rule:container-runtime.worker-tuning.opt-in-autotune @inferred @source:nginx/1.27.2/amazonlinux/2023.6.20241111.0/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: Worker processes are set to the smallest of the available CPU limits when auto-tuning is enabled
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is set to 1
    And the host has 8 CPUs and the container is limited to 2 CPUs
    When the operator starts the container with the default nginx command
    Then nginx.conf contains "worker_processes 2;"
    And the original worker_processes line is kept as a comment
