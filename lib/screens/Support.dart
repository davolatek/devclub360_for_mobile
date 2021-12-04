import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class SupportRequest extends StatefulWidget {
  const SupportRequest({ Key? key }) : super(key: key);

  @override
  _SupportRequestState createState() => _SupportRequestState();
}

class _SupportRequestState extends State<SupportRequest> {
  @override

  void dispose(){
    super.dispose();
  }

  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerSubject = new TextEditingController();
  static TextEditingController controllerMessage = new TextEditingController();
  String department = "";
  int _state = 0;

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Submit Ticket",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new Text(
          "Submitting ticket....",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
        
      }

      return widget;
      
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support Ticket", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(child: Text("Raise a Support Ticket")),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Choose Department?", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 11), 
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
                        value: "Communications",
                        child: Text("Communications and Strategy")
                      ),
                      DropdownMenuItem<String>(
                        value: "Business and Projects",
                        child: Text("Business & Projects")
                      ),
                      DropdownMenuItem<String>(
                        value: "Membership and Support",
                        child: Text("Membership and Support")
                      ),
                   ],
                   onChanged: (value){
                      setState(() {
                        department = value.toString();
                      });
                   },
                   onSaved: (value){
                      setState(() {
                        department = value.toString();
                      });
                   },
                ),
                
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                        decoration: InputDecoration(
                          
                          labelText: "Support Subject", 
                          hintText: "Your Subject",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 11), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          
                          ),
                        
                        controller: controllerSubject,
                        validator: (value){
                          if(value!.isEmpty){
                              return "Subject is required";

                          }
                          return null;
                        }
                        //validate when you want to press button
                      ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                        decoration: InputDecoration(
                          
                          labelText: "Message", 
                          hintText: "Your Message",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 11), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          
                          ),
                      
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: controllerMessage,
                        validator: (value){
                          if(value!.isEmpty){
                              return "This field is required";

                          }
                          return null;
                        }
                        //validate when you want to press button
                      ),
              
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FloatingActionButton.extended(
                  onPressed: _state == 1 ? null : () async{
                      var hasInternet = await InternetConnectionChecker().hasConnection;

                      if(hasInternet){
                          if(formKey.currentState!.validate()){
                              if(department.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                              }else{
                                setState(() {
                                  _state = 1;
                                });
                                //actions

                                await ValidateDashboard().doSubmitSupportRequest(department, controllerSubject, controllerMessage);
                              
                                  setState(() {
                                  _state = 0;
                                });
                              }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));

                            setState(() {
                              _state = 0;
                            });
                          }
                      }else{
                        showSimpleNotification(Text("No Internet Connection"),background: Colors.red);
                      }
                  }, 
                  label: setUpButtonChild()
                  ),
              )
            )
          ],
        ),
      ),),
    );
  }
}