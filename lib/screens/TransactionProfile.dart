import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/screens/ProfileForTransanctions.dart';
import 'package:flutter/material.dart';

class TransactionalProfile extends StatefulWidget {

  final DocumentSnapshot profile;

  TransactionalProfile({ required this.profile });

  @override
  _TransactionalProfileState createState() => _TransactionalProfileState();
}

class _TransactionalProfileState extends State<TransactionalProfile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Members Profile", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: StreamBuilder(
                                                          stream: FirebaseFirestore.instance.collection("MembersTransactions").doc(widget.profile.id).collection("MembersProfile").snapshots(),
                                                          key: Key("transactionsMembers"),
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
                                                                                    Text("Member's Profiles cannot be loaded at the moment")
                                                                                  ],
                                                                                ),
                                                                            );
                                                                    }else{
                                                                      if(snapshot.hasData){
                                                                          return ListView.builder(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            itemCount: snapshot.data!.docs.length,
                                                                            itemBuilder: (context, index){
                                                                                  return ListTile(
                                                                                    leading: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(50),
                                                                                          child: snapshot.data!.docs[index].get("MembersPicsUrl").isNotEmpty ?
                                                                                                        Image.network(
                                                                                                        snapshot.data!.docs[index].get("MembersPicsUrl"), width: 55,
                                                                                                          height: 100,
                                                                                                          fit: BoxFit.cover,
                                                                                                          ): CircularProgressIndicator(color: Colors.black,)
                                                                                    
                                                                                    ),
                                                                                    title: Text(snapshot.data!.docs[index].get("MembersName")),
                                                                                    trailing: TextButton(
                                                                                      onPressed: (){
                                                                                          navigateToDetailsshowTransactionOwnersProfile(snapshot.data!.docs[index]);
                                                                                      }, 
                                                                                      child: Text("View Profile")
                                                                                    )
                                                                                    
                                                                                  );
                                                                            }
                                                                          );
                                                                      }else{
                                                                        if(snapshot.data!.docs.length == 0){
                                                                          return Center(
                                                                          child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                                                child: Icon(Icons.info, size: 45, color: Colors.black),
                    
                                                                              ),
                                                                              Text("There are no members available in this transaction yet")
                                                                            ],
                                                                          ));
                                                                        }else{
                                                                          return Center(child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 50.0),
                                                                                child: Text("Looking up Members that pertook in this transaction...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                                                              ),
                                                                              
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 20.0),
                                                                                child: CircularProgressIndicator(),
                                                                              ),
                                                                            ],
                                                                          ));
                                                                        }
                                                                      }
                                                                    }
                                                              }else{
                                                                  return Center(child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 50.0),
                                                                                child: Text("Looking up Members that pertook in this transaction...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                                                              ),
                                                                              
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 20.0),
                                                                                child: CircularProgressIndicator(),
                                                                              ),
                                                                            ],
                                                                          ));
                                                                  }
                                                              }
                                                            )
                                                          ),
                                                           Divider(
                                                            height: 1,
                                                            thickness: 1,
                                                            color: Colors.red
                                                          )
            ],
          ),
        ),
      ),
    );
  }

  navigateToDetailsshowTransactionOwnersProfile(DocumentSnapshot transactions) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowMembersProfileForTrans(transactions: transactions)));
  }
}