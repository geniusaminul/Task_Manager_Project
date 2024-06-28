import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_status_count_wrapper_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/utilities/urls.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;
  bool _taskStatusCountInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskStatusCountModel> taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getNewTasks();
    _getTaskStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: _moveAddNewTaskButton,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: RefreshIndicator(
                onRefresh:() async{
                  _getNewTasks();
                  _getTaskStatusCount();
                },
                child: Visibility(
                  visible: _getNewTaskInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        taskModel: newTaskList[index],
                        onUpdateTask: () {
                          _getTaskStatusCount();
                          _getNewTasks();
                        },
                      );
                    },
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _moveAddNewTaskButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddNewTaskScreen(),
        ));
  }

  Widget _buildSummarySection() {
    return Visibility(
      visible: _taskStatusCountInProgress == false,
      replacement: const CenterCircularProgressIndicator(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskStatusCountList.map(
            (e) {
              return TaskSummaryCard(
                count: e.sum.toString(),
                title: e.sId ?? 'Unknown'.toUpperCase(),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Future<void> _getTaskStatusCount() async {
    _taskStatusCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskStatusCountWrapperModel taskStatusCountWrapperModel = TaskStatusCountWrapperModel.fromJson(response.responseData);
      taskStatusCountList = taskStatusCountWrapperModel.taskCountStatusList ?? [];

    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get Task Status Count failed! Try again');
      }

    }
    _taskStatusCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  Future<void> _getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];

    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get New Task failed! Try again');
      }

    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
