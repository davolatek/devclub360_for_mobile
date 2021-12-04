import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InterestedDealsScreen extends StatefulWidget {
  const InterestedDealsScreen({ Key? key }) : super(key: key);

  @override
  _InterestedDealsScreenState createState() => _InterestedDealsScreenState();
}

class _InterestedDealsScreenState extends State<InterestedDealsScreen> {
  String dealTitle = "",dealTitleShare = "", dealCreatorName="", netOperatingCost = "", netOperatingIncome = "", noOfInvestors ="", overAllROI = "";
  String description = "", dealType = "", interestRate = "", noOfApplication = "", numberOfInvestors ="", projectAmount = "";
  String projectTimeline = "", ROICycle = "", totalProfitShare ="";
  int minAmount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interested Deals", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                  child: Text("Interested Deals", style: TextStyle(color: Colors.black, fontSize: 12),),
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
                               stream: FirebaseFirestore.instance.collection("InterestedDeals").where("InterestedMemberId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                               key: Key("interesteddeals"),
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
                                            Text("Interested Deals cannot be loaded at the moment")
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
                                            Text("You have no Interested deals")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                          Timestamp creationDate = snapshot.data!.docs[index].get("InterestDate");
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
                                              });
                                            });
                                            return ListTile(
                                            leading: Text((index+1).toString()),
                                            title: Text(dealTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text("Interested On: "+ convertedCreatedDate.toString()),
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
                                                    )
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
                                              });
                                            });
                                            return ListTile(
                                            leading: Text((index+1).toString()),
                                            title: Text(dealTitleShare, style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text("Interested On: "+ convertedCreatedDate.toString()),
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
                                                      )
                                                    ],
                                                  ),
                                                ));
                                              }, 
                                              child: Text("Details")
                                            ),
                                          );
                                          }
                                          
                                          return Text("You have no Interested deals");
                                            
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