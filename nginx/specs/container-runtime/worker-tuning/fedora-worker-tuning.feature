@domain:container-runtime @area:worker-tuning @from:1-31-6/fedora
Feature: Worker process auto-tuning
  Operators in CPU-limited containers can size nginx workers to the CPUs actually available.

  Background:
    Given Given the nginx-lua Fedora 44 image for nginx 1.31.6

  @id:nginx.container-runtime.worker-tuning.058 @rule:container-runtime.worker-tuning.opt-in-lowest-cpu-limit @inferred @source:nginx/1.31.6/fedora/44/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: With auto-tuning enabled, workers match the lowest CPU limit
    Given the operator sets NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE to 1
    And the container is limited to 2 CPUs on a host with 8 CPUs
    When the operator starts the container with the default nginx command
    Then nginx.conf has "worker_processes 2;"
    And the original worker_processes line is kept as a comment

  @id:nginx.container-runtime.worker-tuning.060 @rule:container-runtime.worker-tuning.read-only-config-reported @inferred @source:nginx/1.31.6/fedora/44/tpl/30-tune-worker-processes.sh#ncpu
  Scenario: A read-only nginx.conf is reported and left unchanged
    Given auto-tuning is enabled
    And nginx.conf is on a read-only file system
    When the operator starts the container with the default nginx command
    Then the log says "error: can not modify /etc/nginx/nginx.conf (read-only file system?)"
    And worker_processes is unchanged
    And nginx still starts
