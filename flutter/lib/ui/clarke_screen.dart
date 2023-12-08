import 'package:flutter/material.dart';
import 'package:platform_channel_performance/aaclarke/ClarkeMeasuringWidget.dart';

class ClarkeScreen extends StatelessWidget {
  final bool ownMeasurement;

  const ClarkeScreen({super.key, required this.ownMeasurement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ownMeasurement
              ? 'Tests von Clarke mit meiner Messung'
              : 'Tests von Clarke'),
        ),
        body: ClarkeMeasuringWidget(ownMeasurement: ownMeasurement));
  }
}
