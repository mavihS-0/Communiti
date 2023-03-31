import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_for_all/screens/volunteer/eventsNGOVol.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:one_for_all/screens/volunteer/navBarVol.dart';
import 'package:one_for_all/utils/constants.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({Key? key}) : super(key: key);

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  bool _isRegistered = Get.arguments['isRegistered'];
  int volCount = Get.arguments['volunteer count'];
  List volunteers =Get.arguments['volunteers'];
  String NGOname = '--';
  String NGOwebsite = '--';
  String NGOprofile = 'https://firebasestorage.googleapis.com/v0/b/one-for-all-cbabf.appspot.com/o/profile.png?alt=media&token=6d78b114-d7ff-445e-9181-a449529a4ca8';
  void _getNGOdetails() async {
    await FirebaseFirestore.instance.collection('users').doc(Get.arguments['NGO']).get().then((value) => {
      NGOname = value['name'],
      NGOwebsite = value['website'],
      NGOprofile = value['iconURL'],
    });
    setState(() {
    });
  }

  void _addVol() async {
    volunteers.add(FirebaseAuth.instance.currentUser!.email);
    volunteers=volunteers.toSet().toList();
    volCount+=1;
    await FirebaseFirestore.instance.collection('events').doc('${Get.arguments['NGO']}+${Get.arguments['name']}').update(
        {
          'volunteers' : volunteers,
          'volunteer count' : volCount
        });
    _isRegistered=true;
    Get.snackbar('Registered Successfully','You have been added as a volunteer');
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNGOdetails();
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
                            Get.back()
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          iconSize:30.0,
                          alignment: Alignment.center,
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
                    child: GestureDetector(
                      onTap: (){
                        Get.to(()=>EventsNGOVol(),arguments: {
                          'NGO' : Get.arguments['NGO'],
                          'NGOname' : NGOname,
                          'NGOsite' : NGOwebsite,
                          'NGOprofile' : NGOprofile,
                        });
                      },
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
                  ),
                  SizedBox(height: 15,),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        color: eventBox1.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.all(20),
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
                        SizedBox(height: 7,),
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
                                          fontSize: 13,
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
                                      width: MediaQuery.of(context).size.width*2/10,
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
                                          fontSize: 13,
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
                                          fontSize: 13,
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

                  SizedBox(height: 10,),
                  !_isRegistered ? ElevatedButton.icon(
                    onPressed: () {
                      //TODO: on pressed
                      _addVol();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: eventBox1,
                      minimumSize: const Size(double.infinity, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white,
                    ),
                    label: const Text("Sign Up Now",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ) : SizedBox(height: 0,),
                ],
              ),
            )
        )
    );
  }
}

