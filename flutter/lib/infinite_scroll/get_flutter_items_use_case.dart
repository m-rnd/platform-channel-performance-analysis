import 'dart:async';
import 'dart:io';

import 'package:platform_channel_performance/infinite_scroll/scroll_item.dart';

import '../measure/fps_counter.dart';
import 'get_items_use_case.dart';

class GetFlutterItemsUseCase implements GetItemsUseCase {
  final bool _infiniteScroll;
  final _itemsController = StreamController<List<ScrollItem>>.broadcast();
  final List<ScrollItem> _items = [];
  int _lastPage = 0;

  String getTestName() {
    if (_infiniteScroll) {
      return Platform.isAndroid ? "T3b" : "T4b";
    } else {
      return Platform.isAndroid ? "T3a" : "T4a";
    }
  }

  @override
  Stream<List<ScrollItem>> getItems() => _itemsController.stream;

  GetFlutterItemsUseCase(this._infiniteScroll) {
    _itemsController.onListen = () {
      loadContent(targetPage: pagePreloadCount);
    };
  }

  @override
  void loadContent({required int targetPage}) {
    if (targetPage <= _lastPage) return;

    for (int newPage = _lastPage; newPage < targetPage; newPage++) {
      for (int i = 0; i < pageSize; i++) {
        _items.add(ScrollItem(
          newPage * pageSize + i,
          'Überschrift $i auf Seite $newPage',
        ));
      }
    }
    _lastPage = targetPage;
    _itemsController.add(_items);
    FpsMonitor.log("screenUpdate_${getTestName()}", -10);
  }

  void dispose() {
    _itemsController.close();
  }
}
