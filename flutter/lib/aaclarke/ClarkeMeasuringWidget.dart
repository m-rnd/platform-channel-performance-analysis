import 'dart:async';

import 'package:flutter/material.dart';
import 'package:platform_channel_performance/aaclarke/pigeon.dart';
import 'package:platform_channel_performance/measuring.dart';

import 'MessagingTiming.dart';

const int _testRunCount = 10000;
bool ownMeasurements = false;

class ClarkeMeasuringWidget extends StatefulWidget {
  final bool ownMeasurement;
  ClarkeMeasuringWidget({super.key, required this.ownMeasurement}) {
    ownMeasurements = ownMeasurement;
  }

  @override
  State<ClarkeMeasuringWidget> createState() => _ClarkeMeasuringWidgetState();
}

class _ClarkeMeasuringWidgetState extends State<ClarkeMeasuringWidget> {
  Map<String, double> _results = {};

  _Test _makeTest(
      String name, String label, Future<double> Function(String name) run) {
    return _Test(
        name: name,
        run: run,
        message: ownMeasurements ? label : '$label: ${_results[name]} µs');
  }

  List<_Test> get _tests {
    return _imap([
      ['simple method channel (1st run)', _calcSimpleMethodChannel],
      ['simple method channel (2nd run)', _calcSimpleMethodChannel],
      ['basic message channel (1st run)', _calcBasicMessageChannel],
      ['basic message channel (2nd run)', _calcBasicMessageChannel],
      [
        'basic message channel binary (1st run)',
        _calcBasicMessageChannelBinary
      ],
      [
        'basic message channel binary (2nd run)',
        _calcBasicMessageChannelBinary
      ],
      ['pigeon (1st run)', _calcPigeon],
      ['pigeon (2nd run)', _calcPigeon],
      ['just Dart', _calcDart],
      ['measuring baseline', _calcMeasuringBaseline],
    ], (int index, List entry) => _makeTest('$index', entry[0], entry[1]))
        .toList();
  }

  Future<void> _runTests() async {
    for (_Test test in _tests) {
      double value = await test.run(test.message);
      if (!mounted) return;
      setState(() {
        _results[test.name] = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: _imap(_tests, (int index, _Test test) {
      return Container(
        padding: new EdgeInsets.all(5.0),
        height: 50,
        color: Colors.amber[index % 9 * 100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(test.message)],
        ),
      );
    }).toList());
  }
}

// from aaclarke example/main.dart
class _Test {
  final Future<double> Function(String name) run;
  final String message;
  final String name;
  _Test({required this.run, required this.message, required this.name});
}

Iterable<U> _imap<T, U>(
    Iterable<T> list, U Function(int index, T input) mapper) sync* {
  int count = 0;
  for (T value in list) {
    yield mapper(count++, value);
  }
}

Future<double> _measureVoidString(
    Future<String> Function() func, String name) async {
  double simpleMethodChannel;
  int count = _testRunCount;
  try {
    if (ownMeasurements) {
      for (int i = 0; i < count; ++i) {
        Measuring.startMeasuring(name, i);
        await func();
        Measuring.endMeasuring(name, i);
      }
      Measuring.printLogs();
      simpleMethodChannel = 100;
    } else {
      DateTime start = DateTime.now();
      for (int i = 0; i < count; ++i) {
        await func();
      }
      Duration delta = DateTime.now().difference(start);
      simpleMethodChannel = delta.inMicroseconds / count;
    }
  } catch (ex) {
    print(ex);
    simpleMethodChannel = -1;
  }
  return simpleMethodChannel;
}

Future<double> _calcSimpleMethodChannel(String name) async {
  final MessagingTiming messagingTiming = MessagingTiming();
  return await _measureVoidString(
      () => messagingTiming.methodChannelPlatformVersion, name);
}

Future<double> _calcBasicMessageChannel(String name) async {
  final MessagingTiming messagingTiming = MessagingTiming();
  return await _measureVoidString(
      () => messagingTiming.basicMessageChannelPlatformVersion, name);
}

Future<double> _calcBasicMessageChannelBinary(String name) async {
  final MessagingTiming messagingTiming = MessagingTiming();
  return await _measureVoidString(
      () => messagingTiming.basicMessageChannelBinaryPlatformVersion, name);
}

Future<double> _calcPigeon(String name) async {
  final MessagingTiming messagingTiming = MessagingTiming();
  final Api api = Api();
  return await _measureVoidString(
      () => messagingTiming.getPigeonPlatformVersion(api), name);
}

Future<double> _calcDart(String name) async {
  return await _measureVoidString(() {
    Completer<String> completer = Completer<String>();
    completer.complete("Just Dart");
    return completer.future;
  }, name);
}

Future<double> _calcMeasuringBaseline(String name) async {
  for (int i = 0; i < _testRunCount; ++i) {
    Measuring.startMeasuring("measuring baseline", i);
    Measuring.endMeasuring("measuring baseline", i);
  }
  Measuring.printLogs();
  return -1;
}
