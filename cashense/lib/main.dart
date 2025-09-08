import 'package:cashense/colors.dart';
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
      theme: ThemeData(
        fontFamily: 'Avenir',
        primaryColor: Colors.white,
        primaryColorDark: Colors.grey[200],
        primaryColorLight: Colors.grey[100],
        brightness: Brightness.light,
        canvasColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Theme.of(context).colorScheme.accentColor,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Avenir',
        primaryColor: Colors.black,
        primaryColorDark: Colors.grey[800],
        brightness: Brightness.dark,
        primaryColorLight: Colors.grey[850],
        tabBarTheme: TabBarThemeData(
          indicatorColor: Colors.white,
        ),
        canvasColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(
              secondary: Theme.of(context).colorScheme.accentColor,
            ),
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: HomePage(
          title: "Cashense",
        ),
        floatingActionButton: FAB(openPage: OpenTestPage()),
      ),
    );
  }
}
