import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'Models/Transactions_model.dart';
import 'Models/transactionAdapter.dart';
import 'Pages/Automate_page.dart';
import 'Pages/History_page.dart';
import 'Pages/Home_page.dart';
import 'Pages/Track_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.registerAdapter(ItemAdapter());
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox('transactions');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(255, 107, 100, 237),
            secondary: Color(0xFFAA4AE4),
          ),
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: FutureBuilder(
          future: Hive.openBox('transactions'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print("reached build");
                return SafeArea(
                    child: Text(
                  "${snapshot.error}",
                  style: TextStyle(fontSize: 20),
                ));
              } else {
                return const MyHomePage(title: 'Wallet');
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
        // child: ,
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOptions = <Widget>[
    Home_page(),
    Automate_page(),
    Track_page(),
    History_page(),
  ];
  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _selectedIndex == 1
              ? GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Icon(Icons.add),
                  ),
                  onTap: () {},
                )
              : Container(),
        ],
      ),
      body: ChangeNotifierProvider(
          create: (context) => TransactionsModel(),
          // child: _widgetOptions.elementAt(_selectedIndex),
          child: _selectedIndex == 0
              ? _widgetOptions[0]
              : _selectedIndex == 1
                  ? Automate_page()
                  : _selectedIndex == 2
                      ? _widgetOptions[2]
                      : _widgetOptions[3]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Automate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.check_circle_outline_rounded),
          //   label: 'Track',
          // ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
