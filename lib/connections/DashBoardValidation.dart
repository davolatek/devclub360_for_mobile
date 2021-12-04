import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/screens/MemberSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;


class ValidateDashboard {

  FirebaseAuth auth = FirebaseAuth.instance;
  String memberFirstName = "", memberLastName = "", url ="";
  String organization = "";
  
Future getNumberOfPeriod() async{

  var days;
  
    //Fetch date of registration from members document

  await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
    .then((DocumentSnapshot docs) async {
       Timestamp creationDate = docs.get("CreatedAt");
       DateTime convertedCreatedDate = DateTime.fromMicrosecondsSinceEpoch(creationDate.microsecondsSinceEpoch);
       final presentDay = DateTime.now();

      days = await presentDay.difference(convertedCreatedDate).inDays;
       
    }).catchError((error){
      print(error);
    });

  print(days);
    return days;
  }

 getMembersName(String id) {
   FirebaseFirestore.instance.collection("Members").doc(id).get()
    .then((DocumentSnapshot docs){
        memberFirstName = docs.get("firstName");
        memberLastName = docs.get("lastName");

    }).catchError((error){
      print(error);
    });

      print(memberFirstName+" "+memberLastName);
    return memberFirstName+" "+memberLastName;
  }

  getMembersPics(String id){
    FirebaseFirestore.instance.collection("Members").doc(id).get()
    .then((DocumentSnapshot docs){
        url = docs.get("ProfilePicsUrl");
        

    }).catchError((error){
      print(error);
    });

    return url;
  }
  

  doQuickPost(TextEditingController quickPost) async {

      if(quickPost.text.isEmpty){
          showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error_outline_rounded, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Post Cannot be empty", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.redAccent
                );
      }else{
        await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
        .then((docs){
            if(docs.exists){
              memberFirstName = docs.get("firstName");
              memberLastName = docs.get("lastName");
              url = docs.get("ProfilePicsUrl");
            }
        });
        await FirebaseFirestore.instance.collection("QuickPosts").add({
          "Posts": quickPost.text,
          "PostedByID": auth.currentUser!.uid.toString(),
          "PostedByName": memberFirstName + " "+memberLastName,
          "PostedByProfilePics": url,
          "createdAt": DateTime.now()
        }).then((value) async{
          await FirebaseFirestore.instance.collection("Feeds").add({
            "FeedStatus": "Open",
            "FeedType": "Quick Post",
            "FeedCreatorName": memberFirstName + " "+memberLastName,
            "FeedCreatorPics": url,
            "FeedTitle": "Added a quick post",
            "QuickPostId": value.id



          }).then((value){
              showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.post_add, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Post Successfully added", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.green
                );
                quickPost.clear();
          });
            
           
        }).catchError((error){
            showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, size: 20, color: Colors.white,),
                                              Expanded(child: Text("An error occured while saving your quick post", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.red
                );
                
        });
      }
    
  }


  // Performing comments

  doQuickComments(TextEditingController quickComments, String postID) async {

      if(quickComments.text.isEmpty){
          showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error_outline_rounded, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Your Comment Cannot be empty", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.redAccent
                );
      }else{
        await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
        .then((docs){
            if(docs.exists){
              memberFirstName = docs.get("firstName");
              memberLastName = docs.get("lastName");
              url = docs.get("ProfilePicsUrl");
            }
        });
        await FirebaseFirestore.instance.collection("QuickPosts").doc(postID).collection("Comments").add({
          "CommentorsID": FirebaseAuth.instance.currentUser!.uid,
          "CommentorsName": memberFirstName +" "+memberLastName,
          "Comments": quickComments.text,
          "QuickPostId": postID,
          "CommentDate": DateTime.now()

        }).then((value) async{

          await FirebaseFirestore.instance.collection("Feeds").add({
            "FeedStatus": "Open",
            "FeedType": "Quick Post Comment",
            "FeedCreatorName": memberFirstName + " "+memberLastName,
            "FeedCreatorPics": url,
            "FeedTitle": "Commented on a quick Post",
            "QuickPostId": postID

          });
            showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.post_add, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Your Comment Successfully added", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.green
                );
                quickComments.clear();
        }).catchError((error){
          showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, size: 20, color: Colors.white,),
                                              Expanded(child: Text("An error occured while saving your comment", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.red
                );
        });
      }
    
  }

  // Performing Interests

  doShowInterest(TextEditingController interests, String postID, BuildContext context) async {

      if(interests.text.isEmpty){
          showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error_outline_rounded, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Your Interest Offer is required", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.redAccent
                );
      }else{
        await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
        .then((docs){
            if(docs.exists){
              memberFirstName = docs.get("firstName");
              memberLastName = docs.get("lastName");
              url = docs.get("ProfilePicsUrl");
            }
        });
        await FirebaseFirestore.instance.collection("QuickPostInterests").doc(auth.currentUser!.uid)
        .get().then((value){
          if(value.exists){
            showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.post_add, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Interest has already been been added", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green
                        );
          }else{
            FirebaseFirestore.instance.collection("QuickPostInterests").doc(auth.currentUser!.uid).set({
                  "MemberID": FirebaseAuth.instance.currentUser!.uid,
                  "MembersName": memberFirstName +" "+memberLastName,
                  "InterestOffer": interests.text,
                  "QuickPostId": postID,
                  "CreatedDate": DateTime.now()

                }).then((value) async{
                    showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.post_add, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Interest has been Successfully added", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green
                        );
                        
                        interests.clear();
                }).catchError((error){
                  showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, size: 20, color: Colors.white,),
                                              Expanded(child: Text("An error occured while saving your Interest", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.red
                );
                });
          }
        });
      }
    
  }


  doSendMessages(TextEditingController subject, TextEditingController message) async{

    await FirebaseFirestore.instance.collection("MembersSentMessages").add({
      "MessageSubject": subject.text,
      "MessageContent": message.text,
      "MessageSender": auth.currentUser!.uid.toString(),
      "MessageReceiver": "DevClub Admin",
      "MessageCreatedAt": DateTime.now()
    }).then((value) async{
        await FirebaseFirestore.instance.collection("AdminInbox").doc(value.id).set({
          "MessageSubject": subject.text,
          "MessageContent": message.text,
          "MessageSenderID": auth.currentUser!.uid.toString(),
          "MessageReceiver": "DevClub Admin",
          "MessageCreatedAt": DateTime.now()
        }).then((value){
            showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.post_add, size: 20, color: Colors.white,),
                                              Text("Message Successfully delivered", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          background: Colors.green
                );
                subject.clear();
                message.clear();
        }).catchError((error){

        });
    }).catchError((error){

    });
  }

  Future<void> doSubmitSupportRequest(String department, TextEditingController subject, TextEditingController message) async {
    await FirebaseFirestore.instance.collection("SupportRequests").add({
      "MembersId": FirebaseAuth.instance.currentUser!.uid,
      "Department": department,
      "Subject": subject.text,
      "Message": message.text,
      "Status": "Pending",
      "Responses": "",
      "CreatedAt": DateTime.now(),
      "RespondedAt": ""
    }).then((value) async{
      await sendEmail(email: 'operations@devclub360.com', name: "Devclub Admin", subject: subject.text,message: 'New Support Request for $department'+ message.text);
      //notify members too
      showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.support, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Ticket suceesfully submitted", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.green
                );
                department = "";
                subject.clear();
                message.clear();
    }).catchError((error){
      print(error);
    });
    
  }

  doQuerySubmission(TextEditingController query, String dealId){
    FirebaseFirestore.instance.collection("DealShares").doc(dealId).collection("DealQueries").doc(FirebaseAuth.instance.currentUser!.uid)
    .get().then((value){
      if(value.exists){
        showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.query_builder, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Your Query has already been received", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.green
                );
      }else{
        FirebaseFirestore.instance.collection("DealShares").doc(dealId).collection("DealQueries").doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          "DealId": dealId,
          "QueryContent": query.text,
          "QuerySubmitter": FirebaseAuth.instance.currentUser!.uid,
          "QuerySubmittedAt": DateTime.now(),
          "QueryStatus": "0",
          "Response": ""
        }).then((value){
          showSimpleNotification(
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.query_builder, size: 20, color: Colors.white,),
                                              Expanded(child: Text("Your Query successfully submitted", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                          background: Colors.green
                );
                query.clear();
        }).catchError((error){
          print(error);
        });
      }
    });
  }

 
      Future sendEmail({
        required String name,
        required String email,
        required String subject,
        required String message
        
      }) async{
          final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
          
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json'
            },
            body: json.encode({
              'service_id': 'service_kobfvv5',
              'template_id': 'template_uj06c0l',
              'user_id': 'user_YuuEJBmFFE0E8iNcfq6cL',
              'template_params': {
                'message_subject': subject,
                'to_name': name,
                'message': message,
                'to_email': email,

              }
            })
            
          );

          print(response.body);
      }
  
  changePassword(TextEditingController currentPassword, TextEditingController newPassword, String email, BuildContext context) async {
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: email, password: currentPassword.text);

      user!.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword.text).then((_) async{
          showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.approval, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Password has been changed successfully", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );

                                            currentPassword.clear();
                                            newPassword.clear();
                                            await auth.signOut();

                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberShipSignIn()));
          
        }).catchError((error) {
          //Error, show something
          if(error.toString().contains("The password is invalid or the user does not have a password")){
          showDialog(context: context, builder: (context)=>AlertDialog(
                                                              title: Text("Incorrect Password Details"),
                                                              content: Text("You supplied an incorrect urrent Password"),
                                                              actions: [
                                                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
                                                              ],
                                                            ));
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error has occured while changing your password"),backgroundColor: Colors.red, duration: Duration(seconds: 5)));
        }
        });
      }).catchError((err) {
        if(err.toString().contains("The password is invalid or the user does not have a password")){
          showDialog(context: context, builder: (context)=>AlertDialog(
                                                              title: Text("Incorrect Password Details"),
                                                              content: Text("You supplied an incorrect Password"),
                                                              actions: [
                                                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
                                                              ],
                                                            ));
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error has occured while changing your password"),backgroundColor: Colors.red, duration: Duration(seconds: 5)));
        }
        
      
      });}
}