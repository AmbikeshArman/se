import 'package:flutter/material.dart';
import 'package:lmao/userhome.dart';
import 'functions.dart';
import 'adminhome.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "", pass = "", name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: InputDecoration(hintText: 'Email'),
          ),
          TextField(
            onChanged: (value) {
              pass = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              Functions func = Functions();
              String res = await func.register(email, pass);
              if (res == 'true') {
                String ans = await func.admin(email);
                if (ans == 'Admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userHomePage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res),
                  ),
                );
              }
            },
            child: Text("Sign In"),
          ),
        ],
      ),
    );
  }
}
