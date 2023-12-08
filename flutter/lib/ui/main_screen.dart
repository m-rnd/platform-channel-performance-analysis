import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_channel_performance/infinite_scroll/get_flutter_items_use_case.dart';
import 'package:platform_channel_performance/infinite_scroll/get_platform_items_use_case.dart';
import 'package:platform_channel_performance/infinite_scroll/infinite_scroll_screen.dart';
import 'package:platform_channel_performance/ui/clarke_screen.dart';
import 'package:platform_channel_performance/ui/scroll_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final String buildMode = kReleaseMode
      ? "release"
      : kProfileMode
          ? "profile"
          : "debug";

  @override
  Widget build(BuildContext context) {
    String info = "$buildMode mode on ${Platform.operatingSystem}";
    print("Flutter running in $info.");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Platform Channel Performance"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text(info),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ClarkeScreen(ownMeasurement: false)),
                    );
                  },
                  child: const Text("Tests von Clarke")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ClarkeScreen(ownMeasurement: true)),
                    );
                  },
                  child: const Text("Tests von Clarke mit meiner Messung")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScrollScreen(
                              useCase: GetFlutterItemsUseCase(false))),
                    );
                  },
                  child: const Text("Scroll")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScrollScreen(
                              useCase: GetPlatformItemsUseCase())),
                    );
                  },
                  child: const Text("Scroll mit PlatformC")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfiniteScrollScreen(
                              useCase: GetFlutterItemsUseCase(true))),
                    );
                  },
                  child: const Text("Infinite Scroll")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InfiniteScrollScreen(
                              useCase: GetPlatformItemsUseCase())),
                    );
                  },
                  child: const Text("Infinite Scroll mit PlatformC")),
            ])));
  }
}
