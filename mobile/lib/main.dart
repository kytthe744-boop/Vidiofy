import 'package:flutter/material.dart';
import 'video_screen.dart';

void main() {
  runApp(const Vidiofy());
}

class Vidiofy extends StatelessWidget {
  const Vidiofy({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoScreen(),
    );
  }
}
