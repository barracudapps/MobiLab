import 'package:flutter/material.dart';

import 'pages/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends MaterialApp {
  const MyApp({super.key}) : super(home: const ListPage(), title: "Mobi Lab Test");
}