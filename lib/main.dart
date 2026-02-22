import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'screens/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Anonymous sign-in
    await FirebaseAuth.instance.signInAnonymously();
  } catch (e) {
    print('Firebase init error: $e');
    // App will still work with local state fallback
  }

  runApp(const MyApp());
}

// Dark theme colors
const Color bg = Color(0xFF060608);
const Color surface = Color(0xFF13131C);
const Color card = Color(0xFF1E1E2E);
const Color gold = Color(0xFFF0C060);
const Color cyan = Color(0xFF60D0F0);
const Color purple = Color(0xFFA060F0);
const Color green = Color(0xFF50E090);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..initialize()),
      ],
      child: MaterialApp(
        title: 'SDE Prep',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.dark(
            surface: surface,
            primary: gold,
            secondary: cyan,
            tertiary: purple,
          ),
          textTheme: GoogleFonts.syneTextTheme(ThemeData.dark().textTheme)
              .copyWith(
                bodySmall: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                bodyMedium: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
          appBarTheme: AppBarTheme(
            backgroundColor: surface,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.syne(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: gold,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: surface,
            selectedItemColor: gold,
            unselectedItemColor: Colors.white30,
            elevation: 8,
          ),
          cardColor: card,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RoadmapScreen(),
    const DSAScreen(),
    const DailyTrackerScreen(),
    const MotivationScreen(),
  ];

  final List<String> _labels = [
    'Home',
    'Roadmap',
    'DSA',
    'Daily',
    'Motivation',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _labels[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: _labels[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.code),
            label: _labels[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.checklist),
            label: _labels[3],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: _labels[4],
          ),
        ],
      ),
    );
  }
}
