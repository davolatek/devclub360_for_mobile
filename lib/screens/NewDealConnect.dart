import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:devclub360/nointernet.dart';
import 'package:devclub360/notification/appNotification.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
//import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class CreateNewDealConnect extends StatefulWidget {
  const CreateNewDealConnect({ Key? key }) : super(key: key);

  @override
  _CreateNewDealConnectState createState() => _CreateNewDealConnectState();
}

class _CreateNewDealConnectState extends State<CreateNewDealConnect> {
  int _state = 0;
  String landStructure ="";
  String guaranteed = "";
  
  List<Asset> images = <Asset>[];
  FirebaseAuth auth = FirebaseAuth.instance;
  String status = "";
  String firstName = "";
  String lastName = "";
  String phoneNumber= "";
  String emailAddress = "";
  String address = "";
  String membershipId = "";
  String membershipStatus = "";
  String profileUrl ="";
  bool notAMember = false;
  
  
  

  static final formKey = GlobalKey<FormState>(debugLabel: "dashboard");
  static final landFormKey = GlobalKey<FormState>(debugLabel: "dashboard");
  static final fundFormKey = GlobalKey<FormState>(debugLabel: "dashboard");
  static final investorFormKey = GlobalKey<FormState>(debugLabel: "dashboard");
  static final offTakersFormKey = GlobalKey<FormState>(debugLabel: "dashboard");
  static final controllerDealTitle = new TextEditingController();
  static final controllerLandSize = new TextEditingController();
  static final controllerLandLocation = new TextEditingController();
  static final controllerLandPrice = new TextEditingController();
  static final controllerLandTitle = new TextEditingController();
  static final controllerPartnersType = new TextEditingController();
  static final controllerPartnersOffers = new TextEditingController();
  static final noOfPartners = new TextEditingController();
  static final controllerFundingAmount = new TextEditingController();
  static final controllerInvestorSum = new TextEditingController();
  static final controllerInvestorROI = new TextEditingController();
  List<dynamic> projectOffers =[];

  bool landIsTicked = false, fundingIsTicked = false, investorIsTicked= false, offTakersIsTicked= false;
  bool isChecked = false, isClicked = false, hasUploaded = false;
  final cloudinary = CloudinaryPublic('developerdavid', 'mwxqi5y2', cache: false);

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

  

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Post Deal",
          style: TextStyle(color: Colors.white, fontSize: 13)
        );
      }else if(_state == 1){
        return new Text(
          "Creating deal...",
          style: TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic)
        );
        
      }

      return widget;
      
    }

    Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Project Intended Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
     
    });

  }


  Widget Land(){
    return Form(
      key: landFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Land", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: controllerLandSize,
              keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Your Land Size*",
                    hintText: "e.g 648 sqm", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.confirmation_number),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Land Size is required';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: controllerLandLocation,
              keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: "Your Land Location*",
                    hintText: "e.g plot1234, saka tinubu, Victoria Island, Lagos", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.location_city),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Land Location is required';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: controllerLandPrice,
              keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Your Land Price Worth in dollars*",
                    hintText: "Price in Dollars", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.money),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Land Size is required';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: controllerLandTitle,
              keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Title of Document*",
                    hintText: "e.g Deed of Assignment", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.document_scanner),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Land Title is required';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: DropdownButtonFormField<String>(
              
                   decoration: InputDecoration(
                     labelText: "Any Structure on Land?", 
                     labelStyle: TextStyle(color: Colors.black, fontSize: 9), 

                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                     fillColor: Colors.lightBlueAccent,
                     focusColor: Colors.lightBlueAccent,
                     hoverColor: Colors.lightBlueAccent,
                     prefixIcon: Icon(Icons.check),
                     focusedBorder:OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                       
                     ),
                     ),
                     
                   
                     items: [
                       
                       DropdownMenuItem<String>(
                         value: "Structure on Land",
                         child: Text("Yes, Structure on Land")
                       ),
                       DropdownMenuItem<String>(
                         value: "No Structure on Land",
                         child: Text("No, No structure on Land")
                       ),
                       
                     ],
                     onChanged: (value){
                         if(value!.isEmpty){
                           setState(() {
                             landStructure = "";
                           });
                         }else{
                           setState(() {
                             landStructure = value;
                           });
                         }
                     },
                     onSaved: (value){
                         if(value!.isEmpty){
                           setState(() {
                             landStructure = "";
                           });
                         }else{
                           setState(() {
                             landStructure = value;
                           });
                         }
                         
                         
                     },
                     validator: (value){
                       if(value!.isEmpty){
                          return "This field is required since you are offering Land";
                       }
                       return null;
                       
                     },
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
                Text("Check to confirm if the land is free from encumbrance", style: TextStyle(color: Colors.black, fontSize: 10))
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget Funding(){
    return Form(
      key: fundFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Funding", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Amount you are investing", style: TextStyle(color: Colors.black, fontSize: 9))
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controllerFundingAmount,
                keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount of Investment in dollars*",
                      hintText: "Amount in Dollars", 
                      labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      fillColor: Colors.lightBlueAccent,
                      focusColor: Colors.lightBlueAccent,
                      hoverColor: Colors.lightBlueAccent,
                      prefixIcon: Icon(Icons.money),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        
                      ),
                      ),
                       validator: (value){
                        
                        if(value!.isEmpty){
                          return 'Your Land Size is required';
                        }
                        return null;
                      },
              ),
            ),
        ]
          
      ),
    );
  }
  Widget Investors(){
    return Form(
      key: investorFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Investors", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Amount Investor is willing to Invest", style: TextStyle(color: Colors.black, fontSize: 9),)
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: controllerInvestorSum,
                keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount of Investment by Investor in dollars*",
                      hintText: "Amount in Dollars", 
                      labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      fillColor: Colors.lightBlueAccent,
                      focusColor: Colors.lightBlueAccent,
                      hoverColor: Colors.lightBlueAccent,
                      prefixIcon: Icon(Icons.money),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        
                      ),
                      ),
                       validator: (value){
                        
                        if(value!.isEmpty){
                          return 'Your Investor Amount is required';
                        }
                        return null;
                      },
              ),
            ),
            Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          
                          labelText: "Expected Return on Investment", 
                          hintText: "What is your investor expecting as a Return on Investment, Not more than 500 words",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.business),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          
                          ),
                          
                        maxLength: 500,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: controllerInvestorROI,
                        autocorrect: true,
                        
                        //validate when you want to press button
                      ),
                    ),
        ],
      ),
    );
  }
  Widget OffTakers(){
    return Form(
      key: offTakersFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Off-Takers", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Are your off-Takers Guranteed?", style: TextStyle(color: Colors.black, fontSize: 9 ))
          ),
          DropdownButtonFormField<String>(
                   decoration: InputDecoration(
                     labelText: "Are your off-takers guranteed?", 
                     labelStyle: TextStyle(color: Colors.black, fontSize: 9), 

                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                     fillColor: Colors.lightBlueAccent,
                     focusColor: Colors.lightBlueAccent,
                     hoverColor: Colors.lightBlueAccent,
                     prefixIcon: Icon(Icons.select_all),
                     focusedBorder:OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                       
                     ),
                     ),
                     
                   
                     items: [
                       
                       DropdownMenuItem<String>(
                         value: "Guaranteed",
                         child: Text("Guaranteed")
                       ),
                       DropdownMenuItem<String>(
                         value: "Not Guaranteed",
                         child: Text("Not Guaranteed")
                       ),
                       
                     ],
                     onChanged: (value){
                         if(value!.isEmpty){
                           setState(() {
                             guaranteed = "";
                           });
                         }else{
                           guaranteed = value;
                         }
                     },
                     onSaved: (value){
                        if(value!.isEmpty){
                          setState(() {
                            guaranteed = "";
                          });
                        }else{
                          setState(() {
                            guaranteed = value;
                          });
                        }
                         
                     },
                     validator: (value){
                       if(value!.isEmpty){
                         return "This field is required";
                       }
                       return null;
                     },
                 ),
                 
        ],
      ),
    );
  }
  
  @override


  void dispose(){
    super.dispose();
    setState(() {
      firstName = "";
      lastName = "";
      emailAddress = "";
      phoneNumber = "";
      address = "";
      profileUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection("Members")
      .doc(auth.currentUser!.uid).get()
      .then((DocumentSnapshot docs){
        if(docs.exists){
          
                  setState(() {
                    firstName = docs.get("firstName");
                    lastName = docs.get("lastName");
                    emailAddress = docs.get("EmailAddress");
                    phoneNumber = docs.get("PhoneNumber");
                    address = docs.get("HomeAddress");
                    profileUrl = docs.get("ProfilePicsUrl");
                  });

          print(firstName + lastName + profileUrl);
            
          
        }
      }).catchError((error){
        print(error);
        NoInternet();
      });

  AwesomeNotifications().isNotificationAllowed().then((isAllowed){
    if(!isAllowed){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text("Allow Notification"),
          content: Text("DevClub360 will like to send you a notification"),
          actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Don't Allow", style: TextStyle(color: Colors.grey, fontSize: 18))
              ),
              TextButton(
                onPressed: (){
                  AwesomeNotifications().requestPermissionToSendNotifications().then((_){
                    Navigator.pop(context);
                  });
                },
                child: Text("Allow", style: TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold))
              ),
          ]
          
          )
      );
    }
  });

      Future<void> updateFeeds(String dealConnectId, String title) async {
          FirebaseFirestore.instance.collection("Feeds").doc()
            .set({
              "FeedType": "Deal Connect",
              "FeedCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
              "DealConnectID": dealConnectId,
              "FeedCreatorName": firstName + " "+lastName,
              "FeedCreatorPics": profileUrl,
              "FeedStatus": "Open",
              "FeedCreatedAt": FieldValue.serverTimestamp(),
              "FeedTitle": title

            }).then((error) async{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deal Created Successfully"),backgroundColor: Colors.greenAccent, duration: Duration(seconds: 5)));
                await createDealConnectNotification(title, 'A New Deal has been posted. Get it into your dashboard and invest');
               Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                
            }).catchError((error){
                print(error);
                NoInternet();
            });
        }
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Deals", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                        children: [
                          Center(child: Text("JOINT VENTURE DEALS", style: TextStyle(color: Colors.black, fontSize: 18))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 3,
                              thickness: 3,
                              color: Colors.black,
                            ),
                          )
                        ]  
                    )
                  ),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Give Your Deal a Suitable Title", style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
                 Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                  controller: controllerDealTitle,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Your Deal Title*", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.title),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Deal Title is required';
                      }
                      return null;
                    },
                      
                    ),
                    
                  ),
                  Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("What are you bringing to the Joint venture Deal", style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: MultiSelect(
                          //--------customization selection modal-----------
                          buttonBarColor: Colors.red,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cancelButtonText: "Exit",
                          titleText: "What do you have to offer",
                          searchBoxToolTipText: "Search through the options...",
                          titleTextColor: Colors.black,
                          selectIconColor: Colors.black,
                          checkBoxColor: Colors.blueAccent,
                          selectedOptionsInfoTextColor: Colors.black,
                          selectedOptionsInfoText: "Selected Desired offers",
                          selectedOptionsBoxColor: Colors.green,
                          maxLengthIndicatorColor: Colors.black,
                          maxLength: 2, // optional
                          //--------end customization selection modal------------
                          validator: (dynamic value) {
                            if (value == null) {
                              return "Your offer is required";
                            }
                            return null;
                          },
                          errorText: "Your offer is required",
                          dataSource: [
                            {"name": "Land", "code": "Land"},
                            {"name": "Funding", "code": "Funding"},
                            {"name": "Investors", "code": "Investors"},
                            {"name": "Off-Takers", "code": "Off-Takers"},
                            
                          ],
                          textField: 'name',
                          valueField: 'code',
                          filterable: true,
                          required: true,
                          onSaved: (dynamic value) {
                            setState(() {
                              projectOffers = value;
                            });
                            if(value.toString().contains("Land")){
                              setState(() {
                                landIsTicked = true;
                              });
                            }else{
                              setState(() {
                                landIsTicked = false;
                              });
                            }
                            if(value.toString().contains("Funding")){
                              setState(() {
                                fundingIsTicked = true;
                              });
                            }else{
                              setState(() {
                                fundingIsTicked = false;
                              });
                            }
                            if(value.toString().contains("Investors")){
                              setState(() {
                                investorIsTicked = true;
                              });
                            }else{
                              setState(() {
                                investorIsTicked = false;
                              });
                            }
                            if(value.toString().contains("Off-Takers")){
                              setState(() {
                                offTakersIsTicked = true;
                              });
                            }else{
                              setState(() {
                                offTakersIsTicked = false;
                              });
                            }
                            
                            
                          },
                          
                          change: (dynamic value) {
                            
                            
                          }),
                    )
                    ),
                     Visibility(
                 visible: isClicked ?projectOffers== "" ? true : false: false,
                 child: Text("This field is required", style: TextStyle(color: Colors.redAccent, fontSize: 9))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Visibility(
                        visible: landIsTicked,
                        child: Land(),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Visibility(
                        visible: fundingIsTicked,
                        child: Funding(),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Visibility(
                        visible: investorIsTicked,
                        child: Investors(),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Visibility(
                        visible: offTakersIsTicked,
                        child: OffTakers(),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("What type of Joint Ventures Partners are you looking for?", style: TextStyle(color: Colors.black, fontSize: 12)),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          
                          labelText: "What type of Joint Ventures Partners are you looking for", 
                          hintText: "Not More than 500 words",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.business),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          
                          ),
                          
                        maxLength: 500,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: controllerPartnersType,
                        autocorrect: true,
                        
                        //validate when you want to press button
                      ),
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("What must your partner bring to the Deal?", style: TextStyle(color: Colors.black, fontSize: 12)),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          
                          labelText: "What must your partner bring to the Deal?", 
                          hintText: "Not More than 500 words",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          focusColor: Colors.lightBlueAccent,
                          hoverColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.input),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            
                          ),
                          
                          ),
                          
                        maxLength: 500,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: controllerPartnersOffers,
                        autocorrect: true,
                        
                        //validate when you want to press button
                      ),
                    ),
                    Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Numbers of Partners required for this Project", style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
                Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: noOfPartners,
              keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Number of Partners*",
                    hintText: "Number of Partners required for the deal", 
                    labelStyle: TextStyle(color: Colors.black, fontSize: 9), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.lightBlueAccent,
                    focusColor: Colors.lightBlueAccent,
                    hoverColor: Colors.lightBlueAccent,
                    prefixIcon: Icon(Icons.money),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Number of Partners is required';
                      }
                      return null;
                    },
            ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      images.isEmpty ? 
                     TextButton.icon(
                        onPressed: loadAssets, 
                        icon: Icon(Icons.image_search, color: Colors.black,), 
                        label: Text("Tap to select intended project image( max 3)", style: TextStyle(color: Colors.black, fontSize: 10))
                        ) : Row(
                          children: [
                            Text("Your Project related Images has been applied", style: TextStyle(color: Colors.black, fontSize: 10)),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  images.clear();
                                  images = [];
                                });
                                

                              }, 
                              child: Text("Change", style: TextStyle(color: Colors.black, fontSize: 10)),
                              )
                          ],
                        )

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                        var hasInternet = await InternetConnectionChecker().hasConnection;
                        if(hasInternet){
                            //validate form field
                            setState((){
                                    isClicked = true;
                                  });
                            if(formKey.currentState!.validate()){
                              //check if the deal offer is empty
                              
                                if(projectOffers.isNotEmpty){
                                    
                                    if(landIsTicked && !fundingIsTicked && !investorIsTicked && !offTakersIsTicked){
                                      if(landFormKey.currentState!.validate() && isChecked && landStructure != ""){
                                          setState(() {
                                            _state = 1;
                                          });

                                          if(images.isNotEmpty && images.length==3){
                                            List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                              images
                                                  .map(
                                                    (image) => CloudinaryFile.fromFutureByteData(
                                                      image.getByteData(),
                                                      identifier: image.identifier,
                                                    ),
                                                  )
                                                  .toList(),
                                              );
                                              if(uploadedImages.isNotEmpty){
                                                  FirebaseFirestore.instance.collection("DealConnects")
                                                    .add({
                                                      "DealTitle": controllerDealTitle.text,
                                                      "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                      "LandSize": controllerLandSize.text,
                                                      "LandLocation": controllerLandLocation.text,
                                                      "LandPriceWorth": controllerLandPrice.text,
                                                      "TitleOfDocument": controllerLandTitle.text,
                                                      "StructureOnLand": landStructure,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealCreatorPics": profileUrl.toString(),
                                                      "DealStatus": "Open",
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      //add to feeds
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                              }else{
                                                setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                              }

                                          }else{
                                            setState(() {
                                                    _state = 0;
                                                  });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && fundingIsTicked && !offTakersIsTicked && !investorIsTicked){
                                      if(landFormKey.currentState!.validate() && fundFormKey.currentState!.validate() && landStructure != ""){
                                          setState(() {
                                            _state = 1;
                                          });
                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                      .add({
                                                        "DealTitle": controllerDealTitle.text,
                                                        "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                        "LandSize": controllerLandSize.text,
                                                        "LandLocation": controllerLandLocation.text,
                                                        "LandPriceWorth": controllerLandPrice.text,
                                                        "TitleOfDocument": controllerLandTitle.text,
                                                        "StructureOnLand": landStructure,
                                                        "AmountOfInvestment": controllerFundingAmount.text,
                                                        "TypeOfJointVenture": controllerPartnersType.text,
                                                        "JointPartnersOffer": controllerPartnersOffers.text,
                                                        "NumberOfInvestors": noOfPartners.text,
                                                        "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                        "DealCreatorName": firstName+ " "+lastName,
                                                        "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                        "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                        "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                        "DealCreatorPics": profileUrl,
                                                        "DealStatus": "Open",
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                }

                                          }else{
                                              setState(() {
                                                    _state = 0;
                                                  });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && investorIsTicked && !fundingIsTicked && !offTakersIsTicked){
                                      if(landFormKey.currentState!.validate() && investorFormKey.currentState!.validate() && landStructure != ""){
                                          setState(() {
                                            _state = 1;
                                          });
                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                      .add({
                                                        "DealTitle": controllerDealTitle.text,
                                                        "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                        "LandSize": controllerLandSize.text,
                                                        "LandLocation": controllerLandLocation.text,
                                                        "LandPriceWorth": controllerLandPrice.text,
                                                        "TitleOfDocument": controllerLandTitle.text,
                                                        "StructureOnLand": landStructure,
                                                        "AmountOfInvestmentByInvestor": controllerInvestorSum.text,
                                                        "InvestmentExpectedROI": controllerInvestorROI.text,
                                                        "TypeOfJointVenture": controllerPartnersType.text,
                                                        "JointPartnersOffer": controllerPartnersOffers.text,
                                                        "NumberOfInvestors": noOfPartners.text,
                                                        "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                        "DealCreatorName": firstName+ " "+lastName,
                                                        "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                        "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                        "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                        "DealCreatorPics": profileUrl,
                                                        "DealStatus": "Open",
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                          updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  setState(() {
                                                    _state= 0;
                                                  });
                                                  NoInternet();
                                                }

                                          }else{
                                            setState(() {
                                                    _state = 0;
                                                  });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && offTakersIsTicked && !fundingIsTicked && !investorIsTicked){
                                      if(landFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate() && guaranteed != "" && landStructure != ""){
                                          setState(() {
                                            _state = 1;
                                          });
                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                    .add({
                                                      "DealTitle": controllerDealTitle.text,
                                                      "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                      "LandSize": controllerLandSize.text,
                                                      "LandLocation": controllerLandLocation.text,
                                                      "LandPriceWorth": controllerLandPrice.text,
                                                      "TitleOfDocument": controllerLandTitle.text,
                                                      "StructureOnLand": landStructure,
                                                      "GuaranteedOffTakers": guaranteed,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealCreatorPics": profileUrl,
                                                      "DealStatus": "Open",
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                    setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                }

                                          }else{
                                            setState(() {
                                                    _state = 0;
                                                  });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(fundingIsTicked && !landIsTicked && !investorIsTicked && !offTakersIsTicked){
                                      if(fundFormKey.currentState!.validate()){
                                          setState(() {
                                            _state = 1;
                                          });
                                          if(images.isNotEmpty && images.length == 3){
                                             List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                      .add({
                                                        "DealTitle": controllerDealTitle.text,
                                                        "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                        "AmountOfInvestment": controllerFundingAmount.text,
                                                        "TypeOfJointVenture": controllerPartnersType.text,
                                                        "JointPartnersOffer": controllerPartnersOffers.text,
                                                        "NumberOfInvestors": noOfPartners.text,
                                                        "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                        "DealCreatorName": firstName+ " "+lastName,
                                                        "DealCreatorPics": profileUrl,
                                                        "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                        "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                        "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                        "DealStatus": "Open",                                                        
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                }
                                          }else{
                                            setState(() {
                                              _state = 0;
                                            });
                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    } else if(fundingIsTicked && investorIsTicked && !landIsTicked && !offTakersIsTicked){
                                      if(fundFormKey.currentState!.validate() && investorFormKey.currentState!.validate()){
                                          setState(() {
                                            _state = 1;
                                          });
                                          
                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                print(uploadedImages[0].secureUrl);
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                    .add({
                                                      "DealTitle": controllerDealTitle.text,
                                                      "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                      "AmountOfInvestmentByInvestor": controllerInvestorSum.text,
                                                      "InvestmentExpectedROI": controllerInvestorROI.text,
                                                      "AmountOfInvestment": controllerFundingAmount.text,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "DealCreatorPics": profileUrl,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealStatus": "Open",
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                }
                                          }else{
                                            setState(() {
                                              _state = 0;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }

                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(fundingIsTicked && offTakersIsTicked && !landIsTicked && !investorIsTicked){
                                      if(fundFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate()){
                                          setState(() {
                                            _state = 1;
                                          });
                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                    .add({
                                                      "DealTitle": controllerDealTitle.text,
                                                      "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                      "AmountOfInvestment": controllerFundingAmount.text,
                                                      "GuaranteedOffTakers": guaranteed,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "DealCreatorPics": profileUrl,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealStatus": "Open",
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  setState(() {
                                                    _state =0;
                                                  });
                                                  NoInternet();
                                                }
                                          }else{
                                            setState(() {
                                              _state = 0;
                                            });
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(investorIsTicked && !fundingIsTicked && !landIsTicked && !offTakersIsTicked){
                                      if(investorFormKey.currentState!.validate()){
                                          setState(() {
                                            _state = 1;
                                          });

                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );

                                                if(uploadedImages.isNotEmpty){
                                                      FirebaseFirestore.instance.collection("DealConnects")
                                                      .add({
                                                        "DealTitle": controllerDealTitle.text,
                                                        "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                        "GuaranteedOffTakers": guaranteed,
                                                        "TypeOfJointVenture": controllerPartnersType.text,
                                                        "JointPartnersOffer": controllerPartnersOffers.text,
                                                        "NumberOfInvestors": noOfPartners.text,
                                                        "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                        "DealCreatorName": firstName+ " "+lastName,
                                                        "DealCreatorPics": profileUrl,
                                                        "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                        "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                        "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                        "DealStatus": "Open",
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                    NoInternet();
                                                  });
                                                }
                                          }else{
                                            setState((){
                                              _state = 0;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(investorIsTicked && offTakersIsTicked && !landIsTicked && !fundingIsTicked){
                                      if(investorFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate() && guaranteed !=""){
                                          setState(() {
                                            _state = 1;
                                          });

                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );
                                                if(uploadedImages.isNotEmpty){
                                                      FirebaseFirestore.instance.collection("DealConnects")
                                                      .add({
                                                        "DealTitle": controllerDealTitle.text,
                                                        "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                        "AmountOfInvestmentByInvestor": controllerInvestorSum.text,
                                                        "InvestmentExpectedROI": controllerInvestorROI.text,
                                                        "GuaranteedOffTakers": guaranteed,
                                                        "TypeOfJointVenture": controllerPartnersType.text,
                                                        "JointPartnersOffer": controllerPartnersOffers.text,
                                                        "NumberOfInvestors": noOfPartners.text,
                                                        "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                        "DealCreatorName": firstName+ " "+lastName,
                                                        "DealCreatorPics": profileUrl,
                                                        "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                        "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                        "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                        "DealStatus": "Open",
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                      }
                                                }else{
                                                  setState(() {
                                                    _state =0;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                                }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(offTakersIsTicked && !landIsTicked && !fundingIsTicked && !investorIsTicked){
                                      if(offTakersFormKey.currentState!.validate()){
                                          setState(() {
                                            _state = 1;
                                          });

                                          if(images.isNotEmpty && images.length == 3){
                                              List<CloudinaryResponse> uploadedImages = await cloudinary.multiUpload(
                                                images
                                                    .map(
                                                      (image) => CloudinaryFile.fromFutureByteData(
                                                        image.getByteData(),
                                                        identifier: image.identifier,
                                                      ),
                                                    )
                                                    .toList(),
                                                );

                                                if(uploadedImages.isNotEmpty){
                                                    FirebaseFirestore.instance.collection("DealConnects")
                                                    .add({
                                                      "DealTitle": controllerDealTitle.text,
                                                      "DealCreatorOffers": FieldValue.arrayUnion(projectOffers),
                                                      "GuaranteedOffTakers": guaranteed,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "DealCreatorPics": profileUrl,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealStatus": "Open",
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  setState((){
                                                    _state = 0;
                                                  });
                                                  NoInternet();
                                                }
                                          }else{
                                            setState(() {
                                              _state =0;
                                            });
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        setState(() {
                                          _state= 0;
                                        });
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }
                                }else{
                                  setState(() {
                                    _state =0;
                                  });
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                }
                            }
                        }else{
                          setState(() {
                            _state=0;
                          });
                          showSimpleNotification(
                                      Text("No Internet Connection"),
                                      background: Colors.red
                                      );
                        }
                    }, 
                    icon: Icon(Icons.create), 
                    label: setUpButtonChild(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                    ),

                    ),
                )
                  
              ],
            ),
      
          ),
        ),
      ),
    );
  }
}