import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:lodgix/providers/theme_provider.dart';
import 'package:lodgix/themes/theme.dart';
import 'package:lodgix/widgets/splash_screen.dart';
// import 'package:lodgix/providers/user_provider.dart';
// import 'package:lodgix/screens/entryScreens/loginPage.dart';
// import 'package:lodgix/screens/normalMode/dashboard.dart';
// import 'package:lodgix/screens/request.dart';
// import 'package:lodgix/shared/quote_service.dart';
// import 'package:lodgix/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive
  // await Hive.initFlutter();
  // await initRequestService(); 
  
  // // Initialize UserProvider early
  // final userProvider = UserProvider();
  // await userProvider.initHive();
  
  // // Initialize app services
  // final notificationService = NotificationService();
  // notificationService.registerAsGlobal();
  // QuoteService.initializeQuotes();
  
  runApp(
  
     MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lodgix',
      theme: Lodgix.lightTheme,
      darkTheme: Lodgix.darkTheme,
      themeMode: themeProvider.themeMode,
      home: SplashScreen(), 
      // routes: {
      //   '/dashboard': (context) => Dashboard(),
      //   '/login': (context) => Login(),
      // },
    );
  }
}