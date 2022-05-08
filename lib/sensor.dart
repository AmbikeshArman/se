import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

double moisture = 0, ultrasonic = 0;

class sensorconfigscreen extends StatefulWidget {
  const sensorconfigscreen({Key? key}) : super(key: key);

  @override
  State<sensorconfigscreen> createState() => _sensorconfigscreenState();
}

class _sensorconfigscreenState extends State<sensorconfigscreen> {
  final fieldText = TextEditingController();
  final bonjourText = TextEditingController();
  void clearText() {
    fieldText.clear();
    bonjourText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Configuration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                width: 100,
                height: 100,
                image: AssetImage('images/sensor.png'),
              ),
            ),
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
                    title: Text("Current UltraSonic Value: $ultrasonic"),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Sensor Configuration',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Moisture Sensor Threshold:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: fieldText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != "") moisture = double.parse(value);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Ultrasonic Sensor Threshold:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: bonjourText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != "") ultrasonic = double.parse(value);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    minimumSize: Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      clearText();
                      moisture = 0;
                      ultrasonic = 0;
                    });
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    minimumSize: Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal,
                        behavior: SnackBarBehavior.floating,
                        content: Text("Successfully saved changes"),
                      ),
                    );
                    await FirebaseFirestore.instance
                        .collection('us')
                        .doc('uss')
                        .update({'uss': ultrasonic.toInt()});
                  },
                  child: Text('Save changes'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
