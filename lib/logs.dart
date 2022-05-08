import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log Screen"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('log').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[i]['message']),
                    subtitle: Text(
                      (snapshot.data!.docs[i]['time'].toDate())
                          .toString()
                          .substring(0, 19),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
