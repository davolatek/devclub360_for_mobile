import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QuickPostPage extends StatefulWidget {
  
  final DocumentSnapshot posts;

  QuickPostPage({required this.posts});

  @override
  _QuickPostPageState createState() => _QuickPostPageState();
}

class _QuickPostPageState extends State<QuickPostPage> {
  static TextEditingController controllerComments = new TextEditingController();
  static TextEditingController controllerInterests = new TextEditingController();
  String quickPostId ="", postedByID = "", postedByName = "", creatorPics="", creatorPost="";
  @override
  Widget build(BuildContext context) {
    
    setState(() {
      quickPostId = widget.posts.get("QuickPostId");
    });

    FirebaseFirestore.instance.collection("QuickPosts").doc(quickPostId).get()
    .then((docs){

      if(docs.exists){
        setState(() {
          postedByID = docs.get("PostedByID");
          creatorPics = docs.get("PostedByProfilePics");
          postedByName = docs.get("PostedByName");
          creatorPost = docs.get("Posts");
        });
      }

    });

    return Scaffold(
       appBar: AppBar(
        title: Text("Quick Posts", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        actions: [

            Padding(
             padding: EdgeInsets.only(left: 10),
             child: TextButton(
               onPressed: (){
                 showDialog(context: context, builder: (context)=>AlertDialog(
                   title: Text("Your Comment"),
                   content: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                        
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  
                                  labelText: "Comments", 
                                  hintText: "Your Comment",
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
                                controller: controllerComments,
                                autocorrect: true,
                                
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () async{
                                  await ValidateDashboard().doQuickComments(controllerComments, quickPostId);
                                  Navigator.pop(context);
                                }, 
                                icon: Icon(Icons.send)
                                ),
                            )
                        
                          ],
                        ),
                      ),
                 ));
               }, 
               child: Text("Comment", style: TextStyle(color: Colors.white, fontSize: 9),)
               ),
             
             ),
             Padding(
             padding: EdgeInsets.only(right: 10, left: 10),
             child: TextButton(
               onPressed: (){
                   showDialog(context: context, builder: (context)=>AlertDialog(
                   title: Text("What would be your offer to this quick post"),
                   content: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                        
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  
                                  labelText: "Your Offer?", 
                                  hintText: "Your Offer to this Post would be?",
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
                                controller: controllerInterests,
                                autocorrect: true,
                                
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () async{
                                  await ValidateDashboard().doShowInterest(controllerInterests, quickPostId, context);
                                  Navigator.pop(context);
                                }, 
                                icon: Icon(Icons.send)
                                ),
                            )
                        
                          ],
                        ),
                      ),
                 ));
               }, 
               child: Text("Show Interest", style: TextStyle(color: Colors.white, fontSize: 9),)
               ),
             
             ),
        ],
      ),
      body: SingleChildScrollView(child: 
        Container(
          
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              
              children: [
                Card(
                  elevation: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(100)
                          ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: creatorPics.isEmpty? CircularProgressIndicator():Image.network(creatorPics, fit: BoxFit.cover,))),
                      ),
                
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(creatorPost)
                        ),
                      ),
                
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("QuickPosts").doc(quickPostId).collection("Comments").snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done || snapshot.connectionState ==ConnectionState.waiting){
                            if(snapshot.hasError){
                              return Padding(
                                     padding: const EdgeInsets.only(top: 30.0),
                                     child: Text("Failed to Load comments", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                   );
                            }else{
                              if(snapshot.hasData){
                                if(snapshot.data!.docs.length == 0){
                                    return Padding(
                                        padding: const EdgeInsets.only(top: 50.0, right: 15),
                                        child: Text("There are no comments yet", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                                      );
                                  }else{
                                    
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index){
                                        Timestamp creationDate = snapshot.data!.docs[index].get("CommentDate");
                                            DateTime convertedCreatedDate = DateTime.fromMicrosecondsSinceEpoch(creationDate.microsecondsSinceEpoch);
                                        

                                        return Card(
                                          child: Column(
                                            children: [
                                              
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(snapshot.data!.docs[index].get("CommentorsID")== FirebaseAuth.instance.currentUser!.uid ? "You:" :snapshot.data!.docs[index].get("CommentorsName")+" :"),
                                                  Text(convertedCreatedDate.toString()),
                                                ],
                                              ),
                                              Text(snapshot.data!.docs[index].get("Comments")),
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
                                     child: Text("Looking up for comments...", style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic)),
                                   ),
                                   
                                   Padding(
                                     padding: const EdgeInsets.only(top: 20.0),
                                     child: CircularProgressIndicator(),
                                   ),
                                 ],
                               ));
                  
                    }),
                  )
                ),
                
              ],
            ),
          )
      )
    );
  }
}