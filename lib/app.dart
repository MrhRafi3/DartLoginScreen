import 'package:flutter/material.dart';

import 'package:oglet/core/constants/design_tokens.dart';
import 'package:oglet/presentation/screens/oglet_screen.dart';

class OgletApp extends StatelessWidget {
  const OgletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oglet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: DesignTokens.fontFamily,
        scaffoldBackgroundColor: DesignTokens.paper,
      ),
      home: const Scaffold(
        backgroundColor: DesignTokens.paper,
        body: OgletScreen(),
      ),
    );
  }
}
