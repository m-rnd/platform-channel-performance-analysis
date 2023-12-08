import 'package:flutter/services.dart';

class BasicMessageChannelImpl {
  BasicMessageChannelImpl() {
    const BasicMessageChannel("BasicMessageChannelString", StringCodec())
        .setMessageHandler(_basicMessageHandlerString);

    const BasicMessageChannel("BasicMessageChannelBinary", BinaryCodec())
        .setMessageHandler(_basicMessageHandlerBinary);
    const BasicMessageChannel("BasicMessageChannelBinaryDirect", BinaryCodec())
        .setMessageHandler(_basicMessageHandlerBinary);
    const BasicMessageChannel("BasicMessageChannelSM", StandardMessageCodec())
        .setMessageHandler(_basicMessageHandler);
  }

  Future<String> _basicMessageHandlerString(String? msg) async {
    return "";
  }

  Future<Object> _basicMessageHandler(Object? msg) async {
    return "";
  }

  Future<ByteData> _basicMessageHandlerBinary(ByteData? msg) async {
    return ByteData(0);
  }
}
