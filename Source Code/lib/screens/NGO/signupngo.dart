import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_for_all/utils/constants.dart';

class SignUpNGO extends StatefulWidget {
  const SignUpNGO({Key? key}) : super(key: key);

  @override
  State<SignUpNGO> createState() => _SignUpNGOState();
}

class _SignUpNGOState extends State<SignUpNGO> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _usernameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _websiteController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        Positioned(
          left: 180,
          bottom: 200,
          child: Image.asset("assets/background/circles.png"),
        ),
        const RiveAnimation.asset("assets/RiveAssets/bganim.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 25,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username (Email)',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (!value!.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value)=> value!=null && value.length<6 ? 'Enter min. 6 characters' : null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _aboutController,
                    decoration: InputDecoration(
                      labelText: 'About',
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _websiteController,
                    decoration: InputDecoration(
                      labelText: 'Website',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Emergency contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contactNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contactEmailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (!value!.isEmpty && !value!.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => !value!.isNumericOnly ? 'Enter a valid mobile number' : null,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      registerNGO();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: eventBox2,
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
                      color: Colors.black,
                    ),
                    label: const Text("Sign Up",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
  Future registerNGO() async {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> const RiveAnimation.asset('assets/RiveAssets/loading.riv'),
    );
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) => {postDetailsToFirestore()});
    } on FirebaseAuthException catch(e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  void postDetailsToFirestore() async {
    var user = _auth.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name' : _nameController.text,
      'email' : _usernameController.text,
      'role' : 'NGO',
      'iconURL' : 'https://firebasestorage.googleapis.com/v0/b/one-for-all-cbabf.appspot.com/o/profile.png?alt=media&token=6d78b114-d7ff-445e-9181-a449529a4ca8',
      'location' : _locationController.text,
      'about' : _aboutController.text,
      'website' : _websiteController.text,
      'contactName' : _contactNameController.text,
      'contactNumber' : _contactNumberController.text,
      'contactEmail' : _contactEmailController.text
    });
    Get.toNamed('/');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _aboutController.dispose();
    _websiteController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }
}
