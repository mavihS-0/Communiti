import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:one_for_all/screens/volunteer/eventContentVol.dart';
import 'package:one_for_all/utils/constants.dart';


class homeVol extends StatefulWidget {
  const homeVol({Key? key}) : super(key: key);

  @override
  State<homeVol> createState() => _homeVolState();
}

class _homeVolState extends State<homeVol> {
  final CollectionReference _eventsData = FirebaseFirestore.instance.collection('events');
  Map userData = {
    'name' : '--',
    'username' : '--',
    'iconURL' : 'https://firebasestorage.googleapis.com/v0/b/one-for-all-cbabf.appspot.com/o/profile.png?alt=media&token=6d78b114-d7ff-445e-9181-a449529a4ca8'
  };
  List <int> regDocs=[];
  List <int> upDocs=[];
  void getCurrentUser() async {
    try{
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        userData['name'] = value.get('name');
        userData['username'] = value.get('email');
        userData['iconURL'] = value.get('iconURL');
      });
    }catch(e) {
    }
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: StreamBuilder(
        stream: _eventsData.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            for(int i=0;i<streamSnapshot.data!.docs.length;i++){
              if(streamSnapshot.data!.docs[i]['volunteers'].contains(FirebaseAuth.instance.currentUser!.email))
                regDocs.add(i);
              else{
                if((streamSnapshot.data!.docs[i]['start date'] as Timestamp).toDate().isAfter(DateTime.now()))
                  upDocs.add(i);
              }
            }
            upDocs=upDocs.toSet().toList();
            upDocs.sort((a, b){ //sorting in ascending order
              return (streamSnapshot.data!.docs[a]["start date"] as Timestamp).toDate().compareTo((streamSnapshot.data!.docs[b]["start date"] as Timestamp).toDate());
            });
            regDocs=regDocs.toSet().toList();
            return SafeArea(
                child: FractionallySizedBox(
                  heightFactor: 0.96,
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            margin: const EdgeInsets.only(left: 25, right: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:navBar,
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius:28,
                                    backgroundImage: NetworkImage(
                                        userData['iconURL']
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          userData['name'],
                                          style: TextStyle(
                                              color:textNav,
                                              fontSize: 15,
                                              decoration: TextDecoration.none
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 5,),
                                        AutoSizeText(
                                          userData['username'],
                                          style: TextStyle(
                                              color:Colors.grey[600],
                                              fontSize: 10  ,
                                              decoration: TextDecoration.none
                                          ),
                                          maxLines: 1,
                                        ),

                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      FirebaseAuth.instance.signOut();
                                      Get.offNamed('/');
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: bgColor,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.logout,
                                          color:Colors.grey[900],
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.only(left: 25,right: 25),
                            child: Row(
                              children: [
                                Text(
                                  "Registered Events",
                                  style: TextStyle(
                                    color:Color(0xFF1f2326),
                                    fontSize: 18,
                                  ),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 170,
                            child: regDocs.length == 0 ? Container(
                              padding: const EdgeInsets.only(left: 20, top: 20,right: 20),
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(left:25, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:eventBox1
                              ),
                              child: Text(
                                'NO DATA YET',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color:Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ) : PageView.builder(
                                controller: PageController(viewportFraction: 0.88),
                                itemCount: regDocs.length,
                                itemBuilder: (_, i){
                                  final DocumentSnapshot docSnap = streamSnapshot.data!.docs[regDocs[i]];
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(()=>EventContentVol(),arguments: {
                                        'name' : docSnap['name'],
                                        'NGO' : docSnap['NGO'],
                                        'description' : docSnap['description'],
                                        'website' : docSnap['website'],
                                        'start date' : DateFormat('yyyy-MM-dd').format((docSnap["start date"] as Timestamp).toDate()),
                                        'end date' : DateFormat('yyyy-MM-dd').format((docSnap["end date"] as Timestamp).toDate()),
                                        'volunteer count' : docSnap['volunteer count'],
                                        'imageURL' : docSnap['imageURL'],
                                        'isRegistered' : true,
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
                                          color:i.isEven?eventBox1:eventBox2
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
                                            height: 58,
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
                                              color: textVol,
                                            fontStyle: FontStyle.italic,
                                          ),),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.only(left: 25,right: 25),
                            child: Row(
                              children: [
                                Text(
                                  "Upcoming Events",
                                  style: TextStyle(
                                    color:Color(0xFF1f2326),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: upDocs.length == 0 ? Container(
                              padding: const EdgeInsets.only(left: 20, top: 20,right: 20),
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(left:10, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:eventBox2
                              ),
                              child: Text(
                                'NO DATA YET',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color:Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ): ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              //scrollDirection: Axis.vertical,
                              itemCount: upDocs.length <=10 ? upDocs.length: 10,
                              itemBuilder: (_,i){
                                final DocumentSnapshot docSnap = streamSnapshot.data!.docs[upDocs[i]];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(()=>EventContentVol(),arguments: {
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
                                            height: 58,
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
                          )
                        ],
                      )
                  ),
                )
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
