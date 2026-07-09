import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wifi_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WiFiFinderApp());
}

class WiFiFinderApp extends StatelessWidget {
  const WiFiFinderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WiFiProvider()),
      ],
      child: MaterialApp(
        title: 'WiFi Finder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
