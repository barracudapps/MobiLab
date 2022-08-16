import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'pages/list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends MaterialApp {
  const MyApp({super.key}) : super(
      home: const ListPage(),
      title: "Mobi Lab Test",
  );
}