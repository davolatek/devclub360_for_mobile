import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class DealConnectProjectScreen extends StatefulWidget {
  final DocumentSnapshot deals;

  DealConnectProjectScreen({required this.deals});

  @override
  _DealConnectProjectScreenState createState() => _DealConnectProjectScreenState();
}

class _DealConnectProjectScreenState extends State<DealConnectProjectScreen> {
  List<dynamic> creatorOfferList = [];
  String offerList = "";
  final controller = ScrollController();
  bool showDealDetails = true, showCreatorProfile = false, showApplication = false;
  String firstName = "", lastName = "", yearlyWorth = "", lastTransactionWorth ="", accountStatus = "";
  String companyName = "", companyWebsite ="", marketAreaInString = "", practiceAreaInString = ""; List<dynamic> marketArea = [], practiceArea = [];
  String achievement = "", positionHeld = "";
  String membershipId = "", membershipStatus = "";
  static TextEditingController offerController = new TextEditingController();
  

  int _state = 0;

  

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Join Deal",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new Text(
          "Processing application...",
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
        );
        
      }

      return widget;
      
    }

  Widget creatorsProfile(){

    FirebaseFirestore.instance.collection("Members").doc(widget.deals.get("DealCreatedBy")).get()
    .then((value){
      setState(() {
        firstName = value.get("firstName");
        lastName = value.get("lastName");
        yearlyWorth = value.get("YearlyWorth");
        lastTransactionWorth = value.get("lastTransactionWorth");
        accountStatus= value.get("AccountStatus");
        achievement = value.get("MembersAchievement");

      });
    });

    FirebaseFirestore.instance.collection("MembersCompanyDetails").doc(widget.deals.get("DealCreatedBy")).get()
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
    FirebaseFirestore.instance.collection("MembershipDetails").doc(widget.deals.get("DealCreatedBy")).get()
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
                        child: widget.deals.get("DealCreatorPics").isEmpty? CircularProgressIndicator():Image.network(widget.deals.get("DealCreatorPics"), fit: BoxFit.cover,))),
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

  @override
  Widget build(BuildContext context) {

    getCreatorsList(){
      Map creatorListResponse = {"offers": widget.deals.get("DealCreatorOffers")};

      setState(() {
        creatorOfferList = creatorListResponse.values.toList();

       String formatOfferList =  creatorOfferList.toString().replaceAll("[", "");
        String reFormatOfferList =  formatOfferList.replaceAll("]", "");
        offerList = reFormatOfferList;
      });

      return offerList;
    }
    
    Widget hasFunding(){
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(color: Colors.black, width: 1.3),
          children: [
            TableRow(
              children: [
                TableCell(
                   child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Text("Amount Of Investment", style: TextStyle(color: Colors.black)),
                   ),
                ),
                TableCell(
                   child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Text("\$"+widget.deals.get("AmountOfInvestment"), style: TextStyle(color: Colors.black)),
                   ),
                ),
              ]
            )
          ],
        )
      );
  }

  Widget hasInvestor(){
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(color: Colors.black, width: 1.3),
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Amount Of Investment By Investor", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("\$"+widget.deals.get("AmountOfInvestmentByInvestor"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("What the Investor Expects as ROI", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("InvestmentExpectedROI"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
          ],
        ),
      );
  }

  Widget hasOfftakers(){
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(color: Colors.black, width: 1.3),
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Is(are) The Off Takers Guaranteed?", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("GuaranteedOffTakers"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            
          ],
        ),
      );
  }

  Widget hasLandOnly(){
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Table(
          border: TableBorder.all(color: Colors.black, width: 1.3),
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Land Size", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("LandSize"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Land Location", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("LandLocation"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Land Price Worth", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("\$"+widget.deals.get("LandPriceWorth"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Title Of Document", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("TitleOfDocument"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Is there Structure On Land?", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("StructureOnLand"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Structure Planned to develop on Land?", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("TypeOfStructurePlan"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Is Land free from Reclamation?", style: TextStyle(color: Colors.black)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.deals.get("FreeFromReclamation"), style: TextStyle(color: Colors.black)),
                )),
              ]
            ),
          ],
        ),
      );
  }

  Widget hasLandAndFunding(){
      return Column(
        children: [
          
          hasLandOnly(),
          hasFunding()
        ]
      );
    }

    Widget hasLandAndInvestors(){
      return Column(
        children: [
          
          hasLandOnly(),
          hasInvestor()
        ]
      );
    }
    Widget hasLandAndOffTakers(){
      return Column(
        children: [
          
          hasLandOnly(),
          hasOfftakers()

        ]
      );
    }

    Widget hasFundingAndInvestor(){
      return Column(
        children: [
          
          hasFunding(),
          hasInvestor()

        ]
      );
    }

    Widget hasFundingAndOffTakers(){
      return Column(
        children: [
          
          hasFunding(),
          hasOfftakers()

        ]
      );
    }

    Widget hasInvestorAndOffTakers(){
      return Column(
        children: [
          
          hasInvestor(),
          hasOfftakers()

        ]
      );
    }
    return Scaffold(
      key: Key("dealscreen"),
      appBar: AppBar(
        title: Text("Joint Ventures Projects", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Visibility(
                visible: showDealDetails,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(  
                          child: Text(  
                            widget.deals.get("DealTitle"),  
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  
                          )
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 10.0),
                      child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                        child: Carousel(
                              autoplay: false,
                              dotPosition: DotPosition.bottomCenter,
                              dotBgColor: Colors.black54,
                              dotSize: 2,
                              images: [
                                Stack(
                                  children: [
                                    Image.network(widget.deals.get("ProjectRelatedImages1"), fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.4,),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(widget.deals.get("DealTitle"), style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),)
                                      
                                    )
                                  ],
                                ),
                                Stack(
                                  children: [
                                    widget.deals.get("ProjectRelatedImages2") == "" ? Center(child: Text("No Other Images",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10
                                          ),)):
                                    Image.network(widget.deals.get("ProjectRelatedImages2"), fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.4,),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text("Project Related Images for "+widget.deals.get("DealTitle"), style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),)
                                      
                                    )
                                  ],
                                ),
                                Stack(
                                  children: [
                                    widget.deals.get("ProjectRelatedImages3") == "" ? Center(
                                      child: Text("No Other Images",style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                          ),),
                                    ):
                                    Image.network(widget.deals.get("ProjectRelatedImages3"), fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.4,),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text("Project Related Images for "+widget.deals.get("DealTitle"), style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),)
                                      
                                    )
                                  ],
                                ),
                                
                              ],
                            ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextButton.icon(
                        onPressed: (){
                            setState((){
                              showCreatorProfile = true;
                              showDealDetails = false;
                              showApplication = false;
                            });
                        }, 
                        icon: Icon(Icons.person, color: Colors.black), 
                        label: Text("Tap to View Creator's Profile", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(  
                          child: Text(  
                            "Project Information",  
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  
                          )
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.black, width: 1.3),
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Creator's Contribution?", style: TextStyle(color: Colors.black),),
                              )),
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(getCreatorsList(), style: TextStyle(color: Colors.black),),
                              ) ),
              
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Net Operating Cost", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("NetOperatingCost"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Net Operating Income", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("NetOperatingIncome"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Over all Return on Investment", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("OverAllROI"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Preferred Equity Investor", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("PrefferedEquityInvestor"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Common Equity Investor", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("CommonEquityInvestor"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Profit Sharing Ratio", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("ProfitSharingRatio"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Is Architectural Design Ready", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("ArchitecturalDesignReady"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Is Business Plan Ready", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("BusinessPlanReady"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Is Financial Model Ready", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("FinancialModelReady"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Project Completion Timeline", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("ProjectCompletionTimeLine"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Any Personal Equity", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("AnyPersonalEquity"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                              TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Any Hot Money", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("AnyHotMoney"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                            TableRow(
                              children: [
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("The type(s) of Investor/Partners this creator is interested in?", style: TextStyle(color: Colors.black),),
                                )),
                                TableCell(child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(widget.deals.get("TypeOfJointVenture"), style: TextStyle(color: Colors.black),),
                                )),
                
                                ]
                              ),
                            TableRow(
                            children: [
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("What this creator requires from prospective partners/investors?", style: TextStyle(color: Colors.black),),
                              )),
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(widget.deals.get("JointPartnersOffer"), style: TextStyle(color: Colors.black),),
                              )),
              
                              ]
                            ),
                            TableRow(
                            children: [
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Numbers of Investors/Partners needed on this Project?", style: TextStyle(color: Colors.black),),
                              )),
                              TableCell(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(widget.deals.get("NumberOfInvestors"), style: TextStyle(color: Colors.black),),
                              )),
              
                              ]
                            ),
              
                        ],
                      ),
                    ), 
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(  
                          child: Text(  
                            "Creator's Offer(s)",  
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  
                          )
                        ),
                    ),
                    Container(
                            child: getCreatorsList().contains("Land") && !getCreatorsList().contains("Funding") && !getCreatorsList().contains("Investors") && !getCreatorsList().contains("Off-Takers")
                                  ? hasLandOnly() : getCreatorsList().contains("Land") && getCreatorsList().contains("Funding") && !getCreatorsList().contains("Investors") && !getCreatorsList().contains("Off-Takers")
                                  ? hasLandAndFunding(): getCreatorsList().contains("Land") && !getCreatorsList().contains("Funding") && getCreatorsList().contains("Investors") && !getCreatorsList().contains("Off-Takers")
                                  ? hasLandAndInvestors(): getCreatorsList().contains("Land") && !getCreatorsList().contains("Funding") && !getCreatorsList().contains("Investors") && getCreatorsList().contains("Off-Takers")
                                  ? hasLandAndOffTakers(): getCreatorsList().contains("Funding") && !getCreatorsList().contains("Land") && !getCreatorsList().contains("Investors") && !getCreatorsList().contains("Off-Takers")
                                  ? hasFunding(): getCreatorsList().contains("Funding") && getCreatorsList().contains("Investors") && !getCreatorsList().contains("Land") && getCreatorsList().contains("Off-Takers")
                                  ? hasFundingAndInvestor(): getCreatorsList().contains("Funding") && getCreatorsList().contains("Off-Takers") && !getCreatorsList().contains("Land") && !getCreatorsList().contains("Investors")
                                  ? hasFundingAndOffTakers(): getCreatorsList().contains("Investors") && !getCreatorsList().contains("Funding") && !getCreatorsList().contains("Land") && !getCreatorsList().contains("Off-Takers") 
                                  ? hasInvestor(): getCreatorsList().contains("Investors") && getCreatorsList().contains("Off-Takers") && !getCreatorsList().contains("Land") && !getCreatorsList().contains("Funding")
                                  ? hasInvestorAndOffTakers(): !getCreatorsList().contains("Investors") && getCreatorsList().contains("Off-Takers") && !getCreatorsList().contains("Land") && !getCreatorsList().contains("Funding")
                                  ? hasOfftakers(): Text("")
                          ),

                FirebaseAuth.instance.currentUser!.uid == widget.deals.get("DealCreatedBy")? 
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text("You created this deal, you cannot apply!!!", style: TextStyle(fontStyle: FontStyle.italic,
                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red))
                  )
                )
                :Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: ElevatedButton(
                                onPressed: (){
                                   FirebaseFirestore.instance.collection("DealConnects").doc(widget.deals.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).get()
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
                                        setState((){
                                        showCreatorProfile = false;
                                        showDealDetails = false;
                                        showApplication = true;
                                      });
                                     }
                                   });
                                    
                                }, 
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                                ),
                                child: Text("I am Interested in this deal. Click!", style: TextStyle(color: Colors.white, fontSize: 10),)
                                )
                            )
                          ),

                           Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                            child: ElevatedButton.icon(
                              onPressed: (){
                                  final double start = 0;
              
                                  controller.animateTo(start, duration: Duration(seconds: 1), curve: Curves.easeIn);
                              }, 
                              icon: Icon(Icons.arrow_upward_rounded, color: Colors.white,), 
                              label: Text(""),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent), fixedSize: MaterialStateProperty.all(Size(10, 10))),
                  
                              ),
                          )
                        )




                  ],
                )
              ),
              Visibility(
                visible: showCreatorProfile,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextButton.icon(
                        onPressed: (){
                            setState((){
                              showCreatorProfile = false;
                              showDealDetails = true;
                              showApplication = false;
                            });
                        }, 
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
                        label: Text("Go back", style: TextStyle(color: Colors.black, fontSize: 9))
                      ),
                    ),
                    creatorsProfile(),
                    
                  ],
                ),
              ),
              Visibility(
                visible: showApplication,
                child: Form(
                  
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("What do you have to offer to this Project",
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),)
                        ),

                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                
                                labelText: "Highlight What you have to offer to this Project", 
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
                              controller: offerController,
                              
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: (){
                                    if(offerController.text.isNotEmpty){
                                      setState(() {
                                        _state = 1;
                                      });
                                        FirebaseFirestore.instance.collection("DealConnects").doc(widget.deals.id).collection("Applications").doc(FirebaseAuth.instance.currentUser!.uid).get()
                                        .then((docs){
                                            if(docs.exists){
                                                showSimpleNotification(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.not_accessible, size: 20, color: Colors.white,),
                                                      Expanded(child: Text("Your Application has already been taken for this deal", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  background: Colors.green,
                                                  duration: Duration(seconds: 5),
                                                  slideDismissDirection: DismissDirection.horizontal
                                                  );
                                                   setState(() {
                                                      _state = 0;
                                                    });
                                            }else{
                                              FirebaseFirestore.instance.collection("DealConnects").doc(widget.deals.id).collection("Applications")
                                          .doc(FirebaseAuth.instance.currentUser!.uid).set({
                                              "DealConnectId": widget.deals.id,
                                              "ApplicatorID": FirebaseAuth.instance.currentUser!.uid,
                                              "ProjectOffer": offerController.text,
                                              "JoinedAt": DateTime.now(),
                                              "ApplicationStatus": "Pending"
                                            }).then((value) async{
                                            FirebaseFirestore.instance.collection("InterestedDeals").add({
                                              "DealId": widget.deals.id,
                                              "DealType": "Deal Connect",
                                              "InterestedMemberId": FirebaseAuth.instance.currentUser!.uid,
                                              "InterestDate": DateTime.now()
                                            }).then((value) async{
                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUBER",
                                                email: FirebaseAuth.instance.currentUser!.email.toString(),
                                                subject: "Your Deal Connect Interest has been received",
                                                message: "The support team received your interest in the latest post. We’ll contact you for more details\n\nIf you need an urgent response, kindly use your web form in the contact admin section or send a message from your InMessage.\n\nThank You\n\nDEVCLUB360 TEAM."
                                              );

                                              await ValidateDashboard().sendEmail(
                                                name: "DEVCLUB360",
                                                email: "operations@devclub360.com",
                                                subject: "A Deal Connect Interest has been received",
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
                                                   setState(() {
                                                      _state = 0;
                                                    });
                                                    
                                                    offerController.clear();
                                                   // offerFormKey.currentState!.reset();
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

                                                   setState(() {
                                                    _state = 0;
                                                  });
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

                                                   setState(() {
                                                    _state = 0;
                                                  });
                                            });
                                            }
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
                                                   setState(() {
                                                      _state = 0;
                                                    });
                                        });
                                        
                                    }else{
                                        setState(() {
                                          _state = 0;

                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Offer is required"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                    }
                                }, 
                                child: setUpButtonChild()
                              )
                            ),
                          )

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}