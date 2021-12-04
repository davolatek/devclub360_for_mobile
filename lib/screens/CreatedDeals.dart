import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/screens/DealConnectProjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatedDealsScreen extends StatefulWidget {
  const CreatedDealsScreen({ Key? key }) : super(key: key);

  @override
  _CreatedDealsScreenState createState() => _CreatedDealsScreenState();
}

class _CreatedDealsScreenState extends State<CreatedDealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Created Deals", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text("Your Created Deals", style: TextStyle(color: Colors.black, fontSize: 12),),
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
                               stream: FirebaseFirestore.instance.collection("DealConnects").where("DealCreatedBy", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                               key: Key("createddeals"),
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
                                            Text("Created Deals cannot be loaded at the moment")
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
                                            Text("You have not created any deal")
                                          ],
                                        ),
                                    );
                                 }else{
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index){
                                          Timestamp creationDate = snapshot.data!.docs[index].get("createdAt");
                                          DateTime convertedCreatedDate = DateTime.fromMicrosecondsSinceEpoch(creationDate.microsecondsSinceEpoch);
                                          return ListTile(
                                            leading: Text((index+1).toString()),
                                            title: Text(snapshot.data!.docs[index].get("DealTitle"), style: TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text("Created On: "+ convertedCreatedDate.toString()),
                                            trailing: ElevatedButton(
                                              onPressed: (){
                                                navigateToDetailsForDealConnect(snapshot.data!.docs[index]);
                                              }, 
                                              child: Text("Details")
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
                                   child: Text("Looking up for Created Deals...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
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
      )
    );
  }
  navigateToDetailsForDealConnect(DocumentSnapshot deals) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DealConnectProjectScreen(deals: deals)));
  }
}