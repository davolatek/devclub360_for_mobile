import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclub360/Payments/paymentQueries/payWithTransfer.dart';
import 'package:devclub360/Payments/paystack/payWithPayStack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class MyPaymentPage extends StatefulWidget {
  const MyPaymentPage({ Key? key }) : super(key: key);

  @override
  _MyPaymentPageState createState() => _MyPaymentPageState();
}

class _MyPaymentPageState extends State<MyPaymentPage> {
  int priceInNaira = 0, priceInDollars= 0, couponPriceReduction = 0, couponPricePercent = 0, newNairaPrice = 0;
  int membershipAmount = 0, membershipAmountDollars = 0, newDollarPrice= 0;
  String couponOwner = "";
  bool hasInternet = false;
  
  static final couponFormKey = GlobalKey<FormState>();
  static final paymentFormKey = GlobalKey<FormState>();
  String paymentMethod = "", firstName = "", accountStatus = "";
  static TextEditingController controllerCoupon = new TextEditingController();

  int _state = 0;
  bool cardOption = false, transferOption = false, couponVisibile = true, couponIsUsed = false;
  Widget setUpButtonChild(String text){
      if(_state==0){
       return new Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 10)
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

    FirebaseFirestore.instance.collection("Members").doc(FirebaseAuth.instance.currentUser!.uid).get()
    .then((value){
      setState(() {
        firstName = value.get("firstName");
        accountStatus =  value.get("AccountStatus");
      });
    });

    FirebaseFirestore.instance.collection("Prices").doc("DevClubMembershipFee").get()
    .then((docs) async{
     String nairaPriceInString = await docs.get("MembershipFeeInNaira");
     String dollarPriceInString = await docs.get("MembershipFeeInDollars");
        
        setState(() {
          priceInNaira =  int.parse(nairaPriceInString);
          priceInDollars =  int.parse(dollarPriceInString);
          membershipAmount = priceInNaira;
          membershipAmountDollars = priceInDollars;
        });
          
        
    }).catchError((error){
        print(error);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: Text("MEMBERSHIP LICENSE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: Text("Payment Portal", style: TextStyle(color: Colors.black, fontSize: 15),)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Divider(color: Colors.black, height: 2, thickness: 1,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Membership License in Dollars:"),
                              Text("USD"+priceInDollars.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Membership License in Naira:"),
                              Text("NGN"+priceInNaira.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text("Have a Coupon Code?"),
                        
                      ),
                      Visibility(
                        visible: couponVisibile,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Form(
                            key: couponFormKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                  controller: controllerCoupon,
                                  
                                    decoration: InputDecoration(
                                      labelText: "Enter Coupon Code", 
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
                                        return "Your Coupon Code is required to apply one";
                                      }
                                      
                                      
                                    
                                      return null;
                                    },
                                   
                                                          ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                  onPressed: () async{
                                      if(couponFormKey.currentState!.validate()){
                                        setState(() {
                                          _state = 1;
                                        });
                                          await FirebaseFirestore.instance.collection("Coupons").doc(controllerCoupon.text)
                                          .get().then((docs) async{
                                              if(docs.exists){
                                                Timestamp expiration = await docs.get("Expiration");
                                                if(DateTime.now().microsecondsSinceEpoch  <= expiration.microsecondsSinceEpoch ){
                                                      int noOfUsed = docs.get("NumberOfTimesUsed");
                                                    int cPP = int.parse(docs.get("Percent"));
                                                    int cPR = int.parse(docs.get("AmountInNaira"));
                                                    int couponPriceInDollars = int.parse(docs.get("AmountInDollars"));
                                                    int mSA = priceInNaira - cPR; 
                                                    int mSAD= priceInDollars - couponPriceInDollars;
                                                        setState(() {
                                                          couponPricePercent = cPP;
                                                          couponPriceReduction = cPR;
                                                          couponIsUsed = true;
                                                          newNairaPrice = mSA;
                                                         newDollarPrice = mSAD;
                                                        });
                                                        
                                                      
                                                      await FirebaseFirestore.instance.collection("Coupons").doc(controllerCoupon.text)
                                                      .update({
                                                        "NumberOfTimesUsed": noOfUsed + 1
                                                      }).catchError((error){
                                                          print(error);
                                                          setState(() {
                                                            _state = 0;
                                                            

                                                          });

                                                        });
                                                        setState(() {
                                                          _state = 0;
                                                          couponVisibile = false;
                                                        });
                                                        await showSimpleNotification(
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                              Expanded(child: Text(controllerCoupon.text+" has been applied", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                            ],
                                                          ),
                                                          background: Colors.green,
                                                          duration: Duration(seconds: 5),
                                                          slideDismissDirection: DismissDirection.horizontal
                                                          );
                                                    }else{
                                                        await showSimpleNotification(
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.approval_rounded, size: 20, color: Colors.white,),
                                                              Expanded(child: Text(controllerCoupon.text+" is no longer active", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                                                            ],
                                                          ),
                                                          background: Colors.red,
                                                          duration: Duration(seconds: 5),
                                                          slideDismissDirection: DismissDirection.horizontal
                                                          );

                                                          setState(() {
                                                        _state = 0;
                                                        

                                                      });
                                                    }
                                              }else{
                                                setState(() {
                                                        _state = 0;
                                                        

                                                      });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Coupon Code"),backgroundColor: Colors.red, duration: Duration(seconds: 2)));
                                              }
                                          }).catchError((error){
                                            print(error);
                                            setState(() {
                                              _state = 0;
                                            });
                                          });
                                      }else{
                                        return;
                                      }
                                  }, 
                                  child: setUpButtonChild("Apply")
                                  )
                                  )
                              ],
                            ),
                          )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Form(
                          key: paymentFormKey,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "Select Payment Method?", 
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
                                          value: "Pay With Transfer",
                                          child: Text("Pay With Transfer")
                                        ),
                                        DropdownMenuItem<String>(
                                          value: "Pay With Card",
                                          child: Text("Pay With Card")
                                        ),
                                        
                                      ],
                                      onChanged: (value){
                                          setState(() {
                                            paymentMethod = value!;
                                            
                                          });

                                          if(paymentMethod == "Pay With Transfer"){
                                                setState(() {
                                                  transferOption = true;
                                                  cardOption = false;
                                                });
                                            }else if(paymentMethod == "Pay With Card"){
                                                setState(() {
                                                  transferOption = false;
                                                  cardOption = true;
                                                });
                                            }
                                      },
                                      onSaved: (value){
                                          setState(() {
                                            
                                            paymentMethod = value!;
                                          });
                                          
                                      },
                                      
                                  ),
                                ),
                                
                              ],
                            ),
                          )
                        ),
                        Visibility(
                          visible: cardOption,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text("Suitable for Members in Nigeria, Ghana and South Africa")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4, child: Text("Subtotal", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 3,child: Text(priceInNaira.toString()+"(USD"+priceInDollars.toString()+")"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4,child: Text("Coupon Reduction Amount", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 2,child: Text(couponPriceReduction.toString()+"("+couponPricePercent.toString()+"%)"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4,child: Text("Total", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 4,child: Text(couponIsUsed== false?membershipAmount.toString()+"NGN"+"("+membershipAmountDollars.toString()+"USD)":newNairaPrice.toString()+"NGN"+"("+newDollarPrice.toString()+"USD)"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton.icon(
                                    onPressed: () async{
                                          hasInternet = await InternetConnectionChecker().hasConnection;

                                          if(hasInternet){
                                            setState(() {
                                              _state = 1;
                                            });
                                            await MakeMembershipPayment(context, couponIsUsed==false?membershipAmount:newNairaPrice, await FirebaseAuth.instance.currentUser!.email.toString(), firstName, accountStatus, couponIsUsed, controllerCoupon.text).chargeCardAndMakePayment();
                                             setState(() {
                                              _state = 0;
                                            });
                                          }else{
                                            showSimpleNotification(
                                              Text("No Internet Connection"),
                                              background: Colors.red
                                            );
                                          }
                                        //Proceed with Paystack option
                                     
                                    }, 
                                    icon: Icon(Icons.payment), 
                                    label: setUpButtonChild("Proceed To Pay with Card")
                                    ),
                                ),
                              )
                            ],
                          ),
                        ),
      
                        Visibility(
                          visible: transferOption,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text("Suitable for Members in other african countries")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4, child: Text("Subtotal", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 3,child: Text(priceInNaira.toString()+"(USD"+priceInDollars.toString()+")"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4, child: Text("Coupon Reduction Amount", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 2, child: Text(couponPriceReduction.toString()+"("+couponPricePercent.toString()+"%)"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 4,child: Text("Total", style: TextStyle(color: Colors.black, fontSize: 10))),
                                    Expanded(flex: 4,child: Text(couponIsUsed== false?membershipAmount.toString()+"NGN"+"("+membershipAmountDollars.toString()+"USD)":newNairaPrice.toString()+"NGN"+"("+newDollarPrice.toString()+"USD)"))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text("Devclub360 Account details")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Account Name", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("MORTGOGENIE PROPERTY COMPANY ")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Account Number", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("0037514124")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Bank Name", style: TextStyle(color: Colors.black, fontSize: 10)),
                                    Text("STANBIC BANK")
                                  ],
                                ),
                              ),
                             
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text("Transfer into this account and click on Proceed to continue")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton.icon(
                                    onPressed: () async{
                                        //Proceed with Transfer ption
                                        hasInternet = await InternetConnectionChecker().hasConnection;
                                        if(hasInternet){
                                            setState(() {
                                              _state = 1;
                                            });
                                            await MakePaymentWithTransferOption().transferOption(membershipAmount, context);
                                             setState(() {
                                              _state = 0;
                                            });
                                          }else{
                                            showSimpleNotification(
                                              Text("No Internet Connection"),
                                              background: Colors.red
                                            );
                                          }
                                    }, 
                                    icon: Icon(Icons.payment), 
                                    label: Text("Proceed after Transfer", )
                                    ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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