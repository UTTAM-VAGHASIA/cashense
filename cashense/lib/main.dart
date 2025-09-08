import 'package:cashense/widgets/fab.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Cashense());
}

class Cashense extends StatelessWidget {
  const Cashense({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: HomePage(
          title: "Cashense",
        ),
        floatingActionButton: FAB(openPage: OpenTestPage()),
      ),
    );
  }
}
