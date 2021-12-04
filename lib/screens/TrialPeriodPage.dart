import 'dart:io';

import 'package:devclub360/screens/PaymentPage.dart';
import 'package:flutter/material.dart';

class TrialPeriod extends StatefulWidget {
  const TrialPeriod({ Key? key }) : super(key: key);

  @override
  _TrialPeriodState createState() => _TrialPeriodState();
}

class _TrialPeriodState extends State<TrialPeriod> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
                actions: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: (){
                      Navigator.pop(c, true);
                      exit(0);
                    },
                  ),
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )
              
            );
            return false;
          },
      child: Scaffold(
        body: Container(
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info_rounded, size: 100, color: Colors.white,),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: RichText(
                    text: TextSpan(text: "Your Trial Period has expired!", style: TextStyle(fontSize: 20))
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: RichText(
                    text: TextSpan(text: "To Continue using Devclub360, you need to purchase a membership license", style: TextStyle(fontSize: 12))
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: ElevatedButton.icon(
                    onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPaymentPage()));
                    }, 
                    icon: Icon(Icons.card_membership), 
                    label: Text("Purchase License")
                    )
                ),
    
              ],
            ),
          ),
        ),
      ),
    );
  }
}