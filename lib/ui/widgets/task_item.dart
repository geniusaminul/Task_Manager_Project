import 'package:flutter/material.dart';

import '../utility/app_colors.dart';
class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        title: Text(
          "Title will be here",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description will be here',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              '08/5/2024',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    'New',
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: AppColors.themeColor,)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.red,)),
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