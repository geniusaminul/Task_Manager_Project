import 'package:task_manager/data/models/task_status_count_model.dart';

class TaskStatusCountWrapperModel {
  String? status;
  List<TaskStatusCountModel>? taskCountStatusList;

  TaskStatusCountWrapperModel({this.status, this.taskCountStatusList});

  TaskStatusCountWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskCountStatusList = <TaskStatusCountModel>[];
      json['data'].forEach((v) {
        taskCountStatusList!.add(TaskStatusCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskCountStatusList != null) {
      data['data'] = taskCountStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


