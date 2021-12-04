import 'dart:io';
import 'package:flutter/material.dart';

class AccountAwaitingConfirmation extends StatelessWidget {
  

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
        body: Center(
          child: Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child:Container(
              child: Icon(Icons.info_rounded, size: 100, color: Colors.black,),
                      )
                      
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Align(
              alignment: Alignment.center,
              child: Text("Your Account is either Awaiting Approval, Payment Confirmation, or has been deactivated", style: TextStyle(color: Colors.black,
                fontSize: 17, fontWeight: FontWeight.bold
              ),),
            ),
                    ),
                   
                    
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}