import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class DealShareProjectProposalViews extends StatefulWidget {
  final DocumentSnapshot views;

  DealShareProjectProposalViews({required this.views});

  @override
  _DealShareProjectProposalViewsState createState() => _DealShareProjectProposalViewsState();
}

class _DealShareProjectProposalViewsState extends State<DealShareProjectProposalViews> {

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
        title: Text("Proposal Views", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
           Image.asset("assets/images/dev_club_logo.png", height: 40, width: 70,),
        ],
      ),
      body: SfPdfViewer.network(
        widget.views.get("ProposalUrl"),
        key: _pdfViewerKey,
      ),
    );
  }
}