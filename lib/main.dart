import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Log>> fetchLogs(http.Client client) async {
  final response = await client.get('http://192.168.43.71:8080/logs/a01');

  return compute(parseLogs, response.body);
}

List<Log> parseLogs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print( parsed);

  return parsed.map<Log>((json) => Log.fromJson(json)).toList();
}

class Log {
  final int timestamp;
  final double temperature;
  final double humidity;

  Log({this.timestamp, this.temperature, this.humidity});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      timestamp: json['ts'],
      temperature: json['t'],
      humidity: json['h'],
    );
  }
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
      body: FutureBuilder<List<Log>>(
        future: fetchLogs(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          print(snapshot.data);
          return snapshot.hasData
              ? LogList(logs: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class LogList extends StatelessWidget {
  final List<Log> logs;

  LogList({Key key, this.logs}) : super(key: key);

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
