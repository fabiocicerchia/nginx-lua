@domain:container-runtime @area:worker-tuning @from:1-29-2/fedora
Feature: Worker process tuning
  Lets an operator size nginx workers to the CPU the container is actually allowed to use.

  Background:
    Given the Fedora 42 nginx-lua image

  @id:nginx.container-runtime.worker-tuning.034 @rule:runtime.workers.match-available-cpus @inferred @source:nginx/1.29.2/fedora/42/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario: With autotune on, workers equal the smallest CPU limit in effect
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is 1
    And the host has 8 CPUs and the container is limited to 2.5 CPUs
    When the operator starts the container
    Then nginx.conf contains "worker_processes 3;"
    And the original worker_processes line is kept commented out
