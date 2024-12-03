import 'package:get/get.dart';
import '../models/task_model.dart';
import '../database/task_database.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  Future<void> fetchTasks() async {
    tasks.value = await TaskDatabase.instance.getTasks();
  }

  Future<void> addTask(Task task) async {
    await TaskDatabase.instance.insertTask(task);
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.updateTask(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.deleteTask(id);
    fetchTasks();
  }
}
