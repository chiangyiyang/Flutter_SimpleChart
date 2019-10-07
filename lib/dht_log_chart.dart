import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dht_log.dart';

class DhtLogChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DhtLogChart(this.seriesList, {this.animate});

  factory DhtLogChart.withRandomData() {
    return new DhtLogChart(_createRandomData());
  }

  factory DhtLogChart.withData(List<DhtLog> data) {
    return DhtLogChart(<charts.Series<DhtLog, num>>[
      new charts.Series<DhtLog, int>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DhtLog dhtLog, _) => dhtLog.timestamp,
        measureFn: (DhtLog dhtLog, _) => dhtLog.temperature,
        data: data,
      ),
      new charts.Series<DhtLog, int>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (DhtLog dhtLog, _) => dhtLog.timestamp,
        measureFn: (DhtLog dhtLog, _) => dhtLog.humidity,
        data: data,
      ),
    ]);
  }


  static List<charts.Series<DhtLog, num>> _createRandomData() {
    final random = new Random();

    final myFakeDhtLogData = <DhtLog>[];

    for (var i = 0; i < 100; i++) {
      myFakeDhtLogData.add(DhtLog(
          timestamp: i,
          temperature: 25 + random.nextDouble() * 10,
          humidity: 90 + random.nextDouble() * 10));
    }

    return [
      new charts.Series<DhtLog, int>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DhtLog dhtLog, _) => dhtLog.timestamp,
        measureFn: (DhtLog dhtLog, _) => dhtLog.temperature,
        data: myFakeDhtLogData,
      ),
      new charts.Series<DhtLog, int>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (DhtLog dhtLog, _) => dhtLog.timestamp,
        measureFn: (DhtLog dhtLog, _) => dhtLog.humidity,
        data: myFakeDhtLogData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList, animate: animate, behaviors: [
      new charts.RangeAnnotation([
        new charts.LineAnnotationSegment(
            20, charts.RangeAnnotationAxisType.measure,
            startLabel: 'Temperature',
            endLabel: '	°C',
            color: charts.MaterialPalette.gray.shade300),
        new charts.LineAnnotationSegment(
            80, charts.RangeAnnotationAxisType.measure,
            startLabel: 'Humidity',
            endLabel: '%',
            color: charts.MaterialPalette.gray.shade400),
      ]),
    ]);
  }
}
