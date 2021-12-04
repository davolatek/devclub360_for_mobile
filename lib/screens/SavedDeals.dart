import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class SaveDealsScreen extends StatefulWidget {
  const SaveDealsScreen({ Key? key }) : super(key: key);

  @override
  _SaveDealsScreenState createState() => _SaveDealsScreenState();
}

class _SaveDealsScreenState extends State<SaveDealsScreen> {
  String dealTitle = "",dealTitleShare = "", dealCreatorName="", netOperatingCost = "", netOperatingIncome = "", noOfInvestors ="", overAllROI = "";
  String description = "", dealType = "", interestRate = "", noOfApplication = "", numberOfInvestors ="", projectAmount = "";
  String projectTimeline = "", ROICycle = "", totalProfitShare ="", dealcreatorid = "", dealStatus = "", dealShareStatus = "";
  int minAmount = 0;
   static TextEditingController controllerOffer = new TextEditingController();
  static TextEditingController controllerAmount = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Deals", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Text("Saved Deals", style: TextStyle(color: Colors.black, fontSize: 12),),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
                height: 2,
              ),
              
              Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("SavedDeals").where("DealSavedByMemberId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                               key: Key("saveddeals"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                 if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),

                                            ),
                                            Text("Saved Deals cannot be loaded at the moment")
                                          ],
                                        ),
                                    );
                             }else{
                               if(snapshot.hasData){
                                 if(snapshot.data!.docs.length == 0){
                                    return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),

                                            ),
                                            Text("You have no Saved deals")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                          Timestamp creationDate = snapshot.data!.docs[index].get("SavedDate");
                                          DateTime convertedCreatedDate = DateTime.fromMicrosecondsSinceEpoch(creationDate.microsecondsSinceEpoch);
                                          if(snapshot.data!.docs[index].get("DealType") == "Deal Connect"){
                                            FirebaseFirestore.instance.collection("DealConnects").doc(snapshot.data!.docs[index].get("DealId"))
                                            .get().then((value){
                                              setState(() {
                                                dealTitle = value.get("DealTitle");
                                                dealCreatorName = value.get("DealCreatorName");
                                                netOperatingCost = value.get("NetOperatingCost");
                                                netOperatingIncome = value.get("NetOperatingIncome");
                                                noOfInvestors = value.get("NumberOfInvestors");
                                                overAllROI = value.get("OverAllROI");
                                                dealcreatorid = value.get("DealCreatedBy");
                                                dealStatus = value.get("DealStatus");
                                              });
                                            });
                                            return ListTile(
                                            leading: Text((index+1).toString()),
                                            title: Text(dealTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text("Saved On: "+ convertedCreatedDate.toString()),
                                            trailing: ElevatedButton(
                                              onPressed: (){
                                                showDialog(context: context, builder: (context)=>AlertDialog(
                                                  title: Text(dealTitle),
                                                  insetPadding: EdgeInsets.all(10),
                                                  content: Table(children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Creator's Name"),
                                                          )
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(dealCreatorName),
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Net Operating Cost"),
                                                          )
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("\$"+netOperatingCost),
                                                          )
                                                        ),
                                                      ]
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Net Operating Income"),
                                                          )
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("\$"+netOperatingIncome),
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Number of Investors"),
                                                          )
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(noOfInvestors),
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Over All ROI"),
                                                          )
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("\$"+overAllROI),
                                                          )
                                                        )
                                                      ]
                                                    ),
                                                  ],),
                                                  scrollable: true,
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: Text("OK")
                                                    ),
                                                    FirebaseAuth.instance.currentUser!.uid == dealcreatorid ? Text("") :
                                                    ElevatedButton(
                                                      onPressed: (){
                                                        FirebaseFirestore.instance.collection("DealConnects").doc(snapshot.data!.docs[index].get("DealId")).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).get()
                                                        .then((docs){
                                                            if(docs.exists){
                                                              showSimpleNotification(
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.not_accessible, size: 20, color: Colors.white,),
                                                                            Expanded(child: Text("Your Application has already been submitted for this deal", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                                          ],
                                                                        ),
                                                                        background: Colors.green,
                                                                        duration: Duration(seconds: 5),
                                                                        slideDismissDirection: DismissDirection.horizontal
                                                                        );
                                                            }else{
                                                                if(dealStatus != "Open"){
                                                                  showSimpleNotification(
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.not_accessible, size: 20, color: Colors.white,),
                                                                            Expanded(child: Text("You can no longer apply for this deal cause it has been marked closed", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                                          ],
                                                                        ),
                                                                        background: Colors.red,
                                                                        duration: Duration(seconds: 5),
                                                                        slideDismissDirection: DismissDirection.horizontal
                                                                        );
                                                                }else{
                                                                  showDialog(context: context, builder: (context)=>AlertDialog(
                                                                    scrollable: true,
                                                                    insetPadding: EdgeInsets.all(10),
                                                                    title: Text("Your Offer to this Project"),
                                                                    content: TextFormField(
                                                                              decoration: InputDecoration(
                                                                                
                                                                                labelText: "What would you offer to this project", 
                                                                                hintText: "Not More than 500 words",
                                                                                labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                                                                fillColor: Colors.black,
                                                                                focusColor: Colors.lightBlueAccent,
                                                                                hoverColor: Colors.lightBlueAccent,
                                                                                focusedBorder:OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                                                                  
                                                                                ),
                                                                                
                                                                                ),
                                                                              
                                                                              maxLength: 500,
                                                                              maxLines: 5,
                                                                              keyboardType: TextInputType.multiline,
                                                                              controller: controllerOffer,
                                                                              
                                                                              //validate when you want to press button
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                onPressed: (){
                                                                                     if(controllerOffer.text.isNotEmpty){
                                                                                       FirebaseFirestore.instance.collection("DealConnects").doc(snapshot.data!.docs[index].get("DealId")).collection("Applications")
                                                                                    .doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                        "DealConnectId": snapshot.data!.docs[index].get("DealId"),
                                                                                        "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                                                                        "ProjectOffer": controllerOffer.text,
                                                                                        "JoinedAt": DateTime.now(),
                                                                                        "ApplicationStatus": "Pending"
                                                                                      }).then((value){
                                                                                          FirebaseFirestore.instance.collection("InterestedDeals").add({
                                                                                              "DealId": snapshot.data!.docs[index].get("DealId"),
                                                                                              "DealType": "Deal Connect",
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
                                                                                                    controllerOffer.clear();
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
                                                                                     }else{
                                                                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Project Offer is required"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                                                                     }   
                                                                                }, 
                                                                                child: Text("Submit Offer")
                                                                              )
                                                                            ],
                                                                          ),
                                                                  );
                                                                }
                                                            }
                                                        });
                                                      }, 
                                                      child: Text("Apply")
                                                    ),
                                                  ],
                                                ));
                                              }, 
                                              child: Text("Details")
                                            ),
                                          );

                                          }else if(snapshot.data!.docs[index].get("DealType") == "Deal Share"){
                                              FirebaseFirestore.instance.collection("DealShares").doc(snapshot.data!.docs[index].get("DealId"))
                                            .get().then((value){
                                              setState(() {
                                                dealTitleShare = value.get("DealTitle");
                                                description = value.get("DealDescription");
                                                dealType = value.get("DealTypes");
                                                interestRate = value.get("InterestRateDistribution");
                                                minAmount = value.get("MinimumAmount");
                                                noOfApplication = value.get("NumberOfApplication");
                                                numberOfInvestors = value.get("NumberOfInvestors");
                                                projectAmount = value.get("ProjectAmount");
                                                projectTimeline = value.get("ProjectCompletionTime");
                                                ROICycle = value.get("ROICycle");
                                                totalProfitShare = value.get("TotalProfitShare");
                                                dealShareStatus = value.get("DealStatus");
                                              });
                                            });
                                            return ListTile(
                                            leading: Text((index+1).toString()),
                                            title: Text(dealTitleShare, style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text("Saved On: "+ convertedCreatedDate.toString()),
                                            trailing: ElevatedButton(
                                              onPressed: (){
                                                showDialog(
                                                  
                                                  context: context, builder: (context)=>Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: AlertDialog(
                                                    insetPadding: EdgeInsets.all(10),
                                                    title: Text(dealTitleShare),
                                                    content: Table(children: [
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Project Description"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(description),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Deal Share Category"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(dealType),
                                                            )
                                                          ),
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Interest Rate Distribution"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(interestRate)
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Minimum Amount to Invest"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(minAmount.toString()),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Number of Applications"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(noOfApplication),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Number of Investors needed"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(numberOfInvestors),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Project Amount"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(projectAmount),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Project Completion Timeline"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(projectTimeline),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Project Amount"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(projectAmount),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("ROI Cycle"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(ROICycle),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Total Profit Share"),
                                                            )
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(totalProfitShare),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                    ],),
                                                    scrollable: true,
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        }, 
                                                        child: Text("OK")
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: (){
                                                            FirebaseFirestore.instance.collection("DealShares").doc(snapshot.data!.docs[index].get("DealId")).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid)
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
                                                                  if(dealShareStatus != "Open"){
                                                                      showSimpleNotification(
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.not_accessible, size: 20, color: Colors.white,),
                                                                            Expanded(child: Text("You can no longer apply for this deal cause it has been marked closed", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                                          ],
                                                                        ),
                                                                        background: Colors.red,
                                                                        duration: Duration(seconds: 5),
                                                                        slideDismissDirection: DismissDirection.horizontal
                                                                        );
                                                                  }else{
                                                                      showDialog(
                                                                        context: context, 
                                                                        builder: (context)=>AlertDialog(
                                                                          scrollable: true,
                                                                          insetPadding: EdgeInsets.all(10),
                                                                          title: Text("Amount to Offer to this Project"),
                                                                          content: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Center(child: Text("Transfer to Devclub Domiciliary(Dollars) Account details")),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Text("Account Name", style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                                    Text("Devclub360")
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Text("Account Number", style: TextStyle(color: Colors.black, fontSize: 10)),
                                                                                    Text("1234567890")
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              TextFormField(
                                                                                  decoration: InputDecoration(
                                                                                    
                                                                                    labelText: "How much would you offer to this project", 
                                                                                    hintText: "Amount in dollars",
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
                                                                                  
                                                                                  //validate when you want to press button
                                                                                ),
                                                                            ],
                                                                          ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                onPressed: (){
                                                                                    if(controllerAmount.text.isNotEmpty){
                                                                                      FirebaseFirestore.instance.collection("DealShares").doc(snapshot.data!.docs[index].get("DealId")).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                        "DealShareId": snapshot.data!.docs[index].get("DealId"),
                                                                                          "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                                                                          "ProjectOfferAmount": controllerAmount.text,
                                                                                          "JoinedAt": DateTime.now(),
                                                                                          "ApplicationStatus": "Pending"
                                                                                      }).then((value){
                                                                                        FirebaseFirestore.instance.collection("InterestedDeals").add({
                                                                                          "DealId": snapshot.data!.docs[index].get("DealId"),
                                                                                          "DealType": "Deal Share",
                                                                                          "InterestedMemberId": FirebaseAuth.instance.currentUser!.uid,
                                                                                          "InterestDate": DateTime.now()
                                                                                        }).then((value){
                                                                                          FirebaseFirestore.instance.collection("DealShares").doc(snapshot.data!.docs[index].get("DealId")).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                                                                          "DealShareId": snapshot.data!.docs[index].get("DealId"),
                                                                                            "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                                                                            "ProjectOfferAmount": controllerAmount.text,
                                                                                            "JoinedAt": DateTime.now(),
                                                                                            "ApplicationStatus": "Pending"
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
                                                message: "An Interest has been shown to a deal share project. Do well to login to your admin dashboard and commence the process"
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
                                                                                          })
                                                                                          .catchError((error){
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
                                                                                    }else{
                                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Amount to offer is required"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                                                                    }
                                                                                }, 
                                                                                child: Text("Apply")
                                                                              )
                                                                            ]
                                                                        )
                                                                      );
                                                                  }
                                                                }
                                                            });

                                                        }, 
                                                        child: Text("Apply")
                                                      )
                                                    ],
                                                  ),
                                                ));
                                              }, 
                                              child: Text("Details")
                                            ),
                                          );
                                          }
                                          
                                          return Text("You have no Saved deals");
                                            
                                        }
                                        
                                        );
                                   }
                               }
                             }
                           }
                             return Center(child: Column(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 50.0),
                                   child: Text("Looking up for Interested Deals...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                                
                             })
                    )
            ],
          ),
        ),
      ),
    );
  }
}