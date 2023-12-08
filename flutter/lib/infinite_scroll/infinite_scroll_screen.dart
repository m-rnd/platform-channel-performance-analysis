import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:platform_channel_performance/infinite_scroll/get_platform_items_use_case.dart';
import 'package:platform_channel_performance/infinite_scroll/scroll_item.dart';
import 'package:platform_channel_performance/infinite_scroll/get_flutter_items_use_case.dart';
import 'package:platform_channel_performance/measure/fps_counter.dart';

import '../measuring.dart';
import 'get_items_use_case.dart';

class InfiniteScrollScreen extends StatefulWidget {
  final GetItemsUseCase useCase;

  const InfiniteScrollScreen({super.key, required this.useCase});

  String getTestName() {
    if (useCase is GetPlatformItemsUseCase) {
      return Platform.isAndroid ? "T5b" : "T6b";
    } else {
      return Platform.isAndroid ? "T3b" : "T4b";
    }
  }

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<ScrollItem> items = [];

  int lastPage = 0;

  @override
  void initState() {
    FpsMonitor.start(widget.getTestName());

    widget.useCase.getItems().listen((list) {
      setState(() {
        items = list;
      });
    });
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
          title: const Text("Flutter InfiniteScrollScreen"),
        ),
        body: Column(children: [
          Text("${items.length} Items geladen, letzte Seite: $lastPage"),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              if (index >= items.length - pageSize) {
                final nextPage =
                    ((index + pageSize) ~/ pageSize) + pagePreloadCount;
                lastPage = max(lastPage, nextPage);
                widget.useCase.loadContent(targetPage: lastPage);
              }

              return ListTile(
                  leading: Text("${items[index].id}"),
                  title: Text(items[index].header));
            },
            itemCount: items.length,
          )),
        ]));
  }
}
