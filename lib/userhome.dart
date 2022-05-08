import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lmao/dustbin.dart';
import 'package:lmao/framework.dart';
import 'package:lmao/logs.dart';
import 'package:lmao/monitor.dart';
import 'package:lmao/van.dart';
import 'main.dart';
import 'sensor.dart';

class userHomePage extends StatefulWidget {
  const userHomePage({Key? key}) : super(key: key);

  @override
  State<userHomePage> createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {
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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('us')
                .doc('uss')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              ultrasonic = snapshot.data!['uss'].toDouble();
              return Card(
                child: ListTile(
                  title:
                      Text("Current UltraSonic Threshold Value: $ultrasonic"),
                ),
              );
            },
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
                    ultrasonic = 50;
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
