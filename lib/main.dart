import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dht_log.dart';
import 'dht_log_chart.dart';

Future<List<DhtLog>> fetchLogs(http.Client client) async {
  final response = await client.get('http://192.168.43.71:8080/logs/a01');

  return compute(parseLogs, response.body);
}

List<DhtLog> parseLogs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print( parsed);

  return parsed.map<DhtLog>((json) => DhtLog.fromJson(json)).toList();
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<DhtLog>>(
        future: fetchLogs(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          print(snapshot.data);
          // return snapshot.hasData
          //     ? DhtLogList(logs: snapshot.data)
          //     : Center(child: CircularProgressIndicator());
           return snapshot.hasData
              ? DhtLogChart.withData(snapshot.data)
              // ? DhtLogChart.withRandomData()
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DhtLogList extends StatelessWidget {
  final List<DhtLog> logs;

  DhtLogList({Key key, this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: logs.length,
        itemBuilder: (BuildContext context, int index) {
          print('Running');
          return Container(
            height: 80,
            padding: EdgeInsets.all(8),
            color: Colors.green,
            child: Center(child: Text('Timestamp: ${logs[index].timestamp} \n'+
                                      'Temperature: ${logs[index].temperature} \n'+
                                      'Humidity: ${logs[index].humidity}')),
          );
        });
  }
}
