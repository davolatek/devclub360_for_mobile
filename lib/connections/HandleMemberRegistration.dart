import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';


class HandleNewMemberRegistration {
  final cloudinary = CloudinaryPublic('developerdavid', 'mwxqi5y2', cache: false);

  FirebaseAuth auth = FirebaseAuth.instance;
  int length = 0;
  String memberId = "";
  Future<void> signUpNewMembers(String email, String password, String memberCategory, String yearlyTransaction,
  String lastTransaction,String memberAchievement, String firstName, String lastName, String phoneNumber, String address, String linkedIn, String imgPath, String dealToClose, String achievementHope,
  String companyName, String companyWebsite, List marketArea, List practiceArea, 
  String secretaryName, String corporateEmail, String nin, String controllerPositionHeld, String license, String voters,
  String cac, String tin, BuildContext context) async{

      try{
          FirebaseAuth auth = FirebaseAuth.instance;
          UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);

          if(user.user!.uid.isNotEmpty){
               CloudinaryResponse response = await cloudinary.uploadFile(
                CloudinaryFile.fromFile(imgPath, resourceType: CloudinaryResourceType.Image));

                if(response.secureUrl.isNotEmpty){
                FirebaseFirestore.instance.collection("Members").doc(user.user!.uid.toString())
                  .set({
                    "MemberCategory": memberCategory,
                    "YearlyWorth": yearlyTransaction,
                    "MembersAchievement": memberAchievement,
                    "uid": user.user!.uid,
                    "lastTransactionWorth": lastTransaction,
                    "firstName": firstName,
                    "lastName": lastName,
                    "EmailAddress": email,
                    "PhoneNumber": phoneNumber,
                    "HomeAddress": address,
                    "LinkedInProfile": linkedIn,
                    "ProfilePicsUrl": response.secureUrl,
                    "DealToCloseInNextQuarter": dealToClose,
                    "achievementHopeOnDevClub": achievementHope,
                    "AccountStatus": "Pending",
                    "NIN": nin,
                    "DriversLicense": license,
                    "VIN": voters,
                    "CAC": cac,
                    "TIN": tin,
                    "CreatedAt": DateTime.now()

                  }).then((value){
                      createCompanyProfile(companyName, companyWebsite, firstName, controllerPositionHeld ,marketArea, practiceArea, secretaryName, corporateEmail, email, context);
                  }).catchError((error){
                    print(error);
                  });
                }

          }
      }on FirebaseAuthException catch(e){

      print(e.toString());
      
      showSimpleNotification(Text("Email has already been taken"),background: Colors.red);
         
    }

  }


  Future<void> createCompanyProfile(String companyName, String companyWebsite, String name, String positionHeld, List marketArea, List practiceArea, 
  String secretaryName, String corporateEmail, String email, BuildContext context) async {
      if(auth.currentUser!.uid.isNotEmpty){
         FirebaseFirestore.instance.collection("MembersCompanyDetails").doc(auth.currentUser!.uid)
          .set({
            "uid": auth.currentUser!.uid,
            "CompanyName": companyName,
            "CompanyWebsite": companyWebsite,
            "MarketArea": FieldValue.arrayUnion(marketArea),
            "PracticeArea": FieldValue.arrayUnion(practiceArea),
            "PositionHeld": positionHeld,
            "RepresentativeName": secretaryName,
            "CorporateEmail": corporateEmail,
            "CreatedAt": DateTime.now()
          }).then((value){
              createMembershipProfile(email, name, context);
          }).catchError((error){
            print(error);
          });
      }
  }

  Future<void> createMembershipProfile(String email, String name, BuildContext context) async {
       final snapshot = await FirebaseFirestore.instance.collection("MembershipDetails").get();
       
       

       if(snapshot.docs.length==0){
                     length = 1;
                     memberId = length.toString();
                     
          }else{
              length = snapshot.docs.length + 1;
              memberId = length.toString();
                  
          }
     FirebaseFirestore.instance.collection("MembershipDetails")
                        .doc(auth.currentUser!.uid)
                        .set({
                          "uid": auth.currentUser!.uid,
                          "MemberShipId": memberId,
                          "MemberShipDateAndTime": DateTime.now(),
                          "MembershipStatus": "Active"
                        }).then((value) {
                          //Send Email of awaiting verification version...Am still working on this
                          auth.currentUser!.sendEmailVerification();

                          String url ='https://docs.google.com/forms/d/e/1FAIpQLSeHgYgJvwxYjx381xnIA5xHbkQYOBRjTOIxDB0bcAmzhTow9Q/viewform?usp=sf_link';
                                      String message = "This message is to confirm your membership application into the DEVCLUB360 Network.\n\nIf we approve your membership application, you will receive another notification email before you gain full access to the DEVCLUB360 mobile app and enjoy 30 days free trial accessing deals connection.\n\nNow that you have submitted your membership application, we need to have your expression of interest as a final stage required for your approval.\n\nClick on the link below to submit your expression of interest:\n\n"+url+"\n\nThank You!\n\n\n\nDEVCLUB360 Team.";
                                      String subject = "Successful Devclub360 Membership Registration";
                                ValidateDashboard().sendEmail(
                                  name: name, email: email, subject: subject, message: message
                                );
                        String adminMessage ="A new member has registered with '$email' on the platform and awaiting approval.";
                                ValidateDashboard().sendEmail(
                                  name: "Devclub360",
                                  email: "operations@devclub360.com",
                                  subject: "New Successful Member Registration",
                                  message: adminMessage
                                );
                          showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Expanded(child: Text("Registration Successful. Confirmation Link has been sent", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                                      
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberShipSignIn()));
                        }).catchError((error){
                          print(error);
                        });
  }
}