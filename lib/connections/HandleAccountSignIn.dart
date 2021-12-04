
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:devclub360/screens/TrialPeriodPage.dart';
import 'package:devclub360/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class HandleSignIn{

  FirebaseAuth auth =  FirebaseAuth.instance;
  String accountStatus = "";
  

     

  Future<void> HandleMemberSignIn(String email, String password, BuildContext context) async {
    try{
      
    final User? user = (await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).user;



          if(user != null){
            if(user.emailVerified){

              await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
                .then((DocumentSnapshot docs) async{

                  if(docs.exists){
                      accountStatus = docs.get("AccountStatus");
                      if(accountStatus == "Pending"){
                showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Text("Account Awaiting Approval", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
            }else if(accountStatus== "Suspended" || accountStatus == "Terminated"){
              showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Text("Account Currently deactivated", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      background: Colors.red,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
            }else if(accountStatus== "Active On Payment Confirmation"){
              showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Expanded(child: Text("Account Awaiting Payment Confirmation", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
            }else{
              if(await ValidateDashboard().getNumberOfPeriod() > 30 && accountStatus=="Active On Trial"){
                      //Navigate to trial period expired
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TrialPeriod()));
                }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                }
            }
                  }else{
                        showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.info, size: 20, color: Colors.white,),
                                          Text("No Profile found for this Member", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      background: Colors.redAccent,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                  }
                });
              
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotVerified()));
            }
          }
    }on FirebaseAuthException catch(e){
        print(e);
        if(e.code=="user-not-found"){
          password = "";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Email or Password"),backgroundColor: Colors.red, duration: Duration(seconds: 4)));
        }else if(e.code=="wrong-password"){
          
          password = "";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Email or Password"),backgroundColor: Colors.red, duration: Duration(seconds: 4)));
        }
      }
    
  }

}