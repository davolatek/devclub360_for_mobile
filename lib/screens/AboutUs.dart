import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({ Key? key }) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

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
        title: Text("About Devclub360", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SfPdfViewer.asset("assets/files/DEVCLUB360ABOUTCONTENT.pdf", key: _pdfViewerKey),
    );
  }
}