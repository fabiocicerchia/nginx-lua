@domain:container-runtime @area:worker-tuning @from:1-29-2/alpine
Feature: Tuning worker processes to available CPUs
  Operators opt in to sizing nginx workers to the CPUs the container may really use.

  Background:
    Given Given the nginx-lua Alpine image started with the nginx command

  @id:nginx.container-runtime.worker-tuning.033 @rule:workers.autotune.opt-in-uses-smallest-cpu-limit @inferred @source:nginx/1.29.2/alpine/3.22.2/tpl/30-tune-worker-processes.sh
  Scenario Outline: With autotune enabled, worker_processes is set to the smallest CPU limit
    Given NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE is <autotune>
    And the host has 8 CPUs and the container is limited to <limit>
    When the operator starts the container
    Then <outcome>

    Examples:
      | autotune | limit                 | outcome                                                          |
      | unset    | 2 CPUs                | nginx.conf worker_processes is unchanged                         |
      | 1        | 2 CPUs                | worker_processes is 2 and the original line is kept as a comment |
      | 1        | 1.5 CPUs (rounded up) | worker_processes is 2                                            |
