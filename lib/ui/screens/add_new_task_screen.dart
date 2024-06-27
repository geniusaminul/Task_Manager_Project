import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/profile_app_bar.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/utilities/urls.dart';
import '../widgets/center_circular_indicator.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _subTEController,
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if(value?.trim().isEmpty ?? true){
                        return 'Write Task Title';
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _descriptionTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (String? value) {
                      if(value?.trim().isEmpty ?? true){
                        return 'Write Task Description';
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 16,),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const CenterCircularProgressIndicator() ,
                    child: ElevatedButton(onPressed: () {
                      if(_globalKey.currentState!.validate()){
                           _addNewTask();

                      }

                    }, child: const Icon(Icons.arrow_circle_right_outlined)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async{
    _addNewTaskInProgress = true;
    if(mounted){
      setState(() {

      });
    }

    Map<String, dynamic> requestData ={
      "title": _subTEController.text.trim(),
      "description":_descriptionTEController.text.trim(),
      "status":"New"
    };

    final NetworkResponse response = await NetworkCaller.postRequest(Urls.createTask, body: requestData);

    _addNewTaskInProgress = false;
    if(mounted){
      setState(() {

      });
    }

    if(response.isSuccess){
      _addNewTaskClear();
      if(mounted){
        showSnackBarMessage(context, 'Task Add Complete!');
      } else{
        if(mounted){
          showSnackBarMessage(context, 'Task Add failed! Try again',true);
        }

      }

    }

  }

  void _addNewTaskClear(){
    _subTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subTEController.dispose();
    _descriptionTEController.dispose();
  }
}


