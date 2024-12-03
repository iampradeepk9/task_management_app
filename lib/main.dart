import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'database/firebase_api_notification.dart';
import 'views/home_screen.dart';
import 'views/create_task_screen.dart';
import 'views/edit_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = box.read('isDarkMode') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/create', page: () => CreateTaskScreen()),
        GetPage(name: '/edit', page: () => EditTaskScreen()),
      ],
    );
  }
}




