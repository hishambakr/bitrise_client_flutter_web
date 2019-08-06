class Post {
  final DateTime triggered_at;
  final DateTime started_on_worker_at;
  final DateTime environment_prepare_finished_at;
  final DateTime finished_at;
  final int status;
  final String status_text;
  final String triggered_workflow;
  final int duration_started_on_worker_at_to_finished_at;
  final int duration_triggered_at_to_started_on_worker_at;
  final int duration_environment_prepare_finished_at_to_started_on_worker_at;
  final String branch;

  /*"status_text": "success",
  "abort_reason": null,
  "is_on_hold": false,
  "branch": "task/dub-187",
  "build_number": 1768,
  "commit_hash": "00e03679e2f50b33736255e979a5cadf54dd1d91",
  "commit_message": "cache issue fixed with filters\n",
  "tag": null,
  "triggered_workflow": "primary-local",
  "triggered_by": "webhook",
  "stack_config_type": "standard1",
  "stack_identifier": "linux-docker-android",*/

  Post(
      {this.triggered_at,
      this.started_on_worker_at,
      this.environment_prepare_finished_at,
      this.finished_at,
      this.status,
      this.status_text,
      this.triggered_workflow,
      this.branch})
      : duration_started_on_worker_at_to_finished_at =
            finished_at.difference(started_on_worker_at).inMinutes,
        duration_triggered_at_to_started_on_worker_at =
            started_on_worker_at.difference(triggered_at).inMinutes,
        duration_environment_prepare_finished_at_to_started_on_worker_at =
            started_on_worker_at
                .difference(environment_prepare_finished_at)
                .inMinutes;

  factory Post.fromJson(Map<String, dynamic> json) {
    var post = Post(
      triggered_at: DateTime.parse(json['triggered_at']),
      started_on_worker_at:
          DateTime.parse(json['started_on_worker_at'] ?? json['triggered_at']),
      environment_prepare_finished_at: DateTime.parse(
          json['environment_prepare_finished_at'] ?? json['triggered_at']),
      finished_at: DateTime.parse(json['finished_at'] ?? json['triggered_at']),
      status: json['status'],
      status_text: json['status_text'],
      triggered_workflow: json['triggered_workflow'],
      branch: json['branch'],
    );
    return post;
  }
}
