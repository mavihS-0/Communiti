import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_for_all/screens/NGO/navBarNGO.dart';
import 'package:one_for_all/screens/NGO/signupngo.dart';
import 'package:one_for_all/screens/volunteer/navBarVol.dart';
import 'package:one_for_all/screens/volunteer/signupvol.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:one_for_all/screens/onboarding_screen.dart';
import 'package:one_for_all/utils/start.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'One For All',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: ()=>StartPage()),
        GetPage(name: "/onboarding", page: ()=>OnboardingScreen()),
        GetPage(name: "/signUpNGO", page: ()=>SignUpNGO()),
        GetPage(name: "/signUpVol", page: ()=>SignUpVol()),
        GetPage(name: '/navBarNGO', page: ()=>NavBarNGO()),
        GetPage(name: "/navBarVol", page: ()=>NavBarVol()),
      ],
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
