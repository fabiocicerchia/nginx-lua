@domain:container-runtime @area:worker-tuning @from:1-29-3/fedora
Feature: Worker process autotuning
  Lets an operator size nginx workers to the CPUs actually available to the container.

  Background:
    Given Given the Fedora 42 image for nginx 1.29.3

  @id:nginx.container-runtime.worker-tuning.040 @rule:container-runtime.worker-tuning.default-untouched @inferred @source:nginx/1.29.3/fedora/42/tpl/30-tune-worker-processes.sh
  Scenario: Without the opt-in variable the worker setting is left alone
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is not set
    When the operator starts the container with the default nginx command
    Then nginx.conf keeps its original worker_processes line
