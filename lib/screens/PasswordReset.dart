import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({ Key? key }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  
  static TextEditingController controllerForgotEmail = new TextEditingController();

  int _state = 0;

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          
        );
        
      }

      return widget;
      
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Form(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 2),
                child: Text("Reset Password", style: TextStyle(color: Colors.black, fontSize: 25),),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Divider(color: Colors.black, height: 2, thickness: 1,),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                              controller: controllerForgotEmail,
                              keyboardType: TextInputType.emailAddress,
                                
                                decoration: InputDecoration(
                                  labelText: "Your Email Address*", 
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
                                    return "Your Email Address is required";
                                  }
                                  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                    return "You have entered an invalid email address";
                                  }
                                  
    
                                  return null;
                                },
                               
                            ),
              ),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 500,
                              child: FloatingActionButton.extended(
                                onPressed: () async{
                                  var hasInternet = await InternetConnectionChecker().hasConnection;

                                  if(controllerForgotEmail.text.isNotEmpty && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controllerForgotEmail.text)){
                                        if(hasInternet){
                                          setState(() {
                                            _state = 1;
                                          });
                                          try{
                                              await FirebaseAuth.instance.sendPasswordResetEmail(email: controllerForgotEmail.text);
                                             await showSimpleNotification(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                        Expanded(child: Text("Password Link has been sent to "+controllerForgotEmail.text, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                      ],
                                                    ),
                                                    background: Colors.green,
                                                    duration: Duration(seconds: 5),
                                                    slideDismissDirection: DismissDirection.horizontal
                                                    );
                                                    
                                                    setState(() {
                                                      _state = 0;
                                                    });
                                                    Navigator.pop(context);
                                          }on FirebaseAuthException catch(e){
                                              print(e);
                                              setState(() {
                                                _state = 0;
                                              });
                                              if(e.code== "user-not-found"){
                                                  await showSimpleNotification(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                        Expanded(child: Text("Email Address not registered ", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                      ],
                                                    ),
                                                    background: Colors.red,
                                                    duration: Duration(seconds: 5),
                                                    slideDismissDirection: DismissDirection.horizontal
                                                    );
                                                    
                                                    setState(() {
                                                      _state = 0;
                                                    });
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Oops, error occured while generating password reset link"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                                setState(() {
                                                      _state = 0;
                                                    });
                                              }
                                            }

                                        }else{
                                          showSimpleNotification(
                                          Text("No Internet Connection"),
                                          background: Colors.red
                                          );
                                        }
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Valid Email Address is required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      setState(() {
                                            _state = 0;
                                          });
                                  }
                                }, 
                                label: setUpButtonChild()
                                ),
                            ),
                          )
            ],
          ),
        ),
      ),
    );
  }
}