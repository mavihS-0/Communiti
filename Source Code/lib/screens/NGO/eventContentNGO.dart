import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:one_for_all/screens/NGO/navBarNGO.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';

class EventContentNGO extends StatefulWidget {
  const EventContentNGO({Key? key}) : super(key: key);

  @override
  State<EventContentNGO> createState() => _EventContentNGOState();
}

class _EventContentNGOState extends State<EventContentNGO> {
  int volCount = Get.arguments['volunteer count'];
  List volunteers =Get.arguments['volunteers'];
  String NGOname = Get.arguments['NGOname'];
  String NGOwebsite = Get.arguments['NGOsite'];
  String NGOprofile = Get.arguments['NGOprofile'];
  String name = Get.arguments['name'];
  String NGO =Get.arguments['NGO'];

  void _deleteEvent() async{
    await FirebaseFirestore.instance.collection('events').doc('$NGO+$name').delete().then((value) =>
    {
    Get.snackbar('Event Deleted', 'Event deleted successfully')
    }).catchError((error)=>{
    Get.snackbar('Error', error)
    });
    Get.off(()=>NavBarNGO());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: eventBox1.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16.0)
                          //backgroundBlendMode:
                        ),
                        child: IconButton(
                          onPressed: ()=>{
                            Get.off(()=>NavBarNGO())
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          iconSize:30.0,
                          alignment: Alignment.center,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        decoration: BoxDecoration(
                            color: eventBox1.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16.0)
                          //backgroundBlendMode:
                        ),
                        child: IconButton(
                          onPressed: ()=>{
                            Get.defaultDialog(
                              title: "Do you really want to delete this event?",
                              middleText: "This action is ir-reversible, continue?",
                              onConfirm: _deleteEvent,
                              onCancel: (){
                                //print('${Get.arguments['NGO']}+${Get.arguments['name']}');
                              },
                              textCancel: 'No',
                              textConfirm: 'Yes',
                              backgroundColor: Colors.white.withOpacity(0.6),
                              buttonColor: Colors.white,
                              cancelTextColor: Colors.black,
                              confirmTextColor: Colors.black,
                              titlePadding: EdgeInsets.all(16),
                              contentPadding: EdgeInsets.only(left: 16,bottom: 16,right: 16),
                            )
                          },
                          icon: const Icon(Icons.delete_outline),
                          iconSize:30.0,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:eventBox1.withOpacity(0.8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius:28,
                            backgroundImage: NetworkImage(NGOprofile),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  NGOname,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 15,
                                      decoration: TextDecoration.none
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 5,),
                                AutoSizeText(
                                  NGOwebsite,
                                  style: TextStyle(
                                      color:Colors.grey[300],
                                      fontSize: 12,
                                      decoration: TextDecoration.none
                                  ),
                                  maxLines: 1,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        color: eventBox1.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          Get.arguments['name'].toString().toUpperCase(),
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: AutoSizeText(Get.arguments['description'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700]
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 33,
                          child: TextButton(
                            onPressed: ()async {
                              String url = '${Get.arguments['website']}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: AutoSizeText(Get.arguments['website'],
                              style: TextStyle(
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1,color: Colors.grey[600]),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.watch_later,
                                    color:Colors.green),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*2/10,
                                      child: AutoSizeText(Get.arguments['start date'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:Color(0xFF303030),
                                            fontWeight: FontWeight.w700
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text("Start Date",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:Colors.grey[700]
                                      ),
                                    )
                                  ],
                                )
                              ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.people,
                                    color: Colors.blue),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width*2/10,
                                      child: AutoSizeText(volCount.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:Color(0xFF303030),
                                            fontWeight: FontWeight.w700
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text("Volunteers",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:Colors.grey[700]
                                      ),
                                    )
                                  ],
                                )
                              ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.watch_later,
                                    color:Colors.red),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*2/10,
                                      child: AutoSizeText(Get.arguments['end date'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:Color(0xFF303030),
                                            fontWeight: FontWeight.w700
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text("End Date",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:Colors.grey[700]
                                      ),
                                    )
                                  ],
                                )
                              ],)
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 13,),
                  Container(
                    decoration: BoxDecoration(
                      color: eventBox1.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Event Image: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(Get.arguments['imageURL'],
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator()
                                );
                              },
                            ),),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 13,),
                  Container(
                    decoration: BoxDecoration(
                      color: eventBox1.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Volunteers :',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 15,
                        ),),
                        SizedBox(height: 5,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: volCount,
                          itemBuilder: (_,i){
                            return Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: EdgeInsets.only(top:7),
                              padding: EdgeInsets.symmetric(vertical: 4,horizontal: 20),
                              child: Text(
                                volunteers[i],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}

