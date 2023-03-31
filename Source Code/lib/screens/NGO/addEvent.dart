import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:one_for_all/screens/NGO/navBarNGO.dart';
import 'package:rive/rive.dart';
import '../../utils/constants.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description ='';
  late String _link;
  late String summ;
  late DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now();
  String test ='abc';
  late File _imageFile = File(test);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          test=pickedFile.path;
          _imageFile = File(test);
        });
      }
    } catch (e) {
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('eventImages/${FirebaseAuth.instance.currentUser!.uid}');
      final task = ref.putFile(imageFile);
      final snapshot = await task;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return 'https://firebasestorage.googleapis.com/v0/b/one-for-all-cbabf.appspot.com/o/profile.png?alt=media&token=6d78b114-d7ff-445e-9181-a449529a4ca8';
    }
  }

  Future<void> _addEvent() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const RiveAnimation.asset('assets/RiveAssets/loading.riv'),
    );
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = await _uploadImage(_imageFile);

      FirebaseFirestore.instance.collection('events').doc('${FirebaseAuth.instance.currentUser!.uid}+$_name').set({
        'name' : _name,
        'description' : _description,
        'NGO' : FirebaseAuth.instance.currentUser!.uid,
        'start date' : Timestamp.fromDate(_startDate),
        'end date' : Timestamp.fromDate(_endDate),
        'website' : _link,
        'imageURL' : url,
        'volunteer count' : 0,
        'volunteers' : [],
        'summary' : summ,
      });
      Get.off(()=>const NavBarNGO());
    }
    else Get.back();
    //Get.back();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter event name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    maxLength: 500,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      _description = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Start Date: ${DateFormat("yyyy-MM-dd").format(_startDate)}'),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('End Date: ${DateFormat("yyyy-MM-dd").format(_endDate)}'),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Website',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter link to the website';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _link = value!;
                    },
                  ),
                  SizedBox(height: 20,),
                  Container(width: 300,
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: test !=  'abc'
                                ? Image.file(_imageFile, fit: BoxFit.contain)
                                : Image.asset('assets/background/edit.png'),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                              color: eventBox2,
                              borderRadius: BorderRadius.circular(10.0)
                            //backgroundBlendMode:
                          ),
                          child: TextButton(
                            child: Text('Select Image',style: TextStyle(color: Colors.white),),
                            onPressed: () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context)=> const Center(child: Center(child: RiveAnimation.asset('assets/RiveAssets/loading.riv'))),
                        );
                        var url = Uri.parse('https://communiti.onrender.com/?Query=' + _description);
                        var response = await get(url);
                        Get.back();
                        if(response.statusCode == 200){
                          var jsonResponse = jsonDecode(response.body);
                          summ = jsonResponse[0];
                        }
                        else summ=_description.substring(0,70)+'...';
                        _addEvent();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: eventBox1,
                        minimumSize: const Size(double.infinity, 56),
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
                      label: const Text("Add Event",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
