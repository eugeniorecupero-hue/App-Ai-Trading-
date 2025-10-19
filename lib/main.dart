import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'providers/market_provider.dart';
import 'providers/signal_provider.dart';
import 'providers/portfolio_provider.dart';

void main() {
  runApp(const AtlasAITraderApp());
}

class AtlasAITraderApp extends StatelessWidget {
  const AtlasAITraderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => SignalProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: 'Atlas AI Trader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F1115),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F1115),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF3B82F6),
            secondary: const Color(0xFF10B981),
            surface: const Color(0xFF1F2937),
            error: const Color(0xFFEF4444),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

