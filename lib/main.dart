import 'package:flutter/material.dart';
import 'package:reminder_app/my_homepage.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/database_provider.dart';
import 'package:reminder_app/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // <----
  await NotificationService().requestIOSPermissions(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReminderAppDatabaseProvider(),
      child: MaterialApp(
        title: 'YoyoRoutine',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
