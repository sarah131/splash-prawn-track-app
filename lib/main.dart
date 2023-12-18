import 'package:dashboard_1/notification/notification.dart';
import 'package:dashboard_1/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'providers/pathProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  notification.init();
  // listenNotification();

  runApp(const myApp());
}

int i = 0;

// void listenNotification()=>notification.
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PathProvider())
      ],
      builder: (context, _) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: provider.themeMode,
          theme: themeShifter.lighttheme,
          darkTheme: themeShifter.darktheme,
          home: const home(),
        );
        
      },
    );
  }
}
