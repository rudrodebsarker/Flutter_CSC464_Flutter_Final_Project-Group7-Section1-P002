import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/game_provider.dart';
import 'providers/history_provider.dart';
import 'screens/game_screen.dart';
import 'screens/history_screen.dart';
import 'screens/setup_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RadiantToeApp());
}

class RadiantToeApp extends StatelessWidget {
  const RadiantToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>(
          create: (_) => GameProvider(),
        ),
        ChangeNotifierProvider<HistoryProvider>(
          create: (_) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Kata Golla by 7',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/setup',
        routes: {
          '/setup': (_) => const SetupScreen(),
          '/game': (_) => const GameScreen(),
          '/history': (_) => const HistoryScreen(),
        },
      ),
    );
  }
}
