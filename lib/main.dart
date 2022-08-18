import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'pages/list_page.dart';

///TODO Bloc Pattern migration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends MaterialApp {
  const MyApp({super.key}) : super(
    home: const ListPage(),
    title: "Mobi Lab Test",
    debugShowCheckedModeBanner: false,
  );
}