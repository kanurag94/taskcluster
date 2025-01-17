---
filename: using/task-graph.md
title: Building Task Graphs
order: 50
---

# Building Task Graphs

Taskcluster supports creation of large-scale, complex task graphs.
These depend on the `dependencies` property of tasks, as well as the [decision-task convention](/docs/manual/design/conventions/descision-task).

This approach has a number of advantages over other options:

 * The set of tasks to run can be specified in the same source tree as the code
   being built, allowing unlimited flexibility in what runs and how.
 * Several event sources can all create similar decision tasks. For example, a
   push, a new pull request, and a "nightly build" hook can all create decision
   tasks with only slightly different parameters, avoiding repetition of complex
   task-definition logic in all of the related services.

## Decision-Task Best Practices

The following are best practices decision tasks, based on experience at Mozilla.
Following these practices will also ensure that your decision tasks are compatible with any later formalisms we may add around decision tasks.

 * Decision tasks call `queue.createTask` using the Taskcluster-Proxy feature,
   meaning that no Taskcluster credentials are required, and the scopes
   available for the `createTask` call are those afforded to the decision task
   itself.

 * A decision task runs with all of the scopes that any task it creates might
   need. It calculates precisely the scopes each subtask requires, and supplies
   those to the `queue.createTask` call.

 * All subtasks depend on the decision task. This ensures that, if the decision
   task crashes after having created only some of the subtasks, none of those
   tasks run and the decision task can simply be re-triggered.
