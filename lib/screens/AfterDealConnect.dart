import 'dart:io';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:flutter/material.dart';

class AfterDealConnectScreen extends StatelessWidget {
  

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
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:Container(
                        child: Center(child: Icon(Icons.info_rounded, size: 100, color: Colors.black,)),
                    )
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text("Your Project has Successfully been submitted for review\n You will be contacted if Review has been completed...\n\n Keep Using Devclub360", style: TextStyle(color: Colors.black,
                            fontSize: 17, fontWeight: FontWeight.bold
                          ),),
                        ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: 323.8,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MemberDashBoard()));
                          },
                          child: Text("Proceed To Dashboard",style: TextStyle(color: Colors.white,
                              fontSize: 17)),
                        ),
                      )
                    )
                  
                    ],
                  ),
        ),
      ),
    );
  }
}