import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Analyst extends StatefulWidget {
  final String uid;
  Analyst({Key key, this.uid}) : super(key: key);

  @override
  _AnalystState createState() => _AnalystState(this.uid);
}

class _AnalystState extends State<Analyst> {
  String date = DateFormat.yMd().format(DateTime.now());
  num _drank = 0;
  List _drinkList = [];

  final String uid;
  _AnalystState(this.uid);

  final firebaseDoc = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    // Create if not exist
    firebaseDoc.doc(uid).set({date: []}, SetOptions(merge : true));

    // Listening Data
    firebaseDoc
      .doc(uid)
      .snapshots()
      .listen((result) {
          print(result.data());
          setState(() { 
              _drinkList = result.data()[date];
              _drank = result.data()[date].fold(0, (previous, current) => previous + current); 
            });
      });
  }

  void _drinkingWater(num water) {
    _drinkList.add(water);
    firebaseDoc.doc(uid).set({ date: _drinkList })
      .then((value) => print("Water Added"))
      .catchError((error) => print("Failed to inicrease Clicked: $error"));
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(10, 150, 10, 20),
                child: Text(
                        "${_drank.toString()} mL",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.black87
                          ),
                      ),
              ),
              FloatingActionButton(
                onPressed: () => _drinkingWater(10),
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ), 
          ],
      ),),
      );
  }
}