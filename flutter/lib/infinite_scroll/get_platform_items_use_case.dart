import 'dart:async';

import 'package:flutter/services.dart';
import 'package:platform_channel_performance/infinite_scroll/get_items_use_case.dart';
import 'package:platform_channel_performance/infinite_scroll/scroll_item.dart';

class GetPlatformItemsUseCase implements GetItemsUseCase {
  const GetPlatformItemsUseCase();

  final _requestChannel = const MethodChannel("scrollItemRequest");

  @override
  Stream<List<ScrollItem>> getItems() => const EventChannel("scrollItemStream")
          .receiveBroadcastStream()
          .map((event) {
        final pcList = event as List<dynamic>?;

        final list = pcList
            ?.map((item) => toItem(item))
            .whereType<ScrollItem>()
            .toList();

        return list ?? <ScrollItem>[];
      });

  @override
  void loadContent({required int targetPage}) {
    _requestChannel.invokeMethod("loadContent", targetPage);
  }
}

ScrollItem? toItem(List<dynamic> list) {
  final maybeId = list[0] as int?;
  final maybeHeader = list[1] as String?;

  return (maybeId == null || maybeHeader == null)
      ? null
      : ScrollItem(maybeId, maybeHeader);
}
