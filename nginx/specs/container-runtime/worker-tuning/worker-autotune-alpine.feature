@domain:container-runtime @area:worker-tuning @from:1-27-4/alpine
Feature: Sizing nginx workers to the container's CPU allowance
  Operators who opt in get worker_processes matched to the CPUs the container may actually use.

  Background:
    Given Given the nginx 1.27.4 Alpine image

  @id:nginx.container-runtime.worker-tuning.020 @rule:container-runtime.worker-tuning.smallest-cpu-limit-wins @inferred @source:nginx/1.27.4/alpine/3.21.3/tpl/30-tune-worker-processes.sh#ceildiv
  Scenario: Workers match the smallest of online CPUs, cpuset and CPU quota
    Given the host has 8 online CPUs
    And the container is limited to a quota of 2.5 CPUs
    When the operator starts the container with autotune enabled
    Then worker_processes is set to 3
