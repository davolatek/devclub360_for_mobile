import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/nointernet.dart';
import 'package:devclub360/screens/AfterDealConnect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:overlay_support/overlay_support.dart';

class NewDealConnect extends StatefulWidget {
  const NewDealConnect({ Key? key }) : super(key: key);

  @override
  _NewDealConnectState createState() => _NewDealConnectState();
}

class _NewDealConnectState extends State<NewDealConnect> {
  bool showProjectInfo = true, showProjectOffer= false, showProjectOfferParameters = false;
  bool landIsTicked = false, fundingIsTicked = false, investorIsTicked= false, offTakersIsTicked= false;
  bool isChecked = false, isClicked = false, hasUploaded = false;
  List<dynamic> projectOffers =[];
  String preferredEquity = "", commonEquity = "", architecturalDesign = "",hotMoney= "", businessDesign = "", financialModel= "";
  final cloudinary = CloudinaryPublic('developerdavid', 'mwxqi5y2', cache: false);
  String landStructure ="", reclamation = "";
  String guaranteed = "";
  int _state = 0;
  static final projectFormKey = GlobalKey<FormState>();
  static final projectOfferFormKey = GlobalKey<FormState>();
  
  static final landFormKey = GlobalKey<FormState>();
  static final fundFormKey = GlobalKey<FormState>();
  static final investorFormKey = GlobalKey<FormState>();
  static final offTakersFormKey = GlobalKey<FormState>();
  static TextEditingController netOperatingCost = new TextEditingController();
  static TextEditingController netOperatingIncome = new TextEditingController();
  static TextEditingController overAllROI = new TextEditingController();
  static TextEditingController profitSharingRatio = new TextEditingController();
  static TextEditingController projectCompletion = new TextEditingController();
  static TextEditingController personalEquity = new TextEditingController();
  static TextEditingController controllerDealTitle = new TextEditingController();
  static TextEditingController controllerPartnersType = new TextEditingController();
  static TextEditingController controllerPartnersOffers = new TextEditingController();
  static TextEditingController noOfPartners = new TextEditingController();
  static final controllerLandSize = new TextEditingController();
  static final controllerLandLocation = new TextEditingController();
  static final controllerLandPrice = new TextEditingController();
  static final controllerLandTitle = new TextEditingController();
  static final controllerFundingAmount = new TextEditingController();
  static final controllerInvestorSum = new TextEditingController();
  static final controllerInvestorROI = new TextEditingController();
  static final controllerStructureType = new TextEditingController();
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
  List<Asset> images = <Asset>[];

  Future<void> updateFeeds(String dealConnectId, String title) async {


              await ValidateDashboard().sendEmail(
                name: firstName, 
                email: emailAddress, 
                subject: "Creation of "+title+" Currently Undergoing Review", 
                message: "Your Created Deal with the title "+title+" has been received and currently undergoing review. You will be contacted once the review has been completed, and this deal will be posted for Devclub members to connect with\n\n Thanks\n\n Keep using Devclub360\n\n"
              );
              await ValidateDashboard().sendEmail(
                name: "Devclub360", 
                email: "operations@devclub360.com", 
                subject: "Creation of "+title+" identified with ID '$dealConnectId' for Deal Connect Post", 
                message: "A Deal connect post with the title "+title+" has been created by $firstName $lastName with the email address $emailAddress."
              );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deal Created Successfully"),backgroundColor: Colors.greenAccent, duration: Duration(seconds: 5)));
               
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AfterDealConnectScreen()));
                
            
        }

  Widget setUpButtonChild(){
      if(_state==0){
       return new Text(
          "Save Project",
          style: TextStyle(color: Colors.white, fontSize: 14)
        );
      }else if(_state == 1){
        return new Text(
          "Creating deal....",
          style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)
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

  Widget Land(){
    return Form(
      key: landFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Land Offers", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.all(10),
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
            padding: EdgeInsets.all(10),
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
            padding: EdgeInsets.all(10),
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
            padding: EdgeInsets.all(10),
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
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      
                    ),
                    ),
                     validator: (value){
                      
                      if(value!.isEmpty){
                        return 'Your Land Title of document is required';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButtonFormField<String>(
              
                   decoration: InputDecoration(
                     labelText: "Any Structure on Land?", 
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
                           if(mounted){
                             setState(() {
                             landStructure = "";
                           });
                           }
                         }else{
                           if(mounted){
                             setState(() {
                             landStructure = value;
                           });
                           }
                         }
                     },
                     onSaved: (value){
                         if(value!.isEmpty){
                           if(mounted){
                             setState(() {
                             landStructure = "";
                           });
                           }
                         }else{
                           if(mounted){
                             setState(() {
                             landStructure = value;
                           });
                           }
                         }
                         
                         
                     },
                     
                 ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButtonFormField<String>(
              
                   decoration: InputDecoration(
                     labelText: "Is this Land from Reclamation?", 
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
                         value: "Yes",
                         child: Text("Yes")
                       ),
                       DropdownMenuItem<String>(
                         value: "No",
                         child: Text("No")
                       ),
                       
                     ],
                     onChanged: (value){
                         if(value!.isEmpty){
                           if(mounted){
                             setState(() {
                             reclamation = "";
                           });
                           }
                         }else{
                          if(mounted){
                             setState(() {
                                reclamation = value;
                              });
                            }
                          }
                     },
                     
                     
                 ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: controllerStructureType,
              keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Type of Structure you plan building on the land*",
                    hintText: "e.g Three stories building...Put None if you have no plans yet!", 
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
                        return 'Type of Structure you plan building on the land';
                      }
                      return null;
                    },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    if(mounted){
                      setState(() {
                        isChecked = value!;
                      });
                    }
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
            child: Center(child: Text("Funding Offers", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Amount you are investing", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold))
          ),
          Padding(
              padding: EdgeInsets.all(10),
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
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        
                      ),
                      ),
                       validator: (value){
                        
                        if(value!.isEmpty){
                          return 'Amount of Investment is required';
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
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Investors Offers", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Amount Investor is willing to Invest", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),)
          ),
          Padding(
              padding: EdgeInsets.all(10),
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
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          
                          labelText: "Expected Return on Investment", 
                          hintText: "What is your investor expecting as a Return on Investment, Not more than 500 words",
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
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Off-Takers Offers", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 2, thickness:1)
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Are your off-Takers Guranteed?", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold ))
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField<String>(
                     decoration: InputDecoration(
                       labelText: "Are your off-takers guranteed?", 
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
                             if(mounted){
                               setState(() {
                               guaranteed = "";
                             });
                             }
                           }else{
                             guaranteed = value;
                           }
                       },
                       
                       
                   ),
          ),
                 
        ],
      ),
    );
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

    FirebaseFirestore.instance.collection("Members")
      .doc(auth.currentUser!.uid).get()
      .then((DocumentSnapshot docs){
        if(docs.exists){
          
                  if(mounted){
                    setState(() {
                      firstName = docs.get("firstName");
                      lastName = docs.get("lastName");
                      emailAddress = docs.get("EmailAddress");
                      phoneNumber = docs.get("PhoneNumber");
                      address = docs.get("HomeAddress");
                      profileUrl = docs.get("ProfilePicsUrl");
                    });
                  }
 
          
        }
      }).catchError((error){
        print(error);
        
      });
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Deal", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              
              Visibility(
                visible: showProjectInfo,
                child: Form(
                  key: projectFormKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text("JOINT VENTURE DEALS- Project Information", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: controllerDealTitle,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Your Deal Title*",
                              hintText: "Give this deal a suitable title", 
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
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: netOperatingCost,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Net Operating Cost*", 
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
                                    return 'Net Operating Cost is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: netOperatingIncome,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Net Operating Income*", 
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
                                    return 'Net Operating Income is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: overAllROI,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "OverAll Return on Investment*", 
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
                                    return 'Overall ROI is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Preferred Equity Investor?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                            preferredEquity = value.toString();
                                          });
                                        }
                                    },
                                    onSaved: (value){
                                        if(mounted){
                                          setState(() {
                                            preferredEquity = value.toString();
                                          });
                                        }
                                        
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),

                        Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Common Equity Investor?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                          commonEquity = value.toString();
                                        });
                                        }
                                    },
                                    onSaved: (value){
                                        if(mounted){
                                          setState(() {
                                          commonEquity = value.toString();
                                        });
                                        }
                                        
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),

                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: profitSharingRatio,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Profit Sharing Ratio(Investor-Developer*", 
                                hintText: "30% Investor - 40% Developer",
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
                                    return 'Profit Sharing Ratio is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Architectural Design Ready?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                          architecturalDesign = value.toString();
                                        });
                                        }
                                    },
                                    onSaved: (value){
                                       if(mounted){
                                          setState(() {
                                          architecturalDesign = value.toString();
                                        });
                                       }
                                        
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Business Plan Ready?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                          businessDesign = value.toString();
                                        });
                                        }
                                    },
                                    onSaved: (value){
                                        if(mounted){
                                          setState(() {
                                          businessDesign = value.toString();
                                        });
                                        }
                                        
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Financial Model Ready?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                          financialModel = value.toString();
                                        });
                                        }
                                    },
                                    onSaved: (value){
                                        if(mounted){
                                          setState(() {
                                          financialModel = value.toString();
                                        });
                                        }
                                        
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: projectCompletion,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Project Completion Timeline*", 
                                hintText: "E.g Two years",
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
                                    return 'Project Completion Timeline is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: personalEquity,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Any Personal Equity*", 
                                hintText: "Quote in Percentage",
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
                                    return 'Personal Equity is required';
                                  }
                                  return null;
                                },
                                
                              
                            ),
                          ),
                          Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Any Hot Money?", 
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
                                        value: "Yes",
                                        child: Text("Yes")
                                      ),
                                      DropdownMenuItem<String>(
                                        value: "No",
                                        child: Text("No")
                                      ),
                                      
                                    ],
                                    onChanged: (value){
                                        if(mounted){
                                          setState(() {
                                          hotMoney = value.toString();
                                        });
                                        }
                                    },
                                    onSaved: (value){
                                       if(mounted){
                                          setState(() {
                                          hotMoney = value.toString();
                                        });
                                        }
                                    },
                                    
                                    
                                ),
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: (){
                                  if(projectFormKey.currentState!.validate()){
                                      if(preferredEquity.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Let the Members know if preffered equity is available"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else if(commonEquity.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Let the Members know if common equity is available"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else if(architecturalDesign.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Is Architectural design ready?"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else if(businessDesign.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Is Business Plan ready?"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else if(financialModel.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Is the financial model plan ready"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else if(hotMoney.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Any hot money?"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          showProjectInfo = false;
                                          showProjectOffer = true;
                                        });
                                        }
                                      }
                                  }else{
                                    return;
                                  }
                              }, 
                              child: Text("Continue", style: TextStyle(color: Colors.white),)
                            ),
                          ),
                        )
                          
                    ],
                  ),
                )
              ),
              Visibility(
                visible: showProjectOffer,
                child: Form(
                  key: projectOfferFormKey,
                  child: Column(
                    children: [
                      Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text("JOINT VENTURE DEALS- Your Project Offers", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(thickness: 1, height: 1, color: Colors.redAccent,)
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("What are you bringing into this Deal?", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                      padding: EdgeInsets.all(10),
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
                              if(mounted){
                                setState(() {
                                projectOffers = value;
                              });
                              }
                              if(value.toString().contains("Land")){
                                if(mounted){
                                  setState(() {
                                  landIsTicked = true;
                                });
                                }
                              }else{
                                if(mounted){
                                  setState(() {
                                  landIsTicked = false;
                                });
                                }
                              }
                              if(value.toString().contains("Funding")){
                                if(mounted){
                                  setState(() {
                                  fundingIsTicked = true;
                                });
                                }
                              }else{
                                if(mounted){
                                  setState(() {
                                  fundingIsTicked = false;
                                });
                                }
                              }
                              if(value.toString().contains("Investors")){
                                if(mounted){
                                  setState(() {
                                  investorIsTicked = true;
                                });
                                }
                              }else{
                                if(mounted){
                                  setState(() {
                                  investorIsTicked = false;
                                });
                                }
                              }
                              if(value.toString().contains("Off-Takers")){
                                if(mounted){
                                  setState(() {
                                  offTakersIsTicked = true;
                                });
                                }
                              }else{
                                if(mounted){
                                  setState(() {
                                  offTakersIsTicked = false;
                                });
                                }
                              }
                              
                              
                            },
                          ),
                      )
                      ),
                      Visibility(
                        visible: isClicked ?projectOffers.isEmpty ? true : false: false,
                        child: Text("This field is required", style: TextStyle(color: Colors.redAccent, fontSize: 9))),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("What type of Partners are you looking for?", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            
                            labelText: "What type of Partner(s) are you looking for", 
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
                          controller: controllerPartnersType,
                          autocorrect: true,
                          
                          //validate when you want to press button
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("What must your partner(s) bring to the Deal?", style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            
                            labelText: "What must your partner bring to the Deal?", 
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
                          controller: controllerPartnersOffers,
                          autocorrect: true,
                          
                          //validate when you want to press button
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Numbers of Partner(s) required for this Project", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                       Padding(
                        padding: EdgeInsets.all(10),
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            images.isEmpty ? 
                          TextButton.icon(
                              onPressed: loadAssets, 
                              icon: Icon(Icons.image_search, color: Colors.black,), 
                              label: Text("Tap to select intended project image(3 images))", style: TextStyle(color: Colors.black, fontSize: 10))
                              ) : Row(
                                children: [
                                  Text("Your Project related Images has been applied", style: TextStyle(color: Colors.black, fontSize: 10)),
                                  TextButton(
                                    onPressed: (){
                                      if(mounted){
                                        setState(() {
                                          offTakersIsTicked = false;
                                        });
                                      }
                                      

                                    }, 
                                    child: Text("Change", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    )
                                ],
                              )

                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: (){
                              if(mounted){
                                setState(() {
                                  offTakersIsTicked = false;
                                });
                              }
                              if(projectOfferFormKey.currentState!.validate()){
                                if(projectOffers.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Project Offer(s) is required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                }else{
                                  if(images.isEmpty || images.length < 3){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project Related Images are required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                  }else{
                                    if(controllerPartnersType.text.isEmpty || controllerPartnersOffers.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Type of Partners and your Partner's Offer is required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                                    }else{
                                      if(mounted){
                                        setState(() {
                                        showProjectOffer = false;
                                        showProjectOfferParameters = true;
                                      });
                                      }
                                    }
                                  }
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"),backgroundColor: Colors.redAccent, duration: Duration(seconds: 2)));
                              }
                            },
                            child: Text("Continue"),
                          ),
                        )
                      )
                    ],
                  ),
                )
              ),
              Visibility(
                visible: showProjectOfferParameters,
                child: Column(
                  children: [
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
                      padding: EdgeInsets.all(10),
                      child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                        var hasInternet = await InternetConnectionChecker().hasConnection;
                        if(hasInternet){
                            //validate form field
                            if(mounted){
                              setState((){
                                    isClicked = true;
                                  });
                            }
                            
                              //check if the deal offer is empty
                              
                                if(projectOffers.isNotEmpty){
                                    
                                    if(landIsTicked && !fundingIsTicked && !investorIsTicked && !offTakersIsTicked){
                                      if(landFormKey.currentState!.validate() && isChecked && landStructure != ""){
                                          if(mounted){
                                            setState(() {
                                            _state = 1;
                                          });
                                          }

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
                                                      "TypeOfStructurePlan": controllerStructureType.text,
                                                      "FreeFromReclamation": reclamation,
                                                      "TypeOfJointVenture": controllerPartnersType.text,
                                                      "JointPartnersOffer": controllerPartnersOffers.text,
                                                      "NumberOfInvestors": noOfPartners.text,
                                                      "DealCreatedBy": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                      "DealCreatorName": firstName+ " "+lastName,
                                                      "ProjectRelatedImages1": uploadedImages[0].secureUrl,
                                                      "ProjectRelatedImages2": uploadedImages[1].secureUrl,
                                                      "ProjectRelatedImages3": uploadedImages[2].secureUrl,
                                                      "DealCreatorPics": profileUrl.toString(),
                                                      "DealStatus": "Pending",
                                                      "NetOperatingCost": netOperatingCost.text,
                                                      "NetOperatingIncome": netOperatingIncome.text,
                                                      "OverAllROI": overAllROI.text,
                                                      "PrefferedEquityInvestor": preferredEquity,
                                                      "CommonEquityInvestor": commonEquity,
                                                      "ProfitSharingRatio": profitSharingRatio.text,
                                                      "ArchitecturalDesignReady": architecturalDesign,
                                                      "BusinessPlanReady": businessDesign,
                                                      "FinancialModelReady": financialModel,
                                                      "ProjectCompletionTimeLine": projectCompletion.text,
                                                      "AnyPersonalEquity": personalEquity.text,
                                                      "AnyHotMoney": hotMoney,
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      //add to feeds
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                              }else{
                                                if(mounted){
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                }
                                                  NoInternet();
                                              }

                                          }else{
                                            if(mounted){
                                              setState(() {
                                                    _state = 0;
                                                  });
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && fundingIsTicked && !offTakersIsTicked && !investorIsTicked){
                                      if(landFormKey.currentState!.validate() && fundFormKey.currentState!.validate() && landStructure != ""){
                                          if(mounted){
                                          setState(() {
                                          _state= 1;
                                        });
                                        }
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
                                                        "TypeOfStructurePlan": controllerStructureType.text,
                                                        "FreeFromReclamation": reclamation,
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
                                                        "DealStatus": "Pending",
                                                        "NetOperatingCost": netOperatingCost.text,
                                                        "NetOperatingIncome": netOperatingIncome.text,
                                                        "OverAllROI": overAllROI.text,
                                                        "PrefferedEquityInvestor": preferredEquity,
                                                        "CommonEquityInvestor": commonEquity,
                                                        "ProfitSharingRatio": profitSharingRatio.text,
                                                        "ArchitecturalDesignReady": architecturalDesign,
                                                        "BusinessPlanReady": businessDesign,
                                                        "FinancialModelReady": financialModel,
                                                        "ProjectCompletionTimeLine": projectCompletion.text,
                                                        "AnyPersonalEquity": personalEquity.text,
                                                        "AnyHotMoney": hotMoney,
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  if(mounted){
                                                    setState(() {
                                                    _state= 0;
                                                    });
                                                  }
                                                  NoInternet();
                                                }

                                          }else{
                                              if(mounted){
                                                  setState(() {
                                                  _state= 0;
                                                });
                                                }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && investorIsTicked && !fundingIsTicked && !offTakersIsTicked){
                                      if(landFormKey.currentState!.validate() && investorFormKey.currentState!.validate() && landStructure != ""){
                                          if(mounted){
                                          setState(() {
                                          _state= 1;
                                        });
                                        }
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
                                                        "TypeOfStructurePlan": controllerStructureType.text,
                                                        "FreeFromReclamation": reclamation,
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
                                                        "DealStatus": "Pending",
                                                        "NetOperatingCost": netOperatingCost.text,
                                                        "NetOperatingIncome": netOperatingIncome.text,
                                                        "OverAllROI": overAllROI.text,
                                                        "PrefferedEquityInvestor": preferredEquity,
                                                        "CommonEquityInvestor": commonEquity,
                                                        "ProfitSharingRatio": profitSharingRatio.text,
                                                        "ArchitecturalDesignReady": architecturalDesign,
                                                        "BusinessPlanReady": businessDesign,
                                                        "FinancialModelReady": financialModel,
                                                        "ProjectCompletionTimeLine": projectCompletion.text,
                                                        "AnyPersonalEquity": personalEquity.text,
                                                        "AnyHotMoney": hotMoney,
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                          updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                    }
                                                  NoInternet();
                                                }

                                          }else{
                                            if(mounted){
                                                setState(() {
                                                _state= 0;
                                              });
                                              }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(landIsTicked && offTakersIsTicked && !fundingIsTicked && !investorIsTicked){
                                      if(landFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate() && guaranteed != "" && landStructure != ""){
                                          if(mounted){
                                              setState(() {
                                              _state= 0;
                                            });
                                            }
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
                                                      "TypeOfStructurePlan": controllerStructureType.text,
                                                      "FreeFromReclamation": reclamation,
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
                                                      "DealStatus": "Pending",
                                                      "NetOperatingCost": netOperatingCost.text,
                                                      "NetOperatingIncome": netOperatingIncome.text,
                                                      "OverAllROI": overAllROI.text,
                                                      "PrefferedEquityInvestor": preferredEquity,
                                                      "CommonEquityInvestor": commonEquity,
                                                      "ProfitSharingRatio": profitSharingRatio.text,
                                                      "ArchitecturalDesignReady": architecturalDesign,
                                                      "BusinessPlanReady": businessDesign,
                                                      "FinancialModelReady": financialModel,
                                                      "ProjectCompletionTimeLine": projectCompletion.text,
                                                      "AnyPersonalEquity": personalEquity.text,
                                                      "AnyHotMoney": hotMoney,
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                    if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                    }
                                                  NoInternet();
                                                }

                                          }else{
                                            if(mounted){
                                              setState(() {
                                              _state= 0;
                                            });
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(fundingIsTicked && !landIsTicked && !investorIsTicked && !offTakersIsTicked){
                                      if(fundFormKey.currentState!.validate()){
                                          if(mounted){
                                              setState(() {
                                              _state= 1;
                                            });
                                            }
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
                                                        "DealStatus": "Pending",
                                                        "NetOperatingCost": netOperatingCost.text,
                                                        "NetOperatingIncome": netOperatingIncome.text,
                                                        "OverAllROI": overAllROI.text,
                                                        "PrefferedEquityInvestor": preferredEquity,
                                                        "CommonEquityInvestor": commonEquity,
                                                        "ProfitSharingRatio": profitSharingRatio.text,
                                                        "ArchitecturalDesignReady": architecturalDesign,
                                                        "BusinessPlanReady": businessDesign,
                                                        "FinancialModelReady": financialModel,
                                                        "ProjectCompletionTimeLine": projectCompletion.text,
                                                        "AnyPersonalEquity": personalEquity.text,
                                                        "AnyHotMoney": hotMoney,                                                        
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                    }
                                                  NoInternet();
                                                }
                                          }else{
                                            if(mounted){
                                                setState(() {
                                                _state= 0;
                                              });
                                              }
                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    } else if(fundingIsTicked && investorIsTicked && !landIsTicked && !offTakersIsTicked){
                                      if(fundFormKey.currentState!.validate() && investorFormKey.currentState!.validate()){
                                          if(mounted){
                                          setState(() {
                                              _state= 1;
                                            });
                                          }
                                          
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
                                                      "DealStatus": "Pending",
                                                      "NetOperatingCost": netOperatingCost.text,
                                                      "NetOperatingIncome": netOperatingIncome.text,
                                                      "OverAllROI": overAllROI.text,
                                                      "PrefferedEquityInvestor": preferredEquity,
                                                      "CommonEquityInvestor": commonEquity,
                                                      "ProfitSharingRatio": profitSharingRatio.text,
                                                      "ArchitecturalDesignReady": architecturalDesign,
                                                      "BusinessPlanReady": businessDesign,
                                                      "ProjectCompletionTimeLine": projectCompletion.text,
                                                      "AnyPersonalEquity": personalEquity.text,
                                                      "FinancialModelReady": financialModel,
                                                      "AnyHotMoney": hotMoney,
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  if(mounted){
                                                    setState(() {
                                                    _state= 0;
                                                  });
                                                  }
                                                  NoInternet();
                                                }
                                          }else{
                                            if(mounted){
                                                setState(() {
                                                _state= 0;
                                              });
                                              }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }

                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(fundingIsTicked && offTakersIsTicked && !landIsTicked && !investorIsTicked){
                                      if(fundFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate()){
                                          if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
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
                                                      "DealStatus": "Pending",
                                                      "NetOperatingCost": netOperatingCost.text,
                                                      "NetOperatingIncome": netOperatingIncome.text,
                                                      "OverAllROI": overAllROI.text,
                                                      "PrefferedEquityInvestor": preferredEquity,
                                                      "CommonEquityInvestor": commonEquity,
                                                      "ProfitSharingRatio": profitSharingRatio.text,
                                                      "ArchitecturalDesignReady": architecturalDesign,
                                                      "BusinessPlanReady": businessDesign,
                                                      "FinancialModelReady": financialModel,
                                                      "ProjectCompletionTimeLine": projectCompletion.text,
                                                      "AnyPersonalEquity": personalEquity.text,
                                                      "AnyHotMoney": hotMoney,
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  if(mounted){
                                                    setState(() {
                                                    _state= 0;
                                                  });
                                                  }
                                                  NoInternet();
                                                }
                                          }else{
                                            if(mounted){
                                              setState(() {
                                              _state= 0;
                                            });
                                            }
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(investorIsTicked && !fundingIsTicked && !landIsTicked && !offTakersIsTicked){
                                      if(investorFormKey.currentState!.validate()){
                                          if(mounted){
                                          setState(() {
                                          _state= 1;
                                        });
                                        }
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
                                                        "DealStatus": "Pending",
                                                        "NetOperatingCost": netOperatingCost.text,
                                                        "NetOperatingIncome": netOperatingIncome.text,
                                                        "OverAllROI": overAllROI.text,
                                                        "PrefferedEquityInvestor": preferredEquity,
                                                        "CommonEquityInvestor": commonEquity,
                                                        "ProfitSharingRatio": profitSharingRatio.text,
                                                        "ArchitecturalDesignReady": architecturalDesign,
                                                        "BusinessPlanReady": businessDesign,
                                                        "FinancialModelReady": financialModel,
                                                        "ProjectCompletionTimeLine": projectCompletion.text,
                                                        "AnyPersonalEquity": personalEquity.text,
                                                        "AnyHotMoney": hotMoney,
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  if(mounted){
                                                    setState(() {
                                                    _state= 0;
                                                  });
                                                  }
                                                }
                                          }else{
                                            if(mounted){
                                              setState(() {
                                              _state= 0;
                                            });
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(investorIsTicked && offTakersIsTicked && !landIsTicked && !fundingIsTicked){
                                      if(investorFormKey.currentState!.validate() && offTakersFormKey.currentState!.validate() && guaranteed !=""){
                                          if(mounted){
                                          setState(() {
                                          _state= 1;
                                        });
                                        }

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
                                                        "DealStatus": "Pending",
                                                        "NetOperatingCost": netOperatingCost.text,
                                                        "NetOperatingIncome": netOperatingIncome.text,
                                                        "OverAllROI": overAllROI.text,
                                                        "PrefferedEquityInvestor": preferredEquity,
                                                        "CommonEquityInvestor": commonEquity,
                                                        "ProfitSharingRatio": profitSharingRatio.text,
                                                        "ArchitecturalDesignReady": architecturalDesign,
                                                        "BusinessPlanReady": businessDesign,
                                                        "FinancialModelReady": financialModel,
                                                        "ProjectCompletionTimeLine": projectCompletion.text,
                                                        "AnyPersonalEquity": personalEquity.text,
                                                        "AnyHotMoney": hotMoney,
                                                        "createdAt": DateTime.now()

                                                      }).then((value){
                                                        updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                      }).catchError((error){
                                                        print(error);
                                                        NoInternet();
                                                      });
                                                }else{
                                                  if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                  }
                                                }
                                                }else{
                                                  if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                    }
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                                }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }else if(offTakersIsTicked && !landIsTicked && !fundingIsTicked && !investorIsTicked){
                                      if(offTakersFormKey.currentState!.validate()){
                                          if(mounted){
                                            setState(() {
                                            _state= 1;
                                          });
                                          }

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
                                                      "DealStatus": "Pending",
                                                      "NetOperatingCost": netOperatingCost.text,
                                                      "NetOperatingIncome": netOperatingIncome.text,
                                                      "OverAllROI": overAllROI.text,
                                                      "PrefferedEquityInvestor": preferredEquity,
                                                      "CommonEquityInvestor": commonEquity,
                                                      "ProfitSharingRatio": profitSharingRatio.text,
                                                      "ArchitecturalDesignReady": architecturalDesign,
                                                      "BusinessPlanReady": businessDesign,
                                                      "FinancialModelReady": financialModel,
                                                      "ProjectCompletionTimeLine": projectCompletion.text,
                                                      "AnyPersonalEquity": personalEquity.text,
                                                      "AnyHotMoney": hotMoney,
                                                      "createdAt": DateTime.now()

                                                    }).then((value){
                                                      updateFeeds(value.id.toString(), controllerDealTitle.text);
                                                    }).catchError((error){
                                                      print(error);
                                                      NoInternet();
                                                    });
                                                }else{
                                                  if(mounted){
                                                      setState(() {
                                                      _state= 0;
                                                    });
                                                    }
                                                }
                                          }else{
                                            if(mounted){
                                                setState(() {
                                                _state= 0;
                                              });
                                              }
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Three(3) Project related Images are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                          }
                                          
                                      }else{
                                        if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required"), duration: Duration(seconds: 3), backgroundColor: Colors.redAccent));
                                        
                                      }
                                    }
                                
                            }
                        }else{
                          if(mounted){
                                          setState(() {
                                          _state= 0;
                                        });
                                        }
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
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );

    
  }
  
}