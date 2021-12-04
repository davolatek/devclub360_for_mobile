import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/preaction.dart';
import 'package:devclub360/screens/AboutUs.dart';
import 'package:devclub360/screens/CreateNewDeal.dart';
import 'package:devclub360/screens/CreatedDeals.dart';
import 'package:devclub360/screens/DealConnectProjects.dart';
import 'package:devclub360/screens/DealShareForProjects.dart';
import 'package:devclub360/screens/InterestedDeals.dart';
import 'package:devclub360/screens/MembersProfile.dart';
import 'package:devclub360/screens/Members_Category.dart';
import 'package:devclub360/screens/PaymentPage.dart';
import 'package:devclub360/screens/QuickPosts.dart';
import 'package:devclub360/screens/SavedDeals.dart';
import 'package:devclub360/screens/Support.dart';
import 'package:devclub360/screens/TermsAndConditions.dart';
import 'package:devclub360/screens/TransactionProfile.dart';
import 'package:devclub360/screens/VerifyAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class MemberDashBoard extends StatefulWidget {
  const MemberDashBoard({ Key? key }) : super(key: key);

  @override
  _MemberDashBoardState createState() => _MemberDashBoardState();
}

class _MemberDashBoardState extends State<MemberDashBoard> {

  static final formKey = GlobalKey<FormState>();
int announcementLength = 0, transactionLength = 0, dealShareLength= 0, dealConnectLength = 0, feedLength= 0;
static TextEditingController controllerSubject = new TextEditingController();
  static TextEditingController controllerMessage = new TextEditingController(); 
  static TextEditingController controllerQP = new TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;
String status = "";
String accountStatus = "";
String membershipId = "";
String membershipStatus = "";
String creatorIdentity ="";
String creatorIdentityFirstName ="";
String creatorIdentityLastName = "";
bool hasInternet = false;
bool hasPaid = false;

int _selectedIndexForBottomNavigationBar = 0;
  int _selectedIndexForTabBar = 0;
  late Color color;


  void _onItemTappedForBottomNavigationBar(int index) {
    if(mounted){
      setState(() {
      _selectedIndexForBottomNavigationBar = index;
      _selectedIndexForTabBar = 0;
      if(index == 0){
        color = Colors.redAccent;
      }else if(index== 1){
        color= Colors.lightBlueAccent;
      }else if(index== 2){
        color= Colors.indigo;
      }else{
        color = Colors.indigoAccent;
      }
    });
    }
  }

  @override

void initState() {

  
    if(mounted){
      setState(() {
      _selectedIndexForBottomNavigationBar= 0;
      color= Colors.redAccent;
      
    });
    }

     FirebaseFirestore.instance.collection("Feeds").where("FeedStatus", isEqualTo: "Open").get().then((value){
       if(mounted){
         setState(() {
           feedLength = value.docs.length;
         });
       }
     });
    FirebaseFirestore.instance.collection("DealConnects").where("DealStatus", isEqualTo: "Open").get().then((value){
       if(mounted){
         setState(() {
           dealConnectLength = value.docs.length;
         });
       }
     });
    FirebaseFirestore.instance.collection("MembersTransactions").get().then((value){
       if(mounted){
         setState(() {
           transactionLength = value.docs.length;
         });
       }
     });
    FirebaseFirestore.instance.collection("DealShares").where("DealStatus", isEqualTo: "Open").get().then((value){
       if(mounted){
         setState(() {
           dealShareLength = value.docs.length;
         });
       }
     });
    FirebaseFirestore.instance.collection("Announcements").get().then((value){
       if(mounted){
         setState(() {
           announcementLength = value.docs.length;
         });
       }
     });

  
  
  super.initState();
}

  @override
  Widget build(BuildContext context) {


    FirebaseFirestore.instance.collection("MembershipDetails").doc(auth.currentUser!.uid).get()
    .then((DocumentSnapshot docs){

        if(mounted){
          setState(() {
          membershipId = docs.get("MemberShipId");
          membershipStatus = docs.get("MembershipStatus");
        });
        }
        

        if(membershipId.length == 1){
          membershipId = "00"+membershipId;
        }else if(membershipId.length == 2){
          membershipId = "0"+membershipId;
        }else{
            membershipId = membershipId;
        }
    }).catchError((error){
      print(error);
    });

    FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
    .then((DocumentSnapshot docs){

        if(mounted){
          setState(() {
            accountStatus = docs.get("AccountStatus");
        });
        }
        

    }).catchError((error){
      print(error);
    });

    FirebaseFirestore.instance.collection("MembershipPayments").doc(auth.currentUser!.uid).get()
    .then((docs){
        if(docs.exists){
          if(mounted){
            setState(() {
            hasPaid = true;
          });
          }
        }else{
          if(mounted){
            setState(() {
            hasPaid = false;
          });
          }
        }

    }).catchError((error){
      print(error);
    });

    

    void _onItemTappedForTabBar(int index) {
    if(mounted){
      setState(() {
      _selectedIndexForTabBar = index+1;
      _selectedIndexForBottomNavigationBar = 0;
      if(index == 0){
        color = Colors.black;
      }else if(index== 1){
        color= Colors.brown;
      }else if(index== 2){
        color= Colors.purple;
      }
    });
    }
  }

  final tabBar = new TabBar(labelColor: Colors.white,
      onTap: _onItemTappedForTabBar,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      
      isScrollable: true,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.bold
      ),
      indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color),
      tabs: <Widget>[
        new Tab(
          icon: Badge(
            badgeContent: Text(dealShareLength==0 ? "" : dealShareLength.toString()),
            showBadge: dealShareLength==0 ? false : true,
            child: Icon(Icons.business_rounded,)
            ),
          text: "Deal Share",
          
        ),
        
        new Tab(
          icon: Badge(
            badgeContent: Text(transactionLength==0 ? "" : transactionLength.toString()),
            showBadge: transactionLength==0 ? false : true,
            child: Icon(Icons.attach_money)
            ),
          text: "Transactions",
        ),
        new Tab(
          icon: Badge(
            badgeContent: Text(announcementLength==0 ? "" : announcementLength.toString()),
            showBadge: announcementLength==0 ? false : true,
            child: Icon(
              Icons.notifications)
              ),
          text: "Announcements",
        )
        
      ],
    );

    final topTabs = [
      //This section starts deal share
      SingleChildScrollView(
        child: Column(
          children: [
             
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("DealShares").where("DealStatus", isEqualTo: "Open").snapshots(),
                               key: Key("dealshare"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                try{
                                   if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),

                                            ),
                                            Text("Deals cannot be loaded at the moment")
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
                                            Text("There are no deals yet")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                         
                                            return GestureDetector(
                                              onTap: (){
                                                 
                                                    navigateToDealShareProjects(snapshot.data!.docs[index]);
                                                 
                                              },
                                              child: ListTile(
                                                title: Text(snapshot.data!.docs[index].get("DealTitle"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                leading: Text((index+1).toString()),
                                                subtitle: Text(snapshot.data!.docs[index].get("NumberOfInvestors")+ " allowed to Invest", style: TextStyle(color: Colors.black, fontSize: 12,)),
                                              ),
                                            );
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
                                   child: Text("Looking up for deal shares...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                            }catch(e){
                                  return Center(child: Text("An error occured, check your internet connection"),);
                          }
                                
                             })
                    )
          ],
        ),

      ),


      //End of deal share

      //starts transaction section

      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
               
                      StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("MembersTransactions").snapshots(),
                               key: Key("transactions"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                 try{
                                   if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),
                      
                                            ),
                                            Text("Transactions cannot be loaded at the moment")
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
                                            Text("There are no transactions available yet")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                          
                                            return Container(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 11.5),
                                                child: Card(
                                                      elevation: 0,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                                                            child: Center(child: Text("Transaction Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),)

                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: Divider(thickness: 1, height: 1, color: Colors.redAccent)

                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: Divider(height: 1, thickness: 1, color: Colors.redAccent),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("\$"+snapshot.data!.docs[index].get("TransactionAmount")),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(snapshot.data!.docs[index].get("TransactionLocation")),
                      
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(snapshot.data!.docs[index].get("SizeOfProject")),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: TextButton(
                                                              onPressed: (){
                                                                navigateToDetailsshowTransactionOwnersProfile(snapshot.data!.docs[index]);
                                                              },
                                                              child: Text("Check Member's Profiles")
                                                            )
                                                          
                                                          ),
                                                          
                                                          
                                                          Divider(
                                                            height: 1,
                                                            thickness: 1,
                                                            color: Colors.red
                                                          )
                                                        ]
                                                      )

                                                    ),
                                              )
                                              );
                                            
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
                                   child: Text("Looking up for Transactions...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                                 }catch(e){
                                   return Center(child: Text("An error occured...Check your internet connection"),);
                                 }
                                
                             })
            ],
          ),
        ),

      ),

      //ends transaction section

      //This section starts the announcement section
      SingleChildScrollView(
        child: Column(
          children: [
             
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("Announcements").snapshots(),
                               key: Key("announcements"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                try{
                                   if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),

                                            ),
                                            Text("Announcements cannot be loaded at the moment")
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
                                            Text("There are no Announcements yet")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                          
                                          Timestamp creationDate = snapshot.data!.docs[index].get("AnnouncementDate");
                                          DateTime convertedCreatedDate = DateTime.fromMicrosecondsSinceEpoch(creationDate.microsecondsSinceEpoch);
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(convertedCreatedDate.toString())),
                                                  ),

                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: TextFormField(
                                                        controller: TextEditingController(text: snapshot.data!.docs[index].get("Announcement")),
                                                        readOnly: true,
                                                        maxLines: 15,
                                                        keyboardType: TextInputType.multiline,


                                                      ),
                                                    )

                                                ],
                                              ),
                                            );
                                            
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
                                   child: Text("Looking up for Announcements...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                                }catch(e){
                                  return Center(child: Text("An error occured...Check your internet connection"),);
                                }
                                
                             })
                    )
          ],
        ),

      ),
      
      //This section ends the announcement section
    ];

    final bottomTabs = [
      //This section starts the Feed Section

      SingleChildScrollView(
        child: Column(
          children: [
             
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("Feeds").where("FeedStatus", isEqualTo: "Open").snapshots(),
                               key: Key("feeds"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                try{
                                   if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),
      
                                            ),
                                            Text("Feeds cannot be loaded at the moment")
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
                                            Text("There are no feeds yet")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){

                                            return GestureDetector(
                                              onTap: (){
                                                  if(snapshot.data!.docs[index].get("FeedType") == "Quick Post"){
                                                    navigateToDetailsQuickPosts(snapshot.data!.docs[index]);
                                                  }else if(snapshot.data!.docs[index].get("FeedType") == "Deal Connect"){
                                                      if(mounted){
                                                        setState(() {
                                                        _selectedIndexForBottomNavigationBar= 1;
                                                        color= Colors.lightBlueAccent;
                                                      });
                                                      }
                                                  }else if(snapshot.data!.docs[index].get("FeedType") == "Deal Share"){
                                                      if(mounted){
                                                        setState(() {
                                                        _selectedIndexForTabBar = 0;
                                                        color = Colors.black;
                                                      });
                                                      }
                                                  }else if(snapshot.data!.docs[index].get("FeedType") == "Announcement"){
                                                    if(mounted){
                                                      setState(() {
                                                        _selectedIndexForTabBar = 2;
                                                        color = Colors.purple;
                                                      });
                                                    }
      
                                                  }else if(snapshot.data!.docs[index].get("FeedType") == "Quick Post Comment"){
                                                      navigateToDetailsQuickPosts(snapshot.data!.docs[index]);
                                                  }else if(snapshot.data!.docs[index].get("FeedType") == "Quick Post Interest"){
                                                      navigateToDetailsQuickPosts(snapshot.data!.docs[index]);
                                                  }else{
                                                    //this is for transactions
                                                    if(mounted){
                                                      setState(() {
                                                        _selectedIndexForTabBar = 1;
                                                        color = Colors.brown;
                                                      });
                                                    }
                                                  }
                                              },
                                              child: ListTile(
                                                title: Text(snapshot.data!.docs[index].get("FeedCreatorName")+": "+snapshot.data!.docs[index].get("FeedTitle")
                                                , style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                leading: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: snapshot.data!.docs[index].get("FeedCreatorPics").isNotEmpty ?
                                                                    Image.network(
                                                                     snapshot.data!.docs[index].get("FeedCreatorPics"), width: 55,
                                                                      height: 100,
                                                                      fit: BoxFit.cover,
                                                                      ): CircularProgressIndicator(color: Colors.black,)
                                                
                                                ),
                                                subtitle: Text("Feed Category: "+snapshot.data!.docs[index].get("FeedType"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                              ),
                                            );
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
                                   child: Text("Looking up for feeds...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                                }catch(e){
                                  return Center(child: Text("An error ocurred...Check your internet connection"),);
                                }
                                
                             })
                    )
          ],
        ),
      ),
      //This section ends the feeds section



      //This section starts deal connects
      SingleChildScrollView(
        child: Column(
          children: [
             Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.business, size: 26, color: Colors.black),
                        label: Text("Create New Deal", style: TextStyle(color: Colors.black, fontSize: 13)),
                        onPressed: (){
                            //Navigate to createDealConnect File to create New deal
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDealConnect()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(color)
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("DealConnects").where("DealStatus", isEqualTo: "Open").snapshots(),
                               key: Key("dealConnects"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                try{
                                   if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                             if(snapshot.hasError){
                                return Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Icon(Icons.info, size: 45, color: Colors.black),

                                            ),
                                            Text("Deals cannot be loaded at the moment")
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
                                            Text("There are no deals yet")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){

                                         
                                          
                                            return GestureDetector(
                                              onTap: (){
                                                  navigateToDetailsForDealConnect(snapshot.data!.docs[index]);
                                              },
                                              child: ListTile(
                                                title: Text(snapshot.data!.docs[index].get("DealTitle"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                leading: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: snapshot.data!.docs[index].get("DealCreatorPics").isNotEmpty ?
                                                                    Image.network(
                                                                     snapshot.data!.docs[index].get("DealCreatorPics"), width: 55,
                                                                      height: 100,
                                                                      fit: BoxFit.cover,
                                                                      ): CircularProgressIndicator(color: Colors.black,)
                                                
                                                ),
                                                subtitle: Text(snapshot.data!.docs[index].get("NumberOfInvestors")+ " allowed to Invest", style: TextStyle(color: Colors.black, fontSize: 12,)),
                                              ),
                                            );
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
                                   child: Text("Looking up for deal connects...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                 ),
                                 
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20.0),
                                   child: CircularProgressIndicator(),
                                 ),
                               ],
                             ));
                                }catch(e){
                                  return Center(child: Text("An error occured...Check your Internet Connection"),);
                                }
                                
                             })
                    )
          ],
        ),

      ),


      //End of deal connects

      //This section starts Quick post
      SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Center(child: Text("Quick Post", style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0, bottom: 80),
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0, left: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: TextField(
                                  key: Key("quickPost"),
                                decoration: InputDecoration(
                                  
                                  labelText: "Send a Quick Post", 
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
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                controller: controllerQP,
                                autocorrect: true,
                                
                                //validate when you want to press button
                            ),
                              ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async{
                                  var hasInternet = await InternetConnectionChecker().hasConnection;
                                  if(hasInternet){
                                    ValidateDashboard().doQuickPost(controllerQP);
                                  }else{
                                    showSimpleNotification(
                                      Text("No Internet Connection"),
                                      background: Colors.red
                                      );
                                  }
                                  
                              }, 
                              icon: Icon(Icons.send)
                              ),
                          )
                            
                          ],
                        ),
                      ),
                    ],
                  )
                ),
            ),
            //This section ends Quick Post
      
      //Messages section starts from here

          Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ExpansionTile(
                          title: Text("Compose", style: TextStyle(color: Colors.black),),
                          leading: Icon(Icons.add_comment, color: Colors.black),
                          children: [
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        controller: controllerSubject,
                                        keyboardType: TextInputType.name,
                  
                                        decoration: InputDecoration(
                                          labelText: "Subject", 
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          fillColor: Colors.lightBlueAccent,
                                          focusColor: Colors.lightBlueAccent,
                                          hoverColor: Colors.lightBlueAccent,
                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                            
                                          ),
                                          ),
                                          
                                          validator: (value){
                                            
                                            if(value!.isEmpty){
                                              return 'Subject is required';
                                            }
                                            
                                            return null;
                                          },
                        
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        controller: controllerMessage,
                                        decoration: InputDecoration(
                                          labelText: "Message", 
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          fillColor: Colors.lightBlueAccent,
                                          focusColor: Colors.lightBlueAccent,
                                          hoverColor: Colors.lightBlueAccent,
                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                            
                                          ),
                                          ),
                                          maxLength: 500,
                                          maxLines: 5,
                                          keyboardType: TextInputType.multiline,
                                          autocorrect: true,
                                         validator: (value){
                                           if(value!.isEmpty){
                                              return 'Message is required';
                                            }
                                            
                                            return null;
                                         },
                        
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 0.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: ElevatedButton.icon(
                                          onPressed: ()async{
                                              if(formKey.currentState!.validate()){
                                                var hasInternet =  await InternetConnectionChecker().hasConnection;

                                                if(hasInternet){
                                                  ValidateDashboard().doSendMessages(controllerSubject, controllerMessage);
                                                }else{
                                                  showSimpleNotification(
                                                    Text("No Internet Connection"),
                                                    background: Colors.red
                                                    );
                                                }
                                                
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                              }
                                          }, 
                                          icon: Icon(Icons.send), 
                                          label: Text("Send"),
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
                                          ),
                                      )
                                    )
                                        ]
                                      )
                                    )
                                  ]
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ExpansionTile(
                          title: Text("Inbox", style: TextStyle(color: Colors.black),),
                          leading: Icon(Icons.inbox, color: Colors.black),
                          collapsedIconColor: Colors.deepPurple,
                          iconColor: Colors.deepPurple,
                          children: [
                             StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("MembersInbox").where("MessageReceiver", isEqualTo: auth.currentUser!.uid.toString()).snapshots(),
                               key: Key("inboxMessage"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                 try{
                                    if(snapshot.hasData){
                                   if(snapshot.hasError){
                                     return Card(
                                      elevation: 0,
                                      child: Text("We could not fetch your inbox at the moment"),
                                   );
                                   }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                            return GestureDetector(
                                              onTap: (){
                                                //Update read and always check if read before determining
                                                  showModalBottomSheet(
                                                    context: context, 
                                                    builder: (BuildContext bc){
                                                      return SafeArea(
                                                        child: ListTile(
                                                          title: Text(snapshot.data!.docs[index].get("MessageSubject"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                          subtitle: Text(snapshot.data!.docs[index].get("MessageContent"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                        )
                                                      );
                                                    }
                                                    );
                                              },
                                              child: ListTile(
                                                title: Padding(
                                                  padding: const EdgeInsets.only(top:10.0, bottom:5, left: 5, right: 5),
                                                  child: Container(
                                                    
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 30,
                                                    child: Text(snapshot.data!.docs[index].get("MessageSubject"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold /*Check if read before bolding */))),
                                                ),
                                                leading: Icon(Icons.message, size: 26, color: Colors.black),
                                              ),
                                            );
                                        }
                                        
                                        );
                                   }
                                 }else{
                                   return Card(
                                      elevation: 0,
                                      child: Text("No Messages has been received"),
                                   );
                                 }
                                 }catch(e){
                                   return Center(child: Text("An error occured....Check Your Internet Connection"),);
                                 }
                                
                             })
                          ]
                        ),
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ExpansionTile(
                          title: Text("Sent", style: TextStyle(color: Colors.black),),
                          leading: Icon(Icons.send_and_archive, color: Colors.black),
                          collapsedIconColor: Colors.deepPurple,
                          iconColor: Colors.deepPurple,
                          children: [
                             StreamBuilder(
                               stream: FirebaseFirestore.instance.collection("MembersSentMessages").where("MessageSender", isEqualTo: auth.currentUser!.uid.toString()).snapshots(),
                               key: Key("sentMessage"),
                               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                 try{
                                   if(snapshot.hasData){
                                   if(snapshot.hasError){
                                     return Card(
                                      elevation: 0,
                                      child: Text("We could not fetch your sent messages at the moment"),
                                   );
                                   }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                            return GestureDetector(
                                              onTap: (){
                                                  showModalBottomSheet(
                                                    context: context, 
                                                    builder: (BuildContext bc){
                                                      return SafeArea(
                                                        child: ListTile(
                                                          title: Text(snapshot.data!.docs[index].get("MessageSubject"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                          subtitle: Text(snapshot.data!.docs[index].get("MessageContent"), style: TextStyle(color: Colors.black, fontSize: 12,)),
                                                        )
                                                      );
                                                    }
                                                    );
                                              },
                                              child: ListTile(
                                                title: Padding(
                                                  padding: const EdgeInsets.only(top:10.0, bottom:5, left: 5, right: 5),
                                                  child: Container(
                                                    
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 30,
                                                    child: Text(snapshot.data!.docs[index].get("MessageSubject"), style: TextStyle(color: Colors.black, fontSize: 12,))),
                                                ),
                                                leading: Icon(Icons.message, size: 26, color: Colors.black),
                                              ),
                                            );
                                        }
                                        
                                        );
                                   }
                                 }else{
                                   return Card(
                                      elevation: 0,
                                      child: Text("No Messages has been sent"),
                                   );
                                 }
                                 }catch(e){
                                   return Center(child: Text("An error Occured...Check Your Internet Connection"),);
                                 }
                                
                             })
                          ]
                        ),
                      )
                    )
                  ],
                ),
              )
            ),

      //message section ends here

      
    ];

    return WillPopScope(
      key: Key("dashboard"),
      onWillPop: () async{
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Exit'),
                content: Text('Do you really want to exit'),
                actions: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () async{
                      Navigator.pop(c, true);
                      exit(0);
                    },
                  ),
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )
              
            );
            return false;
          },
      child: DefaultTabController(
            length: 3,
            child: Scaffold(
              drawer: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.redAccent,
                  child: Drawer(
                      elevation: 20,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                              color: color,
                              
                            ),
                            accountName: Text("INVESTOR/"+membershipId, style: TextStyle(fontSize: 13, color: Colors.white)),
                            accountEmail: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(membershipStatus+" Member",style: TextStyle(fontSize: 13, color: Colors.white),),
                                accountStatus == "Verified"? Row(
                                  children: [
                                    Expanded(child: Text("Verified",style: TextStyle(fontSize: 13, color: Colors.white),)),
                                    Icon(Icons.verified, color: Colors.green, size: 20),
                                  ],
                                )
                                : accountStatus == "In-Processing"? Row(
                                  children: [

                                    Icon(Icons.settings_applications, color: Colors.green, size: 20),
                                    Expanded(child: Text("Verification in Progress",style: TextStyle(fontSize: 13, color: Colors.white),)),
                                  ],
                                ): Expanded(
                                  
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(color),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyAccountScreen()));
                                    }, 
                                    child: Text("Verify Account")
                                    ),
                                )
                              ],
                            ),
                            currentAccountPicture: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 15)),
                            
                          ),
                          Container(
                            padding: EdgeInsets.zero,
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MembersProfileScreen()));
                              },
                              title: Text('Account Profile', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.person, color: Colors.white)
                            ),
                            
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>InterestedDealsScreen()));
                              },
                              title: Text('Interested Deals', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.save, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatedDealsScreen()));
                              },
                              title: Text('Created Deals', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.create, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SaveDealsScreen()));
                              },
                              title: Text('Saved Deals', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.create, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsScreen()));
                              },
                              title: Text('About Devclub', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.info, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MembersCategory()));
                              },
                              title: Text('Membership Category', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.category, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndCondition()));
                              },
                              title: Text('Terms & Conditions', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.rule, color: Colors.white)
                            ),
                          ),
                          Container(
                            color: color,
                            child: hasPaid ? null : ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPaymentPage()));
                              },
                              title: Text('Get Membership License', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.card_membership, color: Colors.white)
                            )
                          ),
                          Container(
                            color: color,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SupportRequest()));
                              },
                              title: Text('Request for Support', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.support, color: Colors.white)
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                            color: color,
                            child: ListTile(
                              onTap: () async{
                                showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: Text('Sign Out'),
                                    content: Text('Do you really want to Sign Out?'),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Yes'),
                                        onPressed: () async{
                                          Navigator.pop(c, true);
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PreAction()));
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('No'),
                                        onPressed: () => Navigator.pop(c, false),
                                      ),
                                    ],
                                  )
                                  
                                );
                              },
                              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.logout, color: Colors.white)
                            ),
                          ),
                          )
                        ],
                      ),
                  ),
                ),
              ),
                appBar: AppBar(
                    backgroundColor: color,
                    //toolbarHeight: 110,
                    actionsIconTheme: IconThemeData(
                    size: 30.0,
                    color: Colors.black,
                    opacity: 10.0
                  ),
                  bottom: tabBar,
                    title: Text("DevClub360", style: TextStyle(color: Colors.white, fontSize: 15,),),
                    actions: [
                      
                      
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton.icon(
                          label: Text("Profile"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(color),
                          ),
                          onPressed: () {
                            
                             Navigator.push(context, MaterialPageRoute(builder: (c0ntext)=>MembersProfileScreen()));
                          },
                          icon: Icon(
                              Icons.person, color: Colors.white, size: 26,
                          ),
                        ),
                      ),
                      
                    ],
              ),
              body: Container(child:_selectedIndexForTabBar == 0 ?
                bottomTabs.elementAt(_selectedIndexForBottomNavigationBar):
                topTabs.elementAt(_selectedIndexForTabBar - 1)),

                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(.1),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                      child: GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 8,
                        activeColor: Colors.black,
                        iconSize: 24,
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        duration: Duration(milliseconds: 400),
                        tabBackgroundColor: Colors.grey[100]!,
                        color: Colors.black,
                        tabs: [
                          GButton(
                            icon: Icons.feed_outlined,
                            text: 'Feeds '+(feedLength==0 ? "" : " ("+feedLength.toString()+")"),
                            
                          ),
                          GButton(
                            icon: Icons.business,
                            text: 'Deal Connect '+(dealConnectLength==0 ? "" : "("+dealConnectLength.toString()+")"),
                            
                          ),
                          GButton(
                            icon: Icons.post_add,
                            text: 'QP',
                            
                          ),
                          GButton(
                            icon: Icons.message_outlined,
                            text: 'Messages',
                          ),
                          
                        ],
                        selectedIndex: _selectedIndexForBottomNavigationBar,
                        onTabChange: (index) {
                           _onItemTappedForBottomNavigationBar(index);
                        },
                      ),
                    ),
                  ),
                ),
              
              
                ),
          ),
    );
  }

  navigateToDetailsForDealConnect(DocumentSnapshot deals) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DealConnectProjectScreen(deals: deals)));
  }

  navigateToDetailsQuickPosts(DocumentSnapshot posts) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>QuickPostPage(posts: posts)));
  }

  navigateToDetailsshowTransactionOwnersProfile(DocumentSnapshot profile) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionalProfile(profile: profile)));
  }

  navigateToDealShareProjects(DocumentSnapshot projects) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DealShareProjects(projects: projects)));
  }

}