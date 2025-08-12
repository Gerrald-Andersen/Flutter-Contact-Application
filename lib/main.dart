import 'package:contact_list_2/contact_list_page.dart';
import 'package:contact_list_2/future_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ContactListPage(),
    );
  }
}
