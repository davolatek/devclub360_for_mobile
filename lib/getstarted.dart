
import 'package:devclub360/screens/MemberRegistration.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {

  

  @override

  
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Card(
          elevation: 10,
          color: Colors.white,
          
          child: ElevatedButton(
            
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewMemberRegistration()));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)
            ),
            child: Container(
              height: 100,
               width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New to DevClub360?", style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),),
                        Text("Create Account", style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),),
                      ],
                    )
                    
                    ),
                     Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.redAccent),
                  )
                ]
                  ),
               
              ),
            ),
          )
        ),
    );
  }
}