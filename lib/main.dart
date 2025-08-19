import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'request.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

import 'widgets/splash_screen.dart';
import 'themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Initialize Hive
    await Hive.initFlutter();
    print('Hive initialized successfully');
    
    // Initialize Request Service
    RequestService.initialize();
    print('RequestService initialized successfully');
    
    // Load any saved auth token
    await RequestService.loadAuthToken();
    print('Auth token loading completed');
    
  } catch (e) {
    print('Initialization error: $e');
  }
  
  runApp(
    // Use MultiProvider to include both providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()), // Add UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Lodgix',
          theme: Lodgix.lightTheme.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(Lodgix.lightTheme.textTheme),
          ),
          darkTheme: Lodgix.darkTheme.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(Lodgix.darkTheme.textTheme),
          ),
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
