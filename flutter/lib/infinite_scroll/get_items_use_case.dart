import 'package:platform_channel_performance/infinite_scroll/scroll_item.dart';

const int pageSize = 10;
const int pagePreloadCount = 1;

abstract class GetItemsUseCase {
  Stream<List<ScrollItem>> getItems();
  void loadContent({required int targetPage});
}
