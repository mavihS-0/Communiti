import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:one_for_all/screens/onboarding_screen.dart';
import 'package:rive/rive.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            User? user = FirebaseAuth.instance.currentUser;
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                if (documentSnapshot.get('role') == "NGO") {
                  Get.offNamed('/navBarNGO');
                }else{
                  Get.offNamed('/navBarVol');
                }
              } else {
                Get.offNamed('/onboarding');
              }
            });
            return Center(child: Center(child: RiveAnimation.asset('assets/RiveAssets/loading.riv')));
          }
          else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}

