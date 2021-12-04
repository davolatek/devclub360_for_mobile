import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/no_internet.png")
              )
            ),
          ),
          Text("No Internet Connection", style: TextStyle(fontSize: 15, color:Colors.redAccent))
        ],
      ),
    );
  }
}