import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';

import '../utility/app_colors.dart';
class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key, required this.taskModel,
  });
   final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        title: Text(
         taskModel.title ?? '',
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskModel.description ?? '',
              style: const TextStyle(color: Colors.black87),
            ),
            Text(
             'Date: ${taskModel.createdDate ?? ''}',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    taskModel.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 1, horizontal: 10),
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: AppColors.themeColor,)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red,)),
                  ],
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}