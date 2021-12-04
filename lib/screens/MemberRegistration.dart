import 'dart:io';

import 'package:devclub360/connections/HandleMemberRegistration.dart';
import 'package:devclub360/screens/TermsAndConditions.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:password_strength/password_strength.dart';




class NewMemberRegistration extends StatefulWidget {
  const NewMemberRegistration({ Key? key }) : super(key: key);

  @override
  _NewMemberRegistrationState createState() => _NewMemberRegistrationState();
}


class _NewMemberRegistrationState extends State<NewMemberRegistration> {

  bool option = true, dealValue = false, tcValue= false, isChecked = false, personalValue = false, dealCloseValue = false, achievementValue= false, companyValue = false, verificationValue = false;
  String optionValue = "none";
  String assessment = "";
  int _state = 0;
  bool isClicked = false;
  static final dealFormKey = GlobalKey<FormState>();
  static final personalFormKey = GlobalKey<FormState>();
  static final achievementFormKey = GlobalKey<FormState>();
  static final companyFormKey = GlobalKey<FormState>();
  static TextEditingController yearlyTransactionWorth = new TextEditingController();
  static TextEditingController memberAchievement = new TextEditingController();
  static TextEditingController lastTransactionWorth = new TextEditingController();
  static TextEditingController controllerFirstName = new TextEditingController();
  static TextEditingController controllerLastName = new TextEditingController();
  static TextEditingController controllerEmail = new TextEditingController();
  static TextEditingController controllerPhone = new TextEditingController();
  static TextEditingController controllerHomeAddress = new TextEditingController();
  static TextEditingController controllerPassword = new TextEditingController();
  static TextEditingController controllerRPassword = new TextEditingController();
  static TextEditingController controllerLinkedIn = new TextEditingController();
  static TextEditingController achievement = new TextEditingController();
  static TextEditingController controllerCompanyName = new TextEditingController();
  static TextEditingController controllerCompanyWebsite = new TextEditingController();
  static TextEditingController controllerSecretary = new TextEditingController();
  static TextEditingController controllerCompanyEmail = new TextEditingController();
  static TextEditingController controllerNIN = new TextEditingController();
  static TextEditingController controllerPositionHeld = new TextEditingController();
  static TextEditingController controllerDriversLicense = new TextEditingController();
  static TextEditingController controllerVotersCard = new TextEditingController();
  static TextEditingController controllerCAC = new TextEditingController();
  static TextEditingController controllerTIN = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String img_path = "", error_text = "";
  List<dynamic> marketPlaceValue = [];
  List<dynamic> areaOfPractice = [];
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

   _imgFromCamera() async {
  var imgGallery = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(imgGallery!.path);
      img_path = imgGallery.path;
      
    });
}

_imgFromGallery() async {

  var imgGallery = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imgGallery!.path);
      img_path = imgGallery.path;
    });
}

void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Choose from Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Use your Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
}

Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Create Devclub360 Account",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          
        );
        
      }

      return widget;
      
    }

    Future<void> submit() async {

      await HandleNewMemberRegistration().signUpNewMembers(controllerEmail.text, controllerPassword.text, optionValue, yearlyTransactionWorth.text, lastTransactionWorth.text, memberAchievement.text,controllerFirstName.text, controllerLastName.text, controllerPhone.text, controllerHomeAddress.text, controllerLinkedIn.text, img_path, assessment, achievement.text, controllerCompanyName.text, controllerCompanyWebsite.text, marketPlaceValue, areaOfPractice, controllerSecretary.text, controllerCompanyEmail.text, 
      controllerNIN.text, controllerPositionHeld.text, controllerDriversLicense.text, controllerVotersCard.text, controllerCAC.text, controllerTIN.text, context);
    setState(() {
      _state= 0;
    });
    }
@override

void dispose(){
  super.dispose();
}
  @override

  void initState(){
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRATION", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            
            children: [
              
              Visibility(
                visible: option,
                child: Column(
      
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text("Select Your Category", style: TextStyle(color: Colors.black, fontSize: 15),),
                    ),
                  
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Divider(color: Colors.black, thickness: 1,),
                    ),
                    RadioButton(
                        description: "Investor",
                        value: "Investor",
                        groupValue: optionValue,
                        onChanged: (value){
                            setState(() {
                              optionValue = value.toString();
                            });
                            
                        } ,
                        activeColor: Colors.red,
                    ),
                    RadioButton(
                        description: "Estate Developer",
                        value: "Developer",
                        groupValue: optionValue,
                        onChanged: (value){
                            setState(() {
                              optionValue = value.toString();
                            });
                            
                        } ,
                        activeColor: Colors.red,
                    ), 
                     
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: optionValue =="none" ? null: (){
                              if(optionValue != "none"){
                                setState(() {
                                  option = false;
                                  dealValue = true;
                                  // _isLoading = false;
                                });
                                print(optionValue);
                              }
                          },
                          icon: Icon(Icons.next_plan), 
                          label: Text("Continue")
                          ),
                      ),
                    )
                  ],
                )
              ),
              Visibility(
                visible: dealValue,
                child: Form(
                  key: dealFormKey,
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("Your Transaction Turn Over", style: TextStyle(color: Colors.black, fontSize: 15),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Divider(color: Colors.black, thickness: 1,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: yearlyTransactionWorth,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Your Yearly Transaction Turn Over*", 
                              hintText: "Amount in US Dollars",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 9),
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
                                  return 'Your Yearly transaction worth is required';
                                }
                                return null;
                              },
                              
                            
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller:  lastTransactionWorth,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Your Last Project worth*", 
                                labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                                hintText: "Amount in US Dollars",
                                hintStyle: TextStyle(color: Colors.black, fontSize: 9),
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
                                    return 'Your Last Project Amount is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: memberAchievement,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: "Your Achievement*", 
                              hintText: "Not more than 1000 words",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 9),
                              labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              fillColor: Colors.lightBlueAccent,
                              focusColor: Colors.lightBlueAccent,
                              hoverColor: Colors.lightBlueAccent,
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                                
                              ),
                              ),
                              maxLength: 1000,
                              maxLines: 4,
                              autocorrect: true,
                              
                              
                                validator: (value){
                                
                                if(value!.isEmpty){
                                  return 'Your achievement is required';
                                }
                                return null;
                              },
                              
                            
                          ),
                        ),
                        
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: 200,
                              child: ElevatedButton.icon(
                                onPressed:  (){
                                    if(!dealFormKey.currentState!.validate()){
                                      return;
                                    }else{
                                      setState(() {
                                        dealValue = false;
                                        tcValue = true;
                                      });
                                    }
                                },
                                icon: Icon(Icons.next_plan), 
                                label: Text("Continue")
                                ),
                            ),
                          )
                      ],
                  ),
                ),
              ),
      
              Visibility(
                visible: tcValue,
                child: Column(
                  children: [
                    Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("Terms and Conditions", style: TextStyle(color: Colors.black, fontSize: 15),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Divider(color: Colors.black, thickness: 1,),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ElevatedButton.icon(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndCondition()));
                            }, 
                            icon: Icon(Icons.arrow_circle_up), 
                            label: Text("Terms & Conditions", style: TextStyle(color: Colors.white))
                            ),
                        ),
                        Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Text("Accept Terms and conditions", style: TextStyle(color: Colors.black, fontSize: 10)),
                            
                          ],
                            ),

                          ),
                      
                      Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: 200,
                              child: ElevatedButton.icon(
                                onPressed: !isChecked ? null: (){
                                   setState(() {
                                     tcValue = false;
                                     personalValue = true;
                                   });
                                },
                                icon: Icon(Icons.next_plan), 
                                label: Text("Continue")
                                ),
                            ),
                          )
                  ],
      
                ),
      
              ), 
              Visibility(
                visible: personalValue,
                child: Form(
                  key: personalFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                           Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("Personal Information", style: TextStyle(color: Colors.black, fontSize: 15),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Divider(color: Colors.black, thickness: 1,),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(top:10.0, bottom: 10),
                            child: _image != null ? 
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ): TextButton.icon(
                                onPressed: (){
                                  _showPicker(context);
                                }, 
                                icon: Icon(Icons.image_search, color: Colors.black,), 
                                label: Text("Tap to select Your Profile picture", style: TextStyle(color: Colors.black, fontSize: 10))
                                ) ,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: controllerFirstName,
                              keyboardType: TextInputType.name,
                              
                              decoration: InputDecoration(
                                labelText: "Your First Name*", 
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
                                    return 'Your First Name is required';
                                  }
                                  
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: controllerLastName,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Your Last Name*", 
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
                                    return 'Your Last Name is required';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  
                                },
                              
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: controllerEmail,
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
                                  onSaved: (value){
                                    controllerEmail.text = value!;
                                  },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: controllerPhone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Your Phone Number", 
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
                                      return 'Your Phone Number is required';
                                    }
                                    
                                    if (value.length < 11 || value.length >14){
                                      return 'Invalid phone Number';
                                    }
                                    
                                    return null;
                                  },
                                  
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                
                                child: TextFormField(
                                  controller: controllerHomeAddress,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    
                                    labelText: "Your Home Address", 
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
                                        return 'Your Home Address is required';
                                      }
                                      
                                      return null;
                                    },
                                    
                                ),
                              ),
                              Padding(
                                 padding: const EdgeInsets.all(10.0),
                                
                                child: TextFormField(
                                  controller: controllerLinkedIn,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    
                                    labelText: "Your LinkedIn Profile Url", 
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
                                        return 'Your LinkedIn Profile Url';
                                      }
                                      
                                      return null;
                                    },
                                    
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: controllerPassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Choose a Password", 
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
                                        return 'Password Field is required*';
                                      }
                                      double strength = estimatePasswordStrength(value);
                                      if (strength < 0.3) {
                                        return 'Your password is weak! Use combination of letters, symbols and nummbers';
                                      } else if(strength > 0.3 && strength < 0.6){
                                        return 'Your password is still not good enough! Use combination of letters, symbols and nummbers';
                                      }

                                      return null;
                                    },
                                    onSaved: (value){
                                      controllerPassword.text = value!;
                                    },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: controllerRPassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Retype Password*", 
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
                                        return 'Confirm Your password';
                                      }
                                      if(value != controllerPassword.text){
                                        return 'Password mismatch';
                                      }
                                      
                                      return null;
                                    },
                                ),
                                
                              ),

                               Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 200,
                                  child: ElevatedButton.icon(
                                    onPressed: (){
                                      if(personalFormKey.currentState!.validate()){
                                        if(_image != null){
                                            setState(() {
                                            personalValue = false;
                                            dealCloseValue = true;
                                          });
                                        }else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Picture required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                          }
                                        
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }
                                    },
                                    icon: Icon(Icons.next_plan), 
                                    label: Text("Continue")
                                    ),
                                ),
                              )
                        ],
                      ),
                    ),
                ),
              ),
              Visibility(
                visible: dealCloseValue,
                child: Column(
                    children:[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("How Much deal do you want to close on the DevClub360 within the next quarter?", style: TextStyle(color: Colors.black),)
                        ),
                        Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Deal To Close in next quarters?", 
                            labelStyle: TextStyle(color: Colors.black, fontSize: 9), 

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
                                value: "350,000-650,000",
                                child: Text("USD350K-USD650K")
                              ),
                              DropdownMenuItem<String>(
                                value: "700,000-1,000,000",
                                child: Text("USD700K-USD1M")
                              ),
                              DropdownMenuItem<String>(
                                value: "1,500,000-2,000,000",
                                child: Text("USD1.5M-USD2M")
                              ),
                              DropdownMenuItem<String>(
                                value: "Above 2,000,000",
                                child: Text("Above USD2M")
                              ),
                            ],
                            onChanged: (value){
                                setState(() {
                                  assessment = value!;
                                  
                                });
                            },
                            onSaved: (value){
                                setState(() {
                                  assessment = value!;
                                  
                                });
                                
                            },
                            validator: (value){
                              assessment = value!;
                              if(assessment.isEmpty){
                                return "Your Quarterly expectation is required";
                              }
                                return null;
                              
                            },
                        ),
                        ),
                        Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 200,
                                  child: ElevatedButton.icon(
                                    onPressed: assessment == "" ? null: (){
                                     if(assessment != ""){
                                        setState(() {
                                          dealCloseValue = false;
                                          achievementValue = true;
                                        });
                                     }
                                    },
                                    icon: Icon(Icons.next_plan), 
                                    label: Text("Continue")
                                    ),
                                ),
                              )
                    ]
                )
              ), 
              Visibility(
                visible: achievementValue,
                child: Form(
                  key: achievementFormKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("What do you hope to achieve from the Devclub360?", style: TextStyle(color: Colors.black),)
                        ),
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          
                          labelText: "Highlight What do you hope to achieve from the Devclub360", 
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
                        controller: achievement,
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
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 200,
                                  child: ElevatedButton.icon(
                                    onPressed: (){
                                     if(achievementFormKey.currentState!.validate()){
                                        setState(() {
                                        
                                          achievementValue = false;
                                          companyValue = false;
                                          verificationValue = true;
                                        });
                                     }
                                     
                                    },
                                    icon: Icon(Icons.next_plan), 
                                    label: Text("Continue")
                                    ),
                                ),
                              )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: verificationValue,
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Do you want to have a verified Devclub Account? Fill this section", style: TextStyle(color: Colors.black),)
                        ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Personal ID Verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                        ),
                        
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              labelText: "National Identity Number (Optional)", 
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
                              
                              labelText: "Driver's License(Optional)", 
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
                              
                              labelText: "Voter's Card (Optional)", 
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
                              
                              labelText: "CAC Registration Number (Optional)", 
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
                              
                              labelText: "Tax Identification Number (Optional)", 
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
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                verificationValue = false;
                                companyValue = true;
                              });
                            },
                            child: Text("Continue", style: TextStyle(color: Colors.white, fontSize: 12),)
                          )
                        )
                    ],
                  )
                )
              ),

              Visibility(
                visible: companyValue,
                child: Form(
                  key: companyFormKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("Company's Information", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                      controller: controllerCompanyName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Your Company's Name*", 
                        labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        fillColor: Colors.lightBlueAccent,
                        focusColor: Colors.lightBlueAccent,
                        hoverColor: Colors.lightBlueAccent,
                        prefixIcon: Icon(Icons.business_center),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                          
                        ),
                        ),
                        validator: (value){
                          
                          if(value!.isEmpty){
                            return 'Your Company Name is required';
                          }
                          return null;
                        },
                          
                        ),
                        
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                        controller: controllerCompanyWebsite,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: "Your Company's Website", 
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.link),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          ),
                          
                            
                          ),
                          
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                        controller: controllerPositionHeld,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: "Position Held*", 
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.link),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          ),
                          
                          validator: (value){
                          
                            if(value!.isEmpty){
                              return 'PositionHeld';
                            }
                            return null;
                          },
                        ),
                          
                      ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: MultiSelect(
                                //--------customization selection modal-----------
                                buttonBarColor: Colors.red,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                cancelButtonText: "Exit",
                                titleText: "Your Desired Market Area (Multiple options)",
                                searchBoxToolTipText: "Search through the options...",
                                titleTextColor: Colors.black,
                                selectIconColor: Colors.black,
                                checkBoxColor: Colors.blueAccent,
                                selectedOptionsInfoTextColor: Colors.black,
                                selectedOptionsInfoText: "Selected Desired Market Area (tap to remove)",
                                selectedOptionsBoxColor: Colors.green,
                                maxLengthIndicatorColor: Colors.black,
                                maxLength: 3, // optional
                                //--------end customization selection modal------------
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return error_text;
                                  }
                                  return null;
                                },
                                errorText: error_text,
                                dataSource: [
                                  {"name": "Algeria", "code": "Algeria"},
                                  {"name": "Angola", "code": "Angola"},
                                  {"name": "Benin", "code": "Benin"},
                                  {"name": "Burundi", "code": "Burundi"},
                                  {"name": "Cameroun", "code": "Cameroun"},
                                  {"name": "Cape Verde", "code": "Cape Verde"},
                                  {"name": "Egypt", "code": "Egypt"},
                                  {"name": "Europe", "code": "Europe"},
                                  {"name": "Ghana", "code": "Ghana"},
                                  {"name": "Ivory Coast", "code": "Ivory Coast"},
                                  {"name": "Kenya", "code": "Kenya"},
                                  {"name": "Liberia", "code": "Liberia"},
                                  {"name": "Mali", "code": "Mali"},
                                  {"name": "Morocco", "code": "Morroco"},
                                  {"name": "Nigeria", "code": "Nigeria"},
                                  {"name": "Senegal", "code": "Senegal"},
                                  {"name": "Sierra Leone", "code": "Sierra Leone"},
                                  {"name": "South Africa", "code": "South Africa"},
                                  {"name": "UAE", "code": "UAE"},
                                  {"name": "United Kingdom", "code": "United Kingdom"},
                                  {"name": "United States", "code": "United States"},
                                  {"name": "Zambia", "code": "Zambia"},
                                  {"name": "Zimbabwe", "code": "Zimbabwe"},
                                ],
                                textField: 'name',
                                valueField: 'code',
                                filterable: true,
                                required: true,
                                onSaved: (dynamic value) {
                                  
                                  marketPlaceValue = value;
                                  if(marketPlaceValue.length == 0){

                                    setState(() {
                                       error_text= "Please select one or more option(s)";
                                    });
                                      
                                  }else{
                                    setState(() {
                                       error_text= "";
                                    });
                                  }
                                  
                                },
                                
                                change: (dynamic value) {

                                  marketPlaceValue = value;
                                  if(marketPlaceValue.length == 0){

                                    setState(() {
                                       error_text= "Please select one or more option(s)";
                                    });
                                      
                                  }else{
                                    setState(() {
                                       error_text= "";
                                    });
                                  }
                                  
                                }),
                          )
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: MultiSelect(
                                //--------customization selection modal-----------
                                buttonBarColor: Colors.red,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                cancelButtonText: "Exit",
                                titleText: "Your Area of Practice (Multiple options)",
                                searchBoxToolTipText: "Search through the options...",
                                titleTextColor: Colors.black,
                                selectIconColor: Colors.black,
                                checkBoxColor: Colors.blueAccent,
                                selectedOptionsInfoTextColor: Colors.black,
                                selectedOptionsInfoText: "Selected Area of Practice (tap to remove)",
                                selectedOptionsBoxColor: Colors.green,
                                maxLengthIndicatorColor: Colors.black,
                                maxLength: 4, // optional
                                //--------end customization selection modal------------
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return error_text;
                                  }
                                  return null;
                                },
                                errorText: error_text,
                                dataSource: [
                                  {"name": "Investment", "code": "Investment"},
                                  {"name": "Tenant Representation", "code": "Tenant Representation"},
                                  {"name": "Brokerage Management", "code": "Brokerage Management"},
                                  {"name": "Land Sales and Acquisition", "code": "Land Sales and Acquisition"},
                                  {"name": "Building Construction", "code": "Building Construction"},
                                  {"name": "Architecture", "code": "Architecture"},
                                  {"name": "Chartered Surveyor", "code": "Chartered Surveyor"},
                                  {"name": "Distribution and Logistics", "code": "Distribution and Logistics"},
                                  {"name": "Equipment and Leasing", "code": "Eqipment and Leasing"},
                                  {"name": "Consulting", "code": "Consulting"},
                                  {"name": "General Contractor", "code": "General Contractor"}
                                ],
                                textField: 'name',
                                valueField: 'code',
                                filterable: true,
                                required: true,
                                onSaved: (dynamic value) {
                                  
                                  areaOfPractice = value;
                                  if(areaOfPractice.length==0){
                                    setState(() {
                                       error_text= "Please select one or more option(s)";
                                    });
                                  }else{
                                    setState(() {
                                       error_text= "";
                                    });
                                  }
                                  
                                },
                                
                                change: (dynamic value) {
                                  areaOfPractice = value;
                                  if(areaOfPractice.length==0){
                                    setState(() {
                                       error_text= "Please select one or more option(s)";
                                    });
                                  }else{
                                    setState(() {
                                       error_text= "";
                                    });
                                  }
                                  
                                }),
                          )
                          ),
                          SizedBox(height: 10),
                          Center(child: Text("PA/Secretary Information", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),)),
                          Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                        controller: controllerSecretary,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: "PA/Secretary Name", 
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.person_add),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          ),
                          validator: (value){
                            
                            if(value!.isEmpty){
                              return 'Your PA/Secretary Name is required';
                            }
                            return null;
                          },
                            
                          ),
                          
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                        controller: controllerCompanyEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Corporate Email Address", 
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          hintText: "Corporate Email Only",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.email),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          ),
                          validator: (value){
                            
                            if(value!.isEmpty){
                              return 'This Field is required';
                            }
                            if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                            return "You have entered an invalid email address";
                            }
                            
                            return null;
                          },
                            
                          ),
                          
                        ),
                     Container(
                        margin: EdgeInsets.only(top:10, bottom: 20),
                        width: 500,
                        child: FloatingActionButton.extended(
                          onPressed: isClicked 
                          ? null: () async {
                              var hasInternet = await InternetConnectionChecker().hasConnection;
                                    if(hasInternet == true){
                                        if(companyFormKey.currentState!.validate()){
                                            if(marketPlaceValue.isNotEmpty){
                                                if(areaOfPractice.isNotEmpty){
                                                      setState(() {
                                                        isClicked = true;
                                                        _state = 1;
                                                      });
                                                      //Proceed to store in database
                                                     await submit();
                                                      setState(() {
                                                        isClicked = true;
                                                        _state = 0;
                                                      });
                                                }else{
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select at least one Area of Practice"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                                  setState(() {
                                                        isClicked = false;
                                                        _state = 0;
                                                      });
                                                }
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select at least one Country of Market"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                              setState(() {
                                                        isClicked = false;
                                                        _state = 0;
                                                      });
                                            }
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                          setState(() {
                                                        isClicked = false;
                                                        _state = 0;
                                                      });
                                        }
                                        
                                    }else{
                                      showSimpleNotification(
                                        Text("No Internet Connection"),
                                        background: Colors.red
                                        );
                                        setState(() {
                                                        isClicked = false;
                                                        _state = 0;
                                                      });
                                    }

                        }, label: setUpButtonChild(), icon: Icon(Icons.save),
                        backgroundColor: Colors.redAccent,
                        ),
                      )
                    ],
                  )
                )
              ),
              
            ],
          ),
        ),
      )
      
    );
  }
}