import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:one_for_all/screens/volunteer/eventSearch.dart';
import 'package:rive/rive.dart';
import '../../utils/constants.dart';
import 'eventContentVol.dart';

class SearchVol extends StatefulWidget {
  const SearchVol({Key? key}) : super(key: key);

  @override
  State<SearchVol> createState() => _SearchVolState();
}

class _SearchVolState extends State<SearchVol> {
  final CollectionReference _eventsData = FirebaseFirestore.instance.collection('events');
  String _search ='';
  List <int> docs = [];
  List <String> names=[];

  void getSearch() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const Center(child: Center(child: RiveAnimation.asset('assets/RiveAssets/loading.riv'))),
    );
    var url = Uri.parse('https://communitisearch.onrender.com/?Query=' + _search);
    var response = await get(url);
    Get.back();
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      var i;
      for(i in jsonResponse)
        names.add(i);
      print(names);
    }
    else{
      Get.snackbar("Request Failed", 'Error Code: ${response.statusCode}.');
    }
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: StreamBuilder(
        stream: _eventsData.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData){
            for(int i=0;i<streamSnapshot.data!.docs.length;i++){
              if(names.contains(streamSnapshot.data!.docs[i]['name'])) docs.add(i);
            }
            docs = docs.toSet().toList();
            return SafeArea(
              child: FractionallySizedBox(
                heightFactor: 0.96,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              fillColor: navBar,
                              prefixIcon: Icon(Icons.search,color: Colors.white,),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white),
                              )
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onSubmitted: (value) {
                            docs=[];
                            names=[];
                            _search=value;
                            getSearch();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16,top: 16,bottom: 16),
                        child: ListView.builder(
                          itemCount: docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_,i){
                            DocumentSnapshot docSnap = streamSnapshot.data!.docs[docs[i]];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=>EventSearch(),arguments: {
                                    'name' : docSnap['name'],
                                    'NGO' : docSnap['NGO'],
                                    'description' : docSnap['description'],
                                    'website' : docSnap['website'],
                                    'start date' : DateFormat('yyyy-MM-dd').format((docSnap["start date"] as Timestamp).toDate()),
                                    'end date' : DateFormat('yyyy-MM-dd').format((docSnap["end date"] as Timestamp).toDate()),
                                    'volunteer count' : docSnap['volunteer count'],
                                    'imageURL' : docSnap['imageURL'],
                                    'isRegistered' : false,
                                    'volunteers' : docSnap['volunteers'],
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20, top: 20,right: 20),
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 25),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:!i.isEven?eventBox1:eventBox2
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        docSnap['name'],
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            color:Colors.white
                                        ),
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 56,
                                        width: MediaQuery.of(context).size.width,
                                        child: AutoSizeText(
                                          docSnap['summary'].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color:Color(0xFFb8eefc)
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                        color: Colors.black,
                                      ),
                                      Text('Volunteers: ${docSnap["volunteer count"]}',style: TextStyle(
                                        color: textVol,
                                        fontStyle: FontStyle.italic,
                                      ),),
                                      SizedBox(height: 5,),
                                      Text('Start Date: ${DateFormat('yyyy-MM-dd').format((docSnap["start date"] as Timestamp).toDate())}',style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: textVol
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
