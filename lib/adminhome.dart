import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lmao/dustbin.dart';
import 'package:lmao/framework.dart';
import 'package:lmao/logs.dart';
import 'package:lmao/main.dart';
import 'package:lmao/monitor.dart';
import 'package:lmao/van.dart';
import 'sensor.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dim = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sensorconfigscreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                          width: 200,
                          height: dim,
                          image: AssetImage('images/sensor.png')),
                      Text('Sensor Configuration'),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => frameworkconfigscreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                          width: 200,
                          height: dim,
                          image: AssetImage('images/framework.png')),
                      Text('Framework Configuration'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => dustbinconfigscreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                        width: 200,
                        height: dim,
                        image: AssetImage('images/dustbin2.png'),
                      ),
                      Text('Dustbin Configuration'),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => vanconfigscreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                        width: 200,
                        height: dim,
                        image: AssetImage('images/van2.jfif'),
                      ),
                      Text('Van Configuration'),
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () async {
                    await FirebaseMessaging.instance
                        .subscribeToTopic('monitor');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonitorScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image(
                        width: 200,
                        height: dim,
                        image: AssetImage('images/start.jfif'),
                      ),
                      Text('Start Monitoring'),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () async {
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic('monitor');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LogScreen();
                    }));
                  },
                  child: Column(
                    children: [
                      Image(
                        width: 200,
                        height: dim,
                        image: AssetImage('images/Stop.png'),
                      ),
                      Text('Stop Monitoring'),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
