import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final isDarkMode = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<Task> filteredTasks = <Task>[].obs;

  HomeScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storedTheme = GetStorage().read<bool>('isDarkMode') ?? false;
      isDarkMode.value = storedTheme;
      Get.changeThemeMode(storedTheme ? ThemeMode.dark : ThemeMode.light);
    });
  }

  @override
  Widget build(BuildContext context) {
    taskController.fetchTasks();

    void filterTasks(String query) {
      if (query.isEmpty) {
        filteredTasks.value = taskController.tasks;
      } else {
        filteredTasks.value = taskController.tasks.where((task) {
          return task.name.toLowerCase().contains(query.toLowerCase()) ||
              task.dueDate.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    }

    searchController.addListener(() {
      filterTasks(searchController.text);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                Icons.home,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        centerTitle: false,
        elevation: 2,
        actions: [
          Obx(() => Row(
            children: [
              Text(
                isDarkMode.value ? "Dark Mode" : "Light Mode",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Switch(
                value: isDarkMode.value,
                onChanged: (value) {
                  isDarkMode.value = value;
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  GetStorage().write('isDarkMode', value);
                },
              ),
            ],
          )),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search by task name or due date",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        List<Task> tasksToDisplay = filteredTasks.isEmpty ? taskController.tasks : filteredTasks;

        if (tasksToDisplay.isEmpty) {
          return const Center(
            child: Text(
              "No Tasks Found!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: tasksToDisplay.length,
          itemBuilder: (context, index) {
            final task = tasksToDisplay[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: task.isCompleted ? Colors.greenAccent : Colors.blueAccent,
                  child: Icon(
                    task.isCompleted ? Icons.check : Icons.assignment,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  task.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  "Due: ${task.dueDate}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    task.isCompleted = value!;
                    taskController.updateTask(task);
                  },
                ),
                onTap: () {
                  Get.toNamed('/edit', arguments: task);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/create'),
        label: Text("Add Task"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}