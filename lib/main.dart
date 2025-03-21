import 'package:firststep/models/user.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logowanie.dart';
import 'rejestracja.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user.id == '-1') {
      return MaterialApp(
        title: 'FirstStep',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Logowanie(),
      );
    } else {
      return MaterialApp(
        title: 'FirstStep',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Test(),
      );
    }
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Center(child: Text('Test')),
    );
  }
}
