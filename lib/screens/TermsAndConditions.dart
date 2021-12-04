import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({ Key? key }) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {

final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override

  void initState(){
    super.initState();
    _pdfViewerKey.currentState?.openBookmarkView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TERMS AND CONDITION", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SfPdfViewer.asset("assets/files/DEVCLUB360STermsAndConditionsRevised.pdf", key: _pdfViewerKey),
    );
  }
}