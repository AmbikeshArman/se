import 'dart:math';

import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  double garbage;
  Detail({required this.garbage});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  double moisture = Random().nextDouble();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Garbage Value: " + widget.garbage.toStringAsFixed(1)),
              ),
              LinearProgressIndicator(
                value: widget.garbage / 100,
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Moisture Level"),
              ),
              LinearProgressIndicator(
                value: moisture,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
