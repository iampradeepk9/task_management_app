import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final Task task = Get.arguments;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = task.name;
    descriptionController.text = task.description;
    dueDateController.text = task.dueDate;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dueDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Due Date",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(task.dueDate),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  dueDateController.text = "${date.toLocal()}".split(' ')[0];
                }
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  dueDate: dueDateController.text,
                  isCompleted: task.isCompleted,
                );
                taskController.updateTask(updatedTask);
                Get.back();
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
