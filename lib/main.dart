
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/connections/DashBoardValidation.dart';
import 'package:devclub360/screens/AwaitingConfirmation.dart';
import 'package:devclub360/screens/MemberDashBoard.dart';
import 'package:devclub360/screens/TrialPeriodPage.dart';
import 'package:devclub360/screens/Verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:devclub360/preaction.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/res_notification_app_icon',
  [
    NotificationChannel(
    channelKey: 'basic_channel',
    channelName: 'Notification From Devclub360',
    defaultColor: Colors.teal,
    importance: NotificationImportance.High,
    channelShowBadge: true
    
    )
    
    ]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) async{
      ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        body: Container(
          child: Center(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Loading...", style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold ))
              ],
            ),
          ),
        ),
      );
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      runApp(new MyApp());
    });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  AwesomeNotifications().createNotificationFromJsonData(message.data);

}

class MyApp extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) =>OverlaySupport.global(
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Devclub360",
        theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme
        ).apply(
          bodyColor: Colors.black
        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
        home: LandingPage(),
      )
  
  );
  
}

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String accountStatus = "";
  late FirebaseMessaging messaging;

  @override
  void initState() {
    _getThingsOnStartup().then((value) async{
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      FirebaseMessaging.onMessage.listen((message) {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      });

      FirebaseMessaging.instance.getInitialMessage().then((message){
        if(message != null){
          AwesomeNotifications().createNotificationFromJsonData(message.data);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      });
      if(user == null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PreAction()));
      }else{
        if(user.emailVerified){
            await FirebaseFirestore.instance.collection("Members").doc(auth.currentUser!.uid).get()
                .then((DocumentSnapshot docs) async{
                  accountStatus = await docs.get("AccountStatus");
                }).catchError((error) async{
                  await showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error, size: 20, color: Colors.white,),
                                          Expanded(child: Text("An Internal error has occured", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                        ],
                                      ),
                                      background: Colors.red,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                                      
                                  exit(0);
                    });

                if(accountStatus == "Pending"){
                showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Text("Account Awaiting Approval", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountAwaitingConfirmation()));
            }else if(accountStatus== "Suspended" || accountStatus == "Terminated"){
              showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Text("Account Currently deactivated", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountAwaitingConfirmation()));
            }else if(accountStatus== "Active On Payment Confirmation"){
              showSimpleNotification(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                          Expanded(child: Text("Account Awaiting Payment Confirmation", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                        ],
                                      ),
                                      background: Colors.green,
                                      duration: Duration(seconds: 5),
                                      slideDismissDirection: DismissDirection.horizontal
                                      );
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountAwaitingConfirmation()));

            }else{
              if(await ValidateDashboard().getNumberOfPeriod() > 30 && accountStatus=="Active On Trial"){
                      //Navigate to trial period expired
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TrialPeriod()));
                }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDashBoard()));
                }
            }
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NotVerified()));
        }
      }
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/dev_club_logo.png"))
            )
          )
        ),
      ),
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 6));
  }
}
