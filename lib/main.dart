import 'package:flutter/material.dart';
import 'package:mfyp_cust/screens/main.scr.dart';
import 'package:provider/provider.dart';
import 'includes/handlers/user.info.handler.provider.dart';
import 'includes/utilities/colors.dart';
import 'screens/home.scr.dart';
import 'screens/search.scr.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MFYPUserInfo(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColor.primaryColor,
        ),
        body: const MFYPMainScreen(),
      ),
    );
  }
}
