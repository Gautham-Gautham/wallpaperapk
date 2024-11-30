import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperk/photo_provider.dart';

import 'home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PhotoProvider(),
      child: const WallpaperApp(),
    ),
  );
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpaper App',
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      ),
    );
  }
}
