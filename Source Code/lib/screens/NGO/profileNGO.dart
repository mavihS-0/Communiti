import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constants.dart';

class ProfilePageNGO extends StatefulWidget {
  @override
  _ProfilePageNGOState createState() => _ProfilePageNGOState();
}

class _ProfilePageNGOState extends State<ProfilePageNGO> {
  String _profileURL = 'https://firebasestorage.googleapis.com/v0/b/one-for-all-cbabf.appspot.com/o/profile.png?alt=media&token=6d78b114-d7ff-445e-9181-a449529a4ca8';
  String test ='abc';
  late File _imageFile = File('abc');

  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isEditing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          test= pickedFile.path;
          _imageFile = File(test);
        });
      }
    } catch (e) {
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profiles/${FirebaseAuth.instance.currentUser!.uid}');
      final task = ref.putFile(imageFile);
      final snapshot = await task;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return _profileURL;
    }
  }
  void getCurrentData() async{
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => {
      _nameController.text= value.get('name'),
      _aboutController.text=value.get('about'),
      _locationController.text=value.get('location'),
      _websiteController.text=value.get('website'),
      _contactNameController.text=value.get('contactName'),
      _contactEmailController.text=value.get('contactEmail'),
      _phoneNumberController.text=value.get('contactNumber'),
      _profileURL = value.get('iconURL'),
    });
    //print(_profileURL);
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    getCurrentData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: test != 'abc' ? Image.file(_imageFile).image : Image.network(_profileURL).image,
          //fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileField(String label,TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: TextFormField(
        enabled: _isEditing,
        controller: controller,
        maxLines: _isEditing ? 1 : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColor,
          labelText: label,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(
              0xFFB4B0B0))),
          border: _isEditing ? OutlineInputBorder(borderSide: BorderSide(color: Colors.black,
          )) : InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildContactFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProfileField("Contact Email", _contactEmailController),
        _buildProfileField("Contact Name", _contactNameController),
        _buildProfileField("Contact Phone Number", _phoneNumberController),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          if(_isEditing == true) postProfile();
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        icon: Icon(_isEditing ? Icons.save : Icons.edit,size: 18,),
        label: Text(_isEditing ? "Save" : "Edit"),
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
      ),
    );
  }

  void postProfile() async {
    final url = await _uploadImage(_imageFile);
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'name' : _nameController.text,
      'location' : _locationController.text,
      'about' : _aboutController.text,
      'website' : _websiteController.text,
      'contactName' : _contactNameController.text,
      'contactNumber' : _phoneNumberController.text,
      'contactEmail' : _contactEmailController.text,
      'iconURL' : url,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              _isEditing ? Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(child: _buildProfileIcon()),
                  Positioned.fill(child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: const SizedBox(),
                  ),),
                  IconButton(onPressed: (){_pickImage(ImageSource.gallery);}, icon: Icon(Icons.edit,size: 30,),color: Colors.white,)
                ],
              ) : _buildProfileIcon(),
              SizedBox(height: 16.0),
              _buildProfileField("Name", _nameController),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: TextFormField(
                  enabled: _isEditing,
                  controller: _aboutController,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: bgColor,
                    labelText: "About",
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(
                        0xFFB4B0B0))),
                    border: _isEditing ? OutlineInputBorder(borderSide: BorderSide(color: Colors.black,
                    )) : InputBorder.none,
                  ),
                ),
              ),
              _buildProfileField("Address", _locationController),
              _buildProfileField("Website", _websiteController),
              Divider(indent: 30,endIndent: 30,color: Colors.grey[600], height: 18,),
              SizedBox(height: 5,),
              _buildContactFields(),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }
}
