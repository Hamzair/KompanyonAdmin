import 'package:admin_panel_komp/Login_Page.dart';
import 'package:admin_panel_komp/main_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kompanyon Admin',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      getPages: const [],
      unknownRoute: GetPage(
        name: '/home',
        page: () => FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : const MainDashboard(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => UserController());
        }),
      ),
    );
  }
}
