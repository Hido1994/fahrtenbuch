import 'package:fahrtenbuch/view/screen/report_screen.dart';
import 'package:fahrtenbuch/view/screen/trips_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fahrtenbuch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              brightness: Brightness.dark,
              backgroundColor: Colors.black,
              accentColor: Colors.white,
              cardColor: Colors.black)),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  Map<String, dynamic> routes = {
    '/': const TripsScreen(),
    '/report': const ReportScreen(),
  };

  @override
  void initState() {
    // PreferenceService preferenceService = PreferenceService();
    // String? databasePath = await preferenceService.getDatabasePath();
    //
    // if(databasePath == null) {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles();
    //
    //   if (result != null) {
    //     // File file = File(result.files.single.path);
    //   } else {
    //     // Do something else...
    //   }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fahrtenbuch'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Einträge',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: 'Bericht',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            _navigatorKey.currentState
                ?.popAndPushNamed(routes.keys.toList()[index]);
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (_) => routes[settings.name]);
          },
        ));
  }
}
