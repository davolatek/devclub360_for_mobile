import 'dart:io';

import 'package:flutter/material.dart';

class AfterTransferAction extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info_rounded, size: 100, color: Colors.white,),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RichText(
                  text: TextSpan(text: "Thank You!", style: TextStyle(fontSize: 20))
                  ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: RichText(
                    text: TextSpan(text: "Your Account is awaiting Payment Confirmation.\n If this takes too long, Please send your proof of payment to\n payments@devclub360.com ", style: TextStyle(fontSize: 12))
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  onPressed: (){
                      exit(0);
                  }, 
                  icon: Icon(Icons.exit_to_app), 
                  label: Text("Exit")
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}