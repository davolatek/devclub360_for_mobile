import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:devclub360/screens/ViewDealShareProposal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DealShareProjects extends StatefulWidget {
  final DocumentSnapshot projects;

  DealShareProjects({required this.projects});

  @override
  _DealShareProjectsState createState() => _DealShareProjectsState();
}

class _DealShareProjectsState extends State<DealShareProjects> {

  int numberOfApplications = 0, numberOfInvestors = 0;
  String noA= "", noI ="", paymentOption = "", proposalUrl = "";
  double percent = 0.0;
  static TextEditingController controllerQuery = new TextEditingController();
  static TextEditingController controllerAmount = new TextEditingController();
  bool showMakePayment = false, showDealDetails = true, showTransferDetails = false, showPayLaterDetails= false;

  
  @override
  Widget build(BuildContext context) {
    
   double calculatePercentage(){
     setState(() {
       noA = widget.projects.get("NumberOfApplication");
       noI = widget.projects.get("NumberOfInvestors");

       numberOfApplications = int.parse(noA);
       numberOfInvestors = int.parse(noI);

       percent = (numberOfApplications/numberOfInvestors) * 100;
     });

     

      return percent/100;
    }
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Deal Share-Projects", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Visibility(
                visible: showDealDetails,
                child: Column(
                  children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(widget.projects.get("DealTitle"), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Text(widget.projects.get("DealDescription"), style: TextStyle(fontSize: 12)),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async{
                                setState(() {
                                  proposalUrl = widget.projects.get("ProposalUrl");
                                });

                                await canLaunch(proposalUrl) ? await launch(proposalUrl) : showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ));
                            }, 
                            child: Text("View Proposal")
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Center(
                            child: Text("Application Progress"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: new LinearPercentIndicator(
                              width: 170.0,
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 20.0,
                              leading: new Text("Min"),
                              trailing: new Text("Max"),
                              percent: calculatePercentage(),
                              center: Text(numberOfApplications.toString()+" out of "+ numberOfInvestors.toString() ),
                              linearStrokeCap: LinearStrokeCap.butt,
                              progressColor: Colors.green,
                            ),
                          ),
                        ],),

                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20,),
                        child: Center(
                          child: Text(widget.projects.get("DealTitle")+" Interest Information", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 5, right: 5, bottom: 10),
                        child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                      ),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Table(
                          border: TableBorder.all(color: Colors.black, width: 1.3),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Project Amount to be Raised"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("\$"+widget.projects.get("ProjectAmount")),
                                  )
                                ),
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("ROI Cycle"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.projects.get("ROICycle")),
                                  )
                                ),
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Interest Rate Distribution"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.projects.get("InterestRateDistribution")),
                                  )
                                ),
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Minimum Amount of Investment Required"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("\$"+widget.projects.get("MinimumAmount").toString()),
                                  )
                                ),
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Total Profit Share (TPS)"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.projects.get("TotalProfitShare").toString()),
                                  )
                                ),
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Project Completion Timeline"),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(widget.projects.get("ProjectCompletionTime").toString()),
                                  )
                                ),
                              ]
                            ),
                          ],
                        )
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (context)=>AlertDialog(
                                      title: Text("Your Feedback/Query"),
                                      content: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          
                                          labelText: "Feedbacks and Query", 
                                          hintText: "Your Feedback & Query",
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          fillColor: Colors.black,
                                          focusColor: Colors.lightBlueAccent,
                                          hoverColor: Colors.lightBlueAccent,
                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                            
                                          ),
                                          
                                          ),
                                        showCursor: true,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                        maxLength: 200,
                                        controller: controllerQuery,
                                        autocorrect: true,
                                        
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () async{
                                          if(controllerQuery.text.isNotEmpty){
                                            await ValidateDashboard().doQuerySubmission(controllerQuery, widget.projects.id);
                                            Navigator.pop(context);
                                          }else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                          }
                                        }, 
                                        icon: Icon(Icons.send)
                                        ),
                                    )
                                
                                  ],
                                ),
                              ),
                                  ));
                              }, 
                              icon: Icon(Icons.feedback, color: Colors.black, size: 20,), 
                              label: Text("Send FeedBack/Query")
                            ),
                            Container(
                              child: widget.projects.get("DealTypes") == "Proposals" ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(child: Text("Click on the \"view proposal\" button above to view the proposal, and send a feedback to us in the feedback/Query section", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                              )
                              :TextButton.icon(
                                onPressed: (){
                                    if(numberOfApplications == numberOfInvestors){
                                          showSimpleNotification(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.support, size: 20, color: Colors.white,),
                                                Expanded(child: Text("Maximum Number of Application has been reached", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                              ],
                                            ),
                                            background: Colors.green
                );
                                    }else{
                                      setState(() {
                                        showDealDetails = false;
                                        showMakePayment = true;
                                        showTransferDetails = false;
                                        showPayLaterDetails = false;
                                      });
                                    }
                                }, 
                                icon: Icon(Icons.payment, color: Colors.black, size: 20,), 
                                label: Text("Join Deal and Make Payment")
                              ),
                            ),
                            
                            TextButton.icon(
                              onPressed: (){
                                  FirebaseFirestore.instance.collection("SavedDeals").add({
                                              "DealId": widget.projects.id,
                                              "DealType": "Deal Share",
                                              "DealSavedByMemberId": FirebaseAuth.instance.currentUser!.uid,
                                              "SavedDate": DateTime.now()
                                            }).then((value){
                                                showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.approval, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("This deal has been saved successfully", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                                   
                                                   
                                                  showDialog(context: context, barrierDismissible: false, builder: (context)=>AlertDialog(
                                                    
                                                    title: Text("Deal Successfully saved"),
                                                    content: Text("You can access the saved deals on the Dashboard Menu- Saved Deals"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        }, 
                                                        child: Text("Dismiss")
                                                        )
                                                    ],
                                                  ));
                                            }).catchError((error){
                                              print(error);
                                              showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.red,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );

                                            });
                              }, 
                              icon: Icon(Icons.save, color: Colors.black, size: 20,), 
                              label: Text("Save Deal")
                            )
                          ],
                        )
                      ),
                  ],
                )
              ),

              Visibility(
                visible: showMakePayment,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Select Payment Option?", 
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                                    
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    fillColor: Colors.lightBlueAccent,
                                    focusColor: Colors.lightBlueAccent,
                                    hoverColor: Colors.lightBlueAccent,
                                    focusedBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                      
                                    ),
                                    ),
                                    
                                  
                                    items: [
                                      
                                      DropdownMenuItem<String>(
                                        value: "Payment Later",
                                        child: Text("Make Payment Later")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "Payment Now",
                                        child: Text("Make Payment Now")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        setState(() {
                                          paymentOption = value.toString();
                                        });
                                    },
                                    onSaved: (value){
                                        setState(() {
                                          paymentOption = value.toString();
                                        });
                                        
                                    },
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),

                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              decoration: InputDecoration(
                                
                                labelText: "Amount you want to Invest in dollars", 
                                hintText: "Amount in USD",
                                labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                fillColor: Colors.black,
                                focusColor: Colors.lightBlueAccent,
                                hoverColor: Colors.lightBlueAccent,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                  
                                ),
                                
                                ),
                              
                              keyboardType: TextInputType.number,
                              controller: controllerAmount,
                              
                            ),
                        ), 

                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: (){
                                setState(() {
                                      showDealDetails = false;
                                      showMakePayment = true;
                                      if(paymentOption == ""){
                                        showTransferDetails = false;
                                        showPayLaterDetails = false;
                                        showDealDetails = false;
                                      showMakePayment = true;
                                      }else if(paymentOption == "Payment Later"){
                                        showTransferDetails = false;
                                        showPayLaterDetails = true;
                                        showDealDetails = false;
                                        showMakePayment = true;
                                      }else{
                                        showTransferDetails = true;
                                        showPayLaterDetails = false;
                                        showDealDetails = false;
                                        showMakePayment = true;
                                      }
                                    });
                            },
                            child: Text("Proceed")
                          )
                        )
                  ]
                )
              ),
              Visibility(
                visible: showTransferDetails,
                child: Column(
                  children: [
                    Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text("Devclub360  Account details")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Account Name", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("MORTGOGENIE PROPERTY COMPANY ")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Account Number", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("0037514124")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Bank Name", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("STANBIC BANK")
                                  ],
                                ),
                              ),

                          Padding(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: (){
                                if(controllerAmount.text.isNotEmpty){
                                    FirebaseFirestore.instance.collection("DealShares").doc(widget.projects.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get().then((value){
                                        if(value.exists){
                                          showDialog(context: context, builder: (context)=>AlertDialog(
                                            title: Text("Interest Already Received"),
                                            content: Text("You have already shown interest in this project. \n However, if you haven't made Payment to this effect, your interest won't count. Kindly do so as soon possible before the numbers are filled up.\n Keep Using Devclub360"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                }, 
                                                child: Text("Dismiss")
                                              )
                                            ],
                                          ));
                                        }else{
                                          FirebaseFirestore.instance.collection("DealShares").doc(widget.projects.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                             "DealShareId": widget.projects.id,
                                              "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                              "ProjectOfferAmount": controllerAmount.text,
                                              "JoinedAt": DateTime.now(),
                                              "ApplicationStatus": "Pending"
                                          }).then((value){
                                              FirebaseFirestore.instance.collection("InterestedDeals").add({
                                              "DealId": widget.projects.id,
                                              "DealType": "Deal Share",
                                              "InterestedMemberId": FirebaseAuth.instance.currentUser!.uid,
                                              "InterestDate": DateTime.now()
                                            }).then((value) async{

                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUBER",
                                                email: FirebaseAuth.instance.currentUser!.email.toString(),
                                                subject: "Your Deal Share Interest has been received",
                                                message: "The support team received your interest in the latest post. We’ll contact you for more details\n\nIf you need an urgent response, kindly use your web form in the contact admin section or send a message from your InMessage.\n\nThank You\n\nDEVCLUB360 TEAM."
                                              );

                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUB360",
                                                email: "operations@devclub360.com",
                                                subject: "A Deal Share Interest has been received",
                                                message: "An Interest has been shown to a deal Share project. Do well to login to your admin dashboard and commence the process"
                                              );
                                                showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.approval, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Application to Join this deal has been submitted successfully", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                                  controllerAmount.clear();
                                                  //Send Email to the user that applied giving the deal details
                                                  showDialog(context: context, barrierDismissible: false, builder: (context)=>AlertDialog(
                                                    
                                                    title: Text("Application Submitted"),
                                                    content: Text("Thank You for showing interest in this deal. You will be contacted within 48hours by the Devclub Team"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                                                        }, 
                                                        child: Text("Dismiss")
                                                        )
                                                    ],
                                                  ));
                                            }).catchError((error){
                                                 print(error);
                                              showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.red,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                            });
                                          }).catchError((error){
                                             print(error);
                                              showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.red,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                          });
                                        }
                                    });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The amount you want to invest is required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                }
                              },
                              child: Text("Proceed", style: TextStyle(color: Colors.white, fontSize: 10))
                            )
                          )
                  ],
                ),
              ),
            Visibility(
                visible: showPayLaterDetails,
                child: Column(
                  children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("A space will be booked for you but this is not guaranteed. \nIf The maximum number of applicants is reached, you may not be able to join this deal")
                      ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: (){
                                if(controllerAmount.text.isNotEmpty){
                                    FirebaseFirestore.instance.collection("DealShares").doc(widget.projects.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get().then((value){
                                        if(value.exists){
                                          showDialog(context: context, builder: (context)=>AlertDialog(
                                            title: Text("Interest Already Received"),
                                            content: Text("You have already shown interest in this project. \n However, if you haven't made Payment to this effect, your interest won't count. Kindly do so as soon possible before the numbers are filled up.\n Keep Using Devclub360"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                }, 
                                                child: Text("Dismiss")
                                              )
                                            ],
                                          ));
                                        }else{
                                          FirebaseFirestore.instance.collection("DealShares").doc(widget.projects.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                             "DealShareId": widget.projects.id,
                                              "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                              "ProjectOfferAmount": controllerAmount.text,
                                              "JoinedAt": DateTime.now(),
                                              "ApplicationStatus": "Pending"
                                          }).then((value){
                                              FirebaseFirestore.instance.collection("InterestedDeals").add({
                                              "DealId": widget.projects.id,
                                              "DealType": "Deal Share",
                                              "InterestedMemberId": FirebaseAuth.instance.currentUser!.uid,
                                              "InterestDate": DateTime.now()
                                            }).then((value) async{

                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUBER",
                                                email: FirebaseAuth.instance.currentUser!.email.toString(),
                                                subject: "Your Deal Coonect Interest has been received",
                                                message: "The support team received your interest in the latest post. We’ll contact you for more details\n\nIf you need an urgent response, kindly use your web form in the contact admin section or send a message from your InMessage.\n\nThank You\n\nDEVCLUB360 TEAM."
                                              );

                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUB360",
                                                email: "operations@devclub360.com",
                                                subject: "A Deal Coonect Interest has been received",
                                                message: "An Interest has been shown to a deal connect project. Do well to login to your admin dashboard and commence the process"
                                              );
                                                showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.approval, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Application to Join this deal has been submitted successfully", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                                  controllerAmount.clear();
                                                  //Send Email to the user that applied giving the deal details
                                                  showDialog(context: context, barrierDismissible: false, builder: (context)=>AlertDialog(
                                                    
                                                    title: Text("Application Submitted"),
                                                    content: Text("Thank You for showing interest in this deal. You will be contacted within 48hours by the Devclub Team"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                                                        }, 
                                                        child: Text("Dismiss")
                                                        )
                                                    ],
                                                  ));
                                            }).catchError((error){
                                                 print(error);
                                              showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.red,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                            });
                                          }).catchError((error){
                                             print(error);
                                              showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.error, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("An error occured while carrying out your Application", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.red,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                          });
                                        }
                                    });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The amount you want to invest is required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                }
                              },
                              child: Text("Proceed and Pay Later", style: TextStyle(color: Colors.white, fontSize: 10))
                            )
                          )
                  ],
                ),
              ),

              
            ],
          ),
        ),
      )
    );
  }

  navigateToDealShareProposalsViews(DocumentSnapshot views) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DealShareProjectProposalViews(views: views)));
  }
}