import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/utilities/urls.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });

  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;
  bool _updateTaskInProgress = false;
  String dropdownValue = '';
  List<String> statusList = ['New', 'Progress', 'Completed', 'Cancel'];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        title: Text(
          widget.taskModel.title ?? '',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.description ?? '',
              style: const TextStyle(color: Colors.black87),
            ),
            Text(
              'Date: ${widget.taskModel.createdDate ?? ''}',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide.none,
                  ),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                        visible: _updateTaskInProgress == false,
                        replacement: const CenterCircularProgressIndicator(),
                        child: PopupMenuButton<String>(
                            icon: const Icon(Icons.edit),
                            onSelected: (String selectedValue) {
                              dropdownValue = selectedValue;
                              _updateTaskStatus();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return statusList.map((String value) {
                                return PopupMenuItem<String>(
                                    value: value,
                                    child: ListTile(
                                      title: Text(value),
                                      trailing: dropdownValue == value
                                          ? const Icon(Icons.done)
                                          : null,
                                    ));
                              }).toList();
                            })),
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: IconButton(
                          onPressed: () {
                            _deleteTask();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(context, "Task Delete Failed! Try again");
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateTaskStatus() async {
    _updateTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.updateTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Task update failed! Try again');
      }
    }
    _updateTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
