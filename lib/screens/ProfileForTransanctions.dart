import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowMembersProfileForTrans extends StatefulWidget {
  final DocumentSnapshot transactions;

  ShowMembersProfileForTrans({required this.transactions});

  @override
  _ShowMembersProfileForTransState createState() => _ShowMembersProfileForTransState();
}

class _ShowMembersProfileForTransState extends State<ShowMembersProfileForTrans> {

  String membersId = "";
  bool showDealDetails = true, showCreatorProfile = false, showApplication = false;
  String firstName = "", lastName = "", yearlyWorth = "", lastTransactionWorth ="", accountStatus = "";
  String companyName = "", companyWebsite ="", marketAreaInString = "", practiceAreaInString = ""; List<dynamic> marketArea = [], practiceArea = [];
  String membershipId = "", membershipStatus = "", profilePicsUrl ="";
  String achievement = "", positionHeld = "";
  String transactionId = "";
  @override
  Widget build(BuildContext context) {
    
    setState(() {
      membersId = widget.transactions.id;
    });

    

   Widget creatorsProfile(){

    FirebaseFirestore.instance.collection("Members").doc(membersId).get()
    .then((value){
      setState(() {
        firstName = value.get("firstName");
        lastName = value.get("lastName");
        yearlyWorth = value.get("YearlyWorth");
        lastTransactionWorth = value.get("lastTransactionWorth");
        accountStatus= value.get("AccountStatus");
        achievement = value.get("MembersAchievement");
        profilePicsUrl = value.get("ProfilePicsUrl");

      });
    });

    FirebaseFirestore.instance.collection("MembersCompanyDetails").doc(membersId).get()
    .then((value){
      Map creatorMAreaResponse = {"mArea": value["MarketArea"]};
      Map creatorPAreaResponse = {"pArea": value["PracticeArea"]};
      setState(() {
        if(mounted){
          marketArea = creatorMAreaResponse.values.toList();
          practiceArea = creatorPAreaResponse.values.toList();
          positionHeld = value.get("PositionHeld");
          String formatMAList =  marketArea.toString().replaceAll("[", "");
          String reFormatMAList =  formatMAList.replaceAll("]", "");
          marketAreaInString = reFormatMAList;

          String formatPAList =  practiceArea.toString().replaceAll("[", "");
          String reFormatPAList =  formatPAList.replaceAll("]", "");
          practiceAreaInString = reFormatPAList;
          }
        

      });
    });
    FirebaseFirestore.instance.collection("MembershipDetails").doc(membersId).get()
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
    return Column(
      children: [
            Center(
              child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(100)
                  ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profilePicsUrl.isEmpty? CircularProgressIndicator():Image.network(profilePicsUrl, fit: BoxFit.cover,))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: accountStatus == "Verified"? Row(
                                    children: [
                                      Text("Verified",style: TextStyle(fontSize: 13, color: Colors.black),),
                                      Icon(Icons.verified, color: Colors.green, size: 20),
                                    ],
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info, color: Colors.black, size: 20),
                                      Text("Account Not Verified",style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
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
                    child: Text("Creator's Name", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(firstName+ " ${lastName.toUpperCase()[0]}.", style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),

              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Creator's Devclub ID", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("INVESTOR/"+membershipId, style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),
               TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Creator's Membership Status", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(membershipStatus+" Member", style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),

              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Position Held in Company", style: TextStyle(color: Colors.black)),
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
                    child: Text("Creator's Yearly Turn Over", style: TextStyle(color: Colors.black)),
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
                    child: Text("Creator's Last Transaction Worth", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("\$"+lastTransactionWorth, style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Creator's Achievement", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(achievement, style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Creator's Market Area", style: TextStyle(color: Colors.black)),
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
                    child: Text("Creator's Practice Area", style: TextStyle(color: Colors.black)),
                  ),),
                  TableCell(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(practiceAreaInString, style: TextStyle(color: Colors.black)),
                  ),),
                ]
              ),
              
            ],
          ),
        ),
      ],
    );

  }

    
    return Scaffold(
      appBar: AppBar(
        title: Text("MEMBERS PROFILE", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
              creatorsProfile(),
            ],
          ),
        ),
      )
    );
  }
}