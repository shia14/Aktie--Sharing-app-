import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/discovery_service.dart';
import 'services/transfer_service.dart';

void main() {
  runApp(const AktieApp());
}

class AktieApp extends StatelessWidget {
  const AktieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiscoveryService()),
        ChangeNotifierProvider(create: (_) => TransferService()),
      ],
      child: MaterialApp(
        title: 'Aktie',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          textTheme: GoogleFonts.sfProTextTextTheme(
            ThemeData.dark().textTheme,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF0A84FF),
            background: Color(0xFF1C1C1E),
            surface: Color(0xFF2C2C2E),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
