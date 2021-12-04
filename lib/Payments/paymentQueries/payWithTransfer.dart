
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/screens/AfterTransfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class MakePaymentWithTransferOption{

    //get Reference
    String _getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }

    return 'Devclub360${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> transferOption(int price, BuildContext context) async {
      User? user  = FirebaseAuth.instance.currentUser;
             if(user != null){
                FirebaseFirestore.instance.collection("MembershipPayments")
                .doc(user.uid)
                .set({
                  "uid": user.uid.toString(),
                  "AmountPaid": price,
                  "PaidStatus": "Awaiting Confirmation",
                  "Transaction_date": DateTime.now(),
                  "Transaction_Reference": _getReference()
                }).then((value) async{
                  //update accountStatus
                   FirebaseFirestore.instance.collection("Members").doc(user.uid).update({
                     "AccountStatus": "Active On Payment Confirmation"
                   }).then((value) async{
                      await showSimpleNotification(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                        Expanded(child: Text("Thank You. Your Payment will be confirmed shortly", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                      ],
                                                    ),
                                                    background: Colors.green,
                                                    duration: Duration(seconds: 5),
                                                    slideDismissDirection: DismissDirection.horizontal
                                                    );

                                                    //Send awaiting confirmation email to member
                                                    //Notify Admin

                                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AfterTransferAction()));
                                                    

                   }).catchError((error){
                      print(error);
                   });
                    
                }).catchError((error){
                    print(error);
                });
             }
  }
}