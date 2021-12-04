import 'package:flutter/material.dart';

class MembersCategory extends StatelessWidget {
  const MembersCategory({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Membership Categories", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SingleChildScrollView(child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text("Your Membership status is determined by your transaction history", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Active Member", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("\$0 - \$198,000")
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Premium Member", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("\$200,000 - \$500,000")
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Diamond Member", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("\$502,000 - \$1Million")
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Legend", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("\$1.2Million - \$6Million")
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Grand Legend", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("Above \$6Million")
                ],
              ),
            ),
          ],
        ),
      ),)
    );
  }
}