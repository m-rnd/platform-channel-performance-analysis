import 'dart:io';

import 'package:flutter/material.dart';
import 'package:platform_channel_performance/infinite_scroll/scroll_item.dart';
import 'package:platform_channel_performance/measure/fps_counter.dart';

import '../infinite_scroll/get_items_use_case.dart';
import '../infinite_scroll/get_platform_items_use_case.dart';
import '../measuring.dart';

class ScrollScreen extends StatefulWidget {
  final GetItemsUseCase useCase;
  const ScrollScreen({super.key, required this.useCase});

  String getTestName() {
    if (useCase is GetPlatformItemsUseCase) {
      return Platform.isAndroid ? "T5a" : "T6a";
    } else {
      return Platform.isAndroid ? "T3a" : "T4a";
    }
  }

  @override
  State<ScrollScreen> createState() => _ScrollScreenState();
}

class _ScrollScreenState extends State<ScrollScreen> {
  List<ScrollItem> items = [];

  @override
  void initState() {
    FpsMonitor.start(widget.getTestName());

    widget.useCase.getItems().listen((list) {
      setState(() {
        items = list;
      });
    });

    widget.useCase.loadContent(targetPage: 100);

    super.initState();
  }

  @override
  void dispose() {
    FpsMonitor.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter ScrollScreen"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
                leading: Text("${items[index].id}"),
                title: Text(items[index].header));
          },
          itemCount: items.length,
        ));
  }
}
