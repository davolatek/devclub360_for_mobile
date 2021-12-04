import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({ Key? key }) : super(key: key);

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  
  static TextEditingController controllerTIN = new TextEditingController();
  static TextEditingController controllerNIN = new TextEditingController();
  static TextEditingController controllerDriversLicense = new TextEditingController();
  static TextEditingController controllerVotersCard = new TextEditingController();
  static TextEditingController controllerCAC = new TextEditingController();

  int _state = 0;

  Widget setUpButtonChild(){
      if(_state==0){
       return const Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return const Text(
          "processing",
          style: TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic)
        );
        
      }

      return widget;
      
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Verification", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
                padding: EdgeInsets.all(10), 
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1),
                    color: Colors.red
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.black, size: 26),
                      Expanded(child: Text("Important Notice! Do not submit this if you have once submitted", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child:  Text("Fill in this Form to complete your verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  child: Column(
                    children: [
                       Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text("Personal ID Verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),))
                        ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "National Identity Number", 
                              hintText: "NIN",
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
                            controller: controllerNIN,
                            
                          ),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "Driver's License", 
                              hintText: "Driver's License",
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              fillColor: Colors.black,
                              focusColor: Colors.lightBlueAccent,
                              hoverColor: Colors.lightBlueAccent,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                
                              ),
                              
                              ),
                            controller: controllerDriversLicense
                            
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "Voter's Card", 
                              hintText: "Voter's Card VIN",
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              fillColor: Colors.black,
                              focusColor: Colors.lightBlueAccent,
                              hoverColor: Colors.lightBlueAccent,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                
                              ),
                              
                              ),
                            controller: controllerVotersCard,
                            
                          ),
                        ),
                        
                        
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Business ID Verification", style: TextStyle(color: Colors.black),)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "CAC Registration Number", 
                              hintText: "CAC ID",
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              fillColor: Colors.black,
                              focusColor: Colors.lightBlueAccent,
                              hoverColor: Colors.lightBlueAccent,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                
                              ),
                              
                              ),
                            
                            controller: controllerCAC,
                            
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "Tax Identification Number", 
                              hintText: "TIN",
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              fillColor: Colors.black,
                              focusColor: Colors.lightBlueAccent,
                              hoverColor: Colors.lightBlueAccent,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                
                              ),
                              
                              ),
                            
                            controller: controllerTIN,
                            
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () async{
                                var hasInternet = await InternetConnectionChecker().hasConnection;

                                if(hasInternet){
                                  if(controllerCAC.text.isNotEmpty && controllerDriversLicense.text.isNotEmpty && controllerNIN.text.isNotEmpty && 
                                  controllerTIN.text.isNotEmpty && controllerVotersCard.text.isNotEmpty){
                                      FirebaseFirestore.instance.collection("Members").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        "CAC": controllerCAC.text,
                                        "DriversLicense": controllerDriversLicense.text,
                                        "NIN": controllerNIN.text,
                                        "TIN": controllerTIN.text,
                                        "VIN": controllerVotersCard.text,
                                        "AccountStatus": "In-Processing"
                                      }).then((value){
                                          //Notify member and admin about the update

                                          showDialog(
                                            barrierDismissible: false,
                                            context: context, 
                                            builder: (context)=> AlertDialog(
                                              insetPadding: EdgeInsets.all(10),
                                              title: Text("Submission Successful"),
                                              content: Text("Your Verification Document has been successfully received\n You will be notified once this verification process has been completed\n Keep Using Devclub360"),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                                                  }, 
                                                  child: Text("OK")
                                                )
                                              ],
                                            )
                                          );
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
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All Fields are required"),backgroundColor: Colors.red, duration: Duration(seconds: 4)));
                                  }
                                }else{
                                  setState(() {
                                      _state = 0;
                                    });
                                    showSimpleNotification(
                                      Text("No Internet Connection"),
                                      background: Colors.red
                                      );
                                }
                              }, 
                              child: setUpButtonChild()
                            ),
                          )
                        )
                    ],
                  ),
                )
              )
              
            ],
          ),
        ),
      )
    );
  }
}