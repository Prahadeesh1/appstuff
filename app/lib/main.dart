import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Raleway',
        scaffoldBackgroundColor: const Color(0xFFE0F7E9),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'a' && password == 'a') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Login'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Ambient Temperature'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage('temperature')),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('PH level'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage('ph_level')),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Relative Humidity'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage('humidity')),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Light Intensity'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage('light_intensity')),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('EC level'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SensorPage('ec_level')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SensorPage extends StatefulWidget {
  final String sensorType;
  const SensorPage(this.sensorType, {super.key});

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  String value = 'Loading...';
  List<ChartData> chartData = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      borderColor: Colors.red,
      borderWidth: 5,
    );
    fetchData();
  }

    fetchData() async {
      final response = await http.get(Uri.parse('http://192.168.18.136:5000/sensor_data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          value = data[widget.sensorType].toString();
          if (widget.sensorType == 'temperature') {
            chartData.add(ChartData(DateTime.now(), data['temperature'].toDouble()));
          }
        });
      } else {
        setState(() {
          value = 'Failed to load data';
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sensorType.replaceAll('_', ' ').toUpperCase()),
      ),
      body: widget.sensorType == 'temperature' 
      ? Column(
        children: [
          SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: const DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
              interval: 60,
              title: AxisTitle(
                text: 'Time',
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
              )),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(
                text: 'Temperature',
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
              )),
              title: const ChartTitle(text: 'Ambient Temperature of the Garden'),
              legend: const Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries>[
                LineSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.temp,
                  name: 'Temperature',
                  dataLabelSettings: const DataLabelSettings(isVisible: true)
                )
              ]
            ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Last Data: \n ${DateFormat('dd/MMM/yyyy HHmm').format(chartData.last.time)} \n ${chartData.last.temp}°C',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ])
      : Center(
        child: Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ChartData {
  ChartData(this.time, this.temp);
  final DateTime time;
  final double temp;
}
