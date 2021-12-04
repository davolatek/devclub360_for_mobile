import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:password_strength/password_strength.dart';

class MembersProfileScreen extends StatefulWidget {
  

  @override
  _MembersProfileScreenState createState() => _MembersProfileScreenState();
}

class _MembersProfileScreenState extends State<MembersProfileScreen> {

  String firstName = "", lastName = "", yearlyWorth = "", lastTransactionWorth ="";
  String companyName = "", companyWebsite ="", marketAreaInString = "", practiceAreaInString = ""; List<dynamic> marketArea = [], practiceArea = [];
  String membershipId = "", membershipStatus = "", profilePicsUrl ="", email= "", address ="", phone ="";
  bool showProfile = true, showEditPassword= false, showEditCompanyProfile = false;
  String dealToCloseinNextQuarter = "", linkedInProfile = "", yourAchievement = "", positionHeld = "";
  String representativeName = "", corpEmail = "", emailToChange = "";
  static TextEditingController controllerOldPassword = new TextEditingController();
  static TextEditingController controllerNewPassword = new TextEditingController();

  int _state = 0;

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new Text(
          "Changing Password....",
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
        );
        
      }

      return widget;
      
    }
  @override
  Widget build(BuildContext context) {
    
    setState(() {
      emailToChange = FirebaseAuth.instance.currentUser!.email.toString();
    });

    FirebaseFirestore.instance.collection("Members").doc(FirebaseAuth.instance.currentUser!.uid).get()
    .then((value){
      setState(() {
        firstName = value.get("firstName");
        lastName = value.get("lastName");
        yearlyWorth = value.get("YearlyWorth");
        lastTransactionWorth = value.get("lastTransactionWorth");
        profilePicsUrl = value.get("ProfilePicsUrl");
        email = value.get("EmailAddress");
        address = value.get("HomeAddress");
        phone = value.get("PhoneNumber");
        linkedInProfile = value.get("LinkedInProfile");
        dealToCloseinNextQuarter = value.get("DealToCloseInNextQuarter");
        yourAchievement = value.get("MembersAchievement");

      });
    });

    //Company Details
    FirebaseFirestore.instance.collection("MembersCompanyDetails").doc(FirebaseAuth.instance.currentUser!.uid).get()
    .then((value){
      Map creatorMAreaResponse = {"mArea": value["MarketArea"]};
      Map creatorPAreaResponse = {"pArea": value["PracticeArea"]};
      setState(() {
        marketArea = creatorMAreaResponse.values.toList();
        practiceArea = creatorPAreaResponse.values.toList();
        companyName = value.get("CompanyName");
        companyWebsite = value.get("CompanyWebsite");
        String formatMAList =  marketArea.toString().replaceAll("[", "");
        String reFormatMAList =  formatMAList.replaceAll("]", "");
        marketAreaInString = reFormatMAList;

        String formatPAList =  practiceArea.toString().replaceAll("[", "");
        String reFormatPAList =  formatPAList.replaceAll("]", "");
        practiceAreaInString = reFormatPAList;
        positionHeld = value.get("PositionHeld");
        representativeName = value.get("RepresentativeName");
        corpEmail = value.get("CorporateEmail");
        

      });
    });

    

    //Membership Profile
    FirebaseFirestore.instance.collection("MembershipDetails").doc(FirebaseAuth.instance.currentUser!.uid).get()
    .then((value){
      setState(() {
          membershipId = value.get("MemberShipId");
              if(membershipId.length == 1){
              membershipId = "00"+membershipId;
              }else if(membershipId.length == 2){
                membershipId = "0"+membershipId;
              }else{
                  membershipId = membershipId;
              }

              membershipStatus = value.get("MembershipStatus");
        });
        

        
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("MEMBERSHIP Profile", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
                Visibility(
                  visible: showProfile,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              
                              child: Text('Change Password', style: TextStyle(fontSize: 12),),
                              onPressed: () {
                                showDialog(
                                  
                                  context: context, 
                                  builder: (context)=>AlertDialog(
                                    scrollable: true,
                                    insetPadding: EdgeInsets.all(10),
                                    title: Text("Change Your Password"),
                                    content: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: TextFormField(
                                                controller: controllerOldPassword,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                labelText: "Your Current Password", 
                                                hintText: "Enter your current password",
                                                labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                                fillColor: Colors.lightBlueAccent,
                                                focusColor: Colors.lightBlueAccent,
                                                hoverColor: Colors.lightBlueAccent,
                                                focusedBorder:OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                                  
                                                ),
                                                ),
                                              
                                            
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: TextFormField(
                                                controller: controllerNewPassword,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                labelText: "Your New Password", 
                                                hintText: "Enter your new password",
                                                labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                                fillColor: Colors.lightBlueAccent,
                                                focusColor: Colors.lightBlueAccent,
                                                hoverColor: Colors.lightBlueAccent,
                                                focusedBorder:OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                                  
                                                ),
                                                ),
                                              
                                            
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            width: 350,
                                            child: ElevatedButton(
                                              onPressed: () async{
                                                var hasInternet = await InternetConnectionChecker().hasConnection;
                                                  double strength = estimatePasswordStrength(controllerNewPassword.text);
                                                  if (strength < 0.3) {
                                                    
                                                  } else if(strength > 0.3 && strength < 0.6){
                                                    
                                                  }
                                                if(hasInternet){
                                                    if(controllerOldPassword.text.isNotEmpty && controllerNewPassword.text.isNotEmpty){
                                                        if(controllerOldPassword.text == controllerNewPassword.text){
                                                            showDialog(context: context, builder: (context)=>AlertDialog(
                                                              title: Text("Invalid Input"),
                                                              content: Text("Current and New Password cannot be the same"),
                                                              actions: [
                                                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
                                                              ],
                                                            ));
                                                        }else if (strength < 0.6) {
                                                            showDialog(context: context, builder: (context)=>AlertDialog(
                                                              title: Text("Weak Password Supplied"),
                                                              content: Text("Use combination of Uppercase and lower case letters, numbers and symbols"),
                                                              actions: [
                                                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
                                                              ],
                                                            ));
                                                        }else{
                                                          setState(() {
                                                            _state = 1;
                                                          });
                                                           await ValidateDashboard().changePassword(controllerOldPassword, controllerNewPassword, emailToChange, context);
                                                          setState(() {
                                                            _state = 0;
                                                          });
                                                        }
                                                    }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 4)));
                                                      setState(() {
                                                            _state = 0;
                                                          });
                                                    }
                                                }else{
                                                  showSimpleNotification(
                                                    Text("No Internet Connection"),
                                                    background: Colors.red
                                                    );
                                                }
                                              },
                                              child: setUpButtonChild()
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                );
                              },
                          )
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CircleAvatar(radius: 80, backgroundColor: Colors.white, 
                              backgroundImage: profilePicsUrl.isEmpty? null :NetworkImage(profilePicsUrl),),
                        ),
                      ),
                       Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("First Name", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(firstName, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Last Name", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(lastName, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Email Address", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(email, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Phone Number", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(phone, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Home Address", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(address, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("LinkedIn Url", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(linkedInProfile, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Your Achievement", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(yourAchievement, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Yearly Turn Over", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("\$"+yearlyWorth, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Transaction Worth", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("\$"+lastTransactionWorth, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Company's Profile", style: TextStyle(fontWeight: FontWeight.bold)),)
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Company's Name", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(companyName, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Company's website", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(companyWebsite == ""? "No Company website": companyWebsite, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Your Market Area", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(marketAreaInString, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Your Practice Area", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(practiceAreaInString, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Position Held", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(positionHeld, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Representatve Name", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(representativeName, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Representative/Corporate Email", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(corpEmail, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                            ]
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("Membership Profile", style: TextStyle(fontWeight: FontWeight.bold)),)
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Your Membership ID", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(membershipId, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Your Membership Status", style: TextStyle(color: Colors.black)),
                                  ),),
                                  TableCell(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(membershipStatus, style: TextStyle(color: Colors.black)),
                                  ),),
                                ]
                              ),
                            ]
                          )
                        )
                    ],
                  )
                )
                  ]
                ),
              )
         
      )
    );
  }
}