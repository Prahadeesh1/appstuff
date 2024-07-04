import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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

  @override
  void initState() {
    super.initState();
    fetchData();
    
  }

  fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/sensor_data'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        value = data[widget.sensorType].toString();
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
      body: Center(
        child: Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
