import 'dart:io';
import 'package:devclub360/screens/MemberSignIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({ Key? key }) : super(key: key);

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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20),
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:Container(
                        child: Image.asset("assets/images/verification.png", width: 500, height: 200),
                    )
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Your Email Address has not been verified", style: TextStyle(color: Colors.black,
                          fontSize: 17, fontWeight: FontWeight.bold
                        ),),
                      ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Card(
                      elevation: 15,
                          child: Align(
                          alignment: Alignment.center,
                          child: Text("Please click on the verification link sent to "+
                          FirebaseAuth.instance.currentUser!.email.toString(), style: TextStyle(color: Colors.black,
                            fontSize: 14, 
                          ),),
                        ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Didn't receive the Confirmation Link? ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        ),

                          ElevatedButton(
                            onPressed: () async{
                               await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                               ScaffoldMessenger.of(context).
                               showSnackBar(SnackBar(
                                 content: Text("A confirmation Link has been Sent to your email address. Confirm Your Email Address and login again",
                                style: TextStyle(fontStyle: FontStyle.italic),),
                                backgroundColor: Colors.green, duration: Duration(seconds: 5)));
                              
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberShipSignIn()));
                            },
                            child: 
                              Text("RESEND", style: TextStyle(
                                  color: Color(0xFF91D3B3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: FloatingActionButton.extended(
                                    onPressed: (){
                                      
                                      exit(0);

                                    }, 
                                    label: Text("Exit", style: TextStyle(color: Colors.white, fontSize: 13)),
                                    icon: Icon(Icons.exit_to_app),
                                    backgroundColor: Colors.blueAccent,
                                    ),
                                ),
                              ) 
                              
                               
                    ],
                  )
                  
                        
                        
              ],

            ),
          ),
        ),
      ),
    );
  }
}