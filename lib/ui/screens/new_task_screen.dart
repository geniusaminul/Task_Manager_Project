import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        onPressed: _moveAddNewTaskButton,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        child: Column(
          children: [
            _buildSummarySection(),
            const SizedBox(height: 8,),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const TaskItem();
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _moveAddNewTaskButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewTaskScreen(),));

  }
  Widget _buildSummarySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TaskSummaryCard(
            count: '06',
            title: 'New Task',
          ),
          TaskSummaryCard(
            count: '19',
            title: 'Completed',
          ),
          TaskSummaryCard(
            count: '07',
            title: 'Progress',
          ),
          TaskSummaryCard(
            count: '09',
            title: 'Canceled',
          ),
        ],
      ),
    );
  }
}




