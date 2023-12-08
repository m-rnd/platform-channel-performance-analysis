import 'package:flutter/material.dart';
import 'package:platform_channel_performance/measure/fps_counter.dart';
import 'package:platform_channel_performance/measuring.dart';
import 'package:platform_channel_performance/ui/main_screen.dart';

import 'basic_message_channel.dart';

void main() {
  runApp(const MyApp());
  BasicMessageChannelImpl();
  Measuring();
  FpsMonitor();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Channel Performance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
