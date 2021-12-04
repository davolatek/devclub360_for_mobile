import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:devclub360/Constants/keys.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';


class MakeMembershipPayment{
  MakeMembershipPayment(this.ctx, this.price, this.email, this.firstName, this.accountStatus, this.couponIsUsed, this.coupon);

  BuildContext ctx;
  int price;
  String firstName;
  String accountStatus;
  String email;
  bool couponIsUsed;
  String coupon;
  FirebaseAuth auth = FirebaseAuth.instance;

  PaystackPlugin paystack = PaystackPlugin();

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

  
  
  //getUI

 PaymentCard _getCardUI(){
   return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  Future initializePlugin() async {
      await paystack.initialize(publicKey: ConstantKeys.PUBLIC_TEST_KEY);
  }

  //Verify Payment

  Future verifyPayment() async {
        try {
Map<String, String> headers = {                           
   'Content-Type': 'application/json',
   'Accept': 'application/json',
   'Authorization': 'Bearer '+ConstantKeys.SECRET_TEST_KEY};
http.Response response = await http.get(Uri.parse('https://api.paystack.co/transaction/verify/'+_getReference()), headers: headers);
     final Map body = await json.decode(response.body);
      if(body['data']['status'] == 'success'){
       print("Transaction successful");
      }else{
        //show error prompt}
        print("Transaction Failed");
    } 
    }catch (e) {
      print(e);
    }
  }

  //card charging

  chargeCardAndMakePayment() async {
    initializePlugin().then((value) async{
        Charge charge = Charge()
        ..amount = price* 100
        ..email = email
        ..currency= "NGN"
        ..reference= _getReference()
        ..card = _getCardUI();

        CheckoutResponse response = await paystack.checkout(
          ctx, 
          charge: charge, 
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: Image.asset("assets/images/dev_club_logo.png", width: 100, height: 100),
          
          );
            print(response);
          if(response.status== true){
            //  await verifyPayment();
             User? user  = auth.currentUser;
             if(user != null){
                FirebaseFirestore.instance.collection("MembershipPayments")
                .doc(user.uid)
                .set({
                  "uid": user.uid.toString(),
                  "AmountPaid": price,
                  "PaidStatus": "Completed",
                  "Transaction_date": DateTime.now(),
                  "Transaction_Reference": _getReference(),
                  "CouponIsUsed": couponIsUsed,
                  "CouponCode": coupon
                }).then((value) async{
                  //update accountStatus

                  
                   FirebaseFirestore.instance.collection("Members").doc(user.uid).update({
                     "AccountStatus": accountStatus!= "Verified" && accountStatus !="In-Processing" ? "Active": accountStatus == "Verified" ?  "Verified": "In-Processing"
                   }).then((value) async{
                      String message = "Welcome to the DEVCLUB360.\n\n First and foremost, we want to thank you for your investment. Without your loyalty and support, we would not be able to continuously provide our network with valuable benefits and actively develop the world of real estate. Put simply, you make what we do possible.\n\nWe want to see you benefit from your membership. If not, let us fix that right away! Call or email the DEVCLUB360 to see how we may better meet your needs.\n\nBeyond the sweet deals available on the DEVCLUB360, you will have your own personal board of directors, meet new high net worth friends through our several events like the Quarterly Board Room Meetings, Boat Cruises, and yearly Portfolio Defense Meetings.\n\nIf, like most of our members, you are satisfied with your membership, consider introducing your highly placed friends to the DEVCLUB360.\n\nKind regards\nONAIFO UWA\nFounder/CEO";
                     await ValidateDashboard().sendEmail(
                       name: firstName,
                       email: email,
                       subject: "Devclub Membership License Payment Successful",
                       message: message
                     );
                      String adminMessage = "This is to notify you that a member with email '$email' and name '$firstName' has bbtained a Membership License";
                     await ValidateDashboard().sendEmail(
                       name: "Devclub360",
                       email: "payments@devclub360.com",
                       message: adminMessage,
                       subject: "New Membership License Payment Successful"
                     );
                      showSimpleNotification(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                        Expanded(child: Text("Your Account has been successfully Licensed", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                      ],
                                                    ),
                                                    background: Colors.green,
                                                    duration: Duration(seconds: 5),
                                                    slideDismissDirection: DismissDirection.horizontal
                                                    );

                                                    //Send confirmation email to member
                                                    Navigator.push(ctx, MaterialPageRoute(builder: (ctx)=>MemberDashBoard()));
                   }).catchError((error){

                   });
                    
                }).catchError((error){
                    print(error);
                });
             }
             
          }else{
            print("Transaction Failed");
          }
    })
    .catchError((error){
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("An error has been encountered while trying to to pay $error",
                      style: TextStyle(fontStyle: FontStyle.italic),),backgroundColor: Colors.red, duration: Duration(seconds: 5)));
    });
  }
}