import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../utils/animated_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String dropdownValue = 'NGO';
  late RiveAnimationController _btnAnimationController1;
  late RiveAnimationController _btnAnimationController2;
  bool _isPressed = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  @override
  void initState() {
    _btnAnimationController1 = OneShotAnimation(
      "active",
      autoplay: false,
    );
    _btnAnimationController2 = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  Future signIn() async {
    try{
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context)=> const RiveAnimation.asset('assets/RiveAssets/loading.riv'),
      // );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Get.toNamed('/');
    }
    on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Invalid User', 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Invalid Password', 'Wrong password provided for that user');
      }
      else{
        Get.snackbar('Error', e.message.toString());
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/background/circles.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/bganim.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          Positioned(
              left: 20,
              right: 20,
              top:100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Communiti",
                    style: GoogleFonts.baumans(
                      textStyle: TextStyle(
                        fontSize: 60,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w700,
                      ),
                    ),),
                  SizedBox(height: 10,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'Please sign in to continue',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700]
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextFormField(
                            controller: _usernameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.mail_outline),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value)=> value!=null && value.length<6 ? 'Enter min. 6 characters' : null,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.key),
                              ),
                            ),
                          ),
                        ),
                        AnimatedBtn(
                          buttonText: 'Sign In',
                          btnAnimationController: _btnAnimationController1,
                          press: () {
                            _btnAnimationController1.isActive = true;

                            Future.delayed(
                              const Duration(milliseconds: 800),
                                  () {
                                //TODO: sign in
                                    signIn();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isPressed = !_isPressed;
                          });
                          // Add your onPressed code here
                        },
                        child: Text('Sign Up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),),
                      )
                    ],
                  ),
                  _isPressed ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      DropdownButton<String>(
                        value: dropdownValue,
                        dropdownColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          // Update dropdown value when a new option is selected
                          setState(() {
                            dropdownValue = newValue!;
                            //print(dropdownValue);
                          });
                        },
                        items: <String>['NGO', 'Volunteer']
                            .map<DropdownMenuItem<String>>((String value) {
                          // Map each dropdown item to a DropdownMenuItem widget
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10,),
                      AnimatedBtn(
                        buttonText: 'Create Account',
                        btnAnimationController: _btnAnimationController2,
                        press: () {
                          _btnAnimationController2.isActive = true;

                          Future.delayed(
                            const Duration(milliseconds: 800),
                                () {
                              if(dropdownValue=="NGO") Get.toNamed("/signUpNGO");
                              else if(dropdownValue=="Volunteer") Get.toNamed("/signUpVol");
                            },
                          );
                        },
                      ),
                    ],
                  ) : SizedBox(height: 0,),
                ],
              ))
        ],
      ),
    );
  }
}
