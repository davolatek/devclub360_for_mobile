import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:devclub360/getstarted.dart';
import 'package:devclub360/screens/AboutUs.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:devclub360/screens/MemberSignIn.dart';


class PreAction extends StatefulWidget {
  

  @override
  _PreActionState createState() => _PreActionState();
}

class _PreActionState extends State<PreAction> {

 
  @override

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
            showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
                actions: [
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: (){
                      Navigator.pop(c, true);
                      exit(0);
                    },
                  ),
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              )
              
            );
            return false;
          },
          child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  autoplayDuration: Duration(seconds: 6),
                  showIndicator: false,
                  dotPosition: DotPosition.bottomCenter,
                  dotBgColor: Colors.black54,
                  dotSize: 4,
                  images: [
                     Stack(
                       children: [
                         Image.asset("assets/images/connections.jpg", fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.6,),
                         Align(
                           alignment: Alignment.bottomCenter,
                           child: Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text("Connections", style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 20
                             ),),
                             Padding(
                               padding: const EdgeInsets.all(5.0),
                               child: Text("Align yourself with Africa's most powerful CRE network", style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 13
                               ),),
                             ),
                             
                             ],
                           )
                           
                         )
                       ],
                     ),
                     Stack(
                       children: [
                         Image.asset("assets/images/real_estate.jpg", fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.6,),
                         Align(
                           alignment: Alignment.bottomCenter,
                           child: Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text("Real Estate Business", style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 20
                             ),),
                             Padding(
                               padding: const EdgeInsets.all(5.0),
                               child: Text("Close JV deals in Billions", style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 13
                               ),),
                             ),
                             
                             ],
                           ),
                           
                         )
                       ],
                     ),
                     Stack(
                       children: [
                         Image.asset("assets/images/lifestyle.jpg", fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.6,),
                         Align(
                          alignment: Alignment.bottomCenter,
                           child: 
                           ColoredBox(
                             color: Colors.black54,
                             child: Column(
                             
                             mainAxisAlignment: MainAxisAlignment.end,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Text("Lifestyle", style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold
                               ),),
                               Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: Text("Enjoy VIP meetings, hangouts with high networth friends, all from the DevClub", style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 13
                                 ),),
                               ),
                               
                               ],
                           ),
                           )
                           
                         )
                       ],
                     ),
                  ],
                  
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
                margin: EdgeInsets.only(bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: FloatingActionButton.extended(
                        
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStarted()));
                        }, 
                        label: Text("Get Started With DevClub"),
                        backgroundColor: Colors.redAccent
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 40),
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberShipSignIn()));
                        }, 
                        child: Text("Sign In", style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold

                        ),)
                        ),
                    ),
                   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsScreen()));
                      },
                      child: Text("About Devclub360", style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        //fontWeight: FontWeight.bold
                      ),),
                      ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: TextButton(
                  //     onPressed: (){},
                  //     child: Text("Get Help", style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 12,
                  //       //fontWeight: FontWeight.bold
                  //     ),),
                  //     ),
                  // ),
                ],
              )
                  ],
                  
                ),
              ),
            ],
          ),
        ),
        )
        
        
      ),
    );
  }
}
