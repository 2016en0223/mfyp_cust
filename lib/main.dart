import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:mfyp_cust/includes/utilities/colors.dart';
import 'package:mfyp_cust/screens/welcome.scr.dart';
import 'package:provider/provider.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'firebase_option.dart';
import 'includes/handlers/user.info.handler.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.primaryColor,
    //color set to transperent or set your own color
    statusBarIconBrightness: Brightness.light,
    //set brightness for icons, like dark background light icons
  ));

  runApp(
    MyApp(
      child: ChangeNotifierProvider(
        create: (context) => MFYPUserInfo(),
        child: GetMaterialApp(
          title: 'Drivers App',
          navigatorKey: MyDialog.navigatorKey,
          defaultTransition: Transition.native,
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.cyan,
            fontFamily: "SanFrancisco",
          ),
          home: const MFYPWelcomePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  const MyApp({super.key, this.child});

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
