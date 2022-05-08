import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class vanconfigscreen extends StatefulWidget {
  const vanconfigscreen({Key? key}) : super(key: key);

  @override
  State<vanconfigscreen> createState() => _vanconfigscreenState();
}

class _vanconfigscreenState extends State<vanconfigscreen> {
  int vanid = 0;
  String emailid = "", name = "";
  final fieldText = TextEditingController();
  final bonjourtext = TextEditingController();
  final holatext = TextEditingController();
  void clearText() {
    fieldText.clear();
    bonjourtext.clear();
    holatext.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Van Configuration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 150,
              height: 150,
              image: AssetImage('images/van2.jfif'),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Van Configuration',
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
                    'Email ID:       ',
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          emailid = value;
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
                    'Driver Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: bonjourtext,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Van ID:           ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('vanid')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        vanid = snapshot.data!.docs[0]['id'];
                        return ListTile(
                          title: Text(
                            snapshot.data!.docs[0]['id'].toString(),
                          ),
                        );
                      },
                    ),
                  ),
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
                      emailid = "";
                      name = "";
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
                    await FirebaseFirestore.instance.collection('vans').add({
                      'email': emailid,
                      'name': name,
                      'id': vanid,
                    });
                    await FirebaseFirestore.instance
                        .collection('vanid')
                        .doc('idd')
                        .update({
                      'id': vanid + 1,
                    });
                    clearText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal,
                        behavior: SnackBarBehavior.floating,
                        content: Text("Successfully Registered"),
                      ),
                    );
                  },
                  child: Text('Register'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
