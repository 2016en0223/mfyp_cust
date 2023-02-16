import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'includes/handlers/user.info.handler.provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MFYPUserInfo(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}


