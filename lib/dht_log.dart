
class DhtLog {
  final int timestamp;
  final double temperature;
  final double humidity;

  DhtLog({this.timestamp, this.temperature, this.humidity});

  factory DhtLog.fromJson(Map<String, dynamic> json) {
    return DhtLog(
      timestamp: json['ts'],
      temperature: json['t'],
      humidity: json['h'],
    );
  }
}