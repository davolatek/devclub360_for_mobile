import 'package:devclub360/connections/HandleAccountSignIn.dart';
import 'package:devclub360/connections/HandleGoogleSignIn.dart';
import 'package:devclub360/screens/PasswordReset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class MemberShipSignIn extends StatefulWidget {
  const MemberShipSignIn({ Key? key }) : super(key: key);

  @override
  _MemberShipSignInState createState() => _MemberShipSignInState();
}

class _MemberShipSignInState extends State<MemberShipSignIn> {
  bool hasInternet = false;
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerEmail = new TextEditingController();
  static TextEditingController controllerPassword = new TextEditingController();
  int _state = 0;

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Sign In",
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
      appBar: AppBar(
        title: Text("SIGN IN", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                 Container(
                margin: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.9,
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    hasInternet = await InternetConnectionChecker().hasConnection;
                        if(hasInternet == true){
                           await  GoogleAuth().signInwithGoogle(context);
                        }else{
                          showSimpleNotification(
                            Text("No Internet Connection"),
                            background: Colors.red
                            );
                        }
                      }, 
                      
                    ),
                  ),
                  Form(
                 key: formKey,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     TextFormField(
                          controller: controllerEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Your Email Address*",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                            icon: Icon(Icons.mail),
                            
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
                        TextFormField(
                            controller: controllerPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Enter your Password*", 
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              icon: Icon(Icons.lock_rounded),
                              
                              
                              ),
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Password Field is required';
                              }

                                return null;
                            },
                            
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: FloatingActionButton.extended(
                              heroTag: "btn3",
                              onPressed: () async {

                                hasInternet = await InternetConnectionChecker().hasConnection;
                                if(hasInternet == true){
                                    if(formKey.currentState!.validate()) {
                                       if(mounted){
                                         setState(() {
                                         _state = 1;
                                       });
                                       }
                                        
                                        await HandleSignIn().HandleMemberSignIn(controllerEmail.text, controllerPassword.text, context);

                                        if(mounted){
                                         setState(() {
                                         _state = 0;
                                       });
                                       }

                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                      }
                                  }else{
                                    if(mounted){
                                      if(mounted){
                                         setState(() {
                                         _state = 1;
                                       });
                                       }
                                    }
                                    showSimpleNotification(
                                      Text("No Internet Connection"),
                                      background: Colors.red
                                      );
                                  }

                              
                            }, label: setUpButtonChild(), icon: Icon(Icons.filter),
                            backgroundColor: Colors.redAccent,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            
                            child: ElevatedButton(
                              
                              onPressed: () async{
                                hasInternet = await InternetConnectionChecker().hasConnection;
                                if(hasInternet == true){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
                                }else{
                                  showSimpleNotification(
                                    Text("No Internet Connection"),
                                    background: Colors.red
                                    );
                                }
                              }, 
                              child: Text("Forgot Password?"), 
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 14)),
                                foregroundColor: MaterialStateProperty.all(Colors.white),

                                
                              ),
                              
                              ) 
                              
                              ),
                   ],
                 ),
               )
              ]
            ),
          ),
        ),
      ),
    );
  }
}