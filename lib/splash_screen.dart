import 'package:DiPANINI/screens/get_started_screen.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Delay to ensure the splash screen is shown for the specified duration
    await Future.delayed(Duration(seconds: 3));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // User is logged in, check their type
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          // Safely access the user data
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String userType = userData['user_type'] ?? '';
          // you can modified conditions when work firebase normally
          if (userType == 'Client') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStartedScreen()),
            );
          } else if (userType == 'Driver Help Truck') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStartedScreen()),
            );
          } else {
            // Fallback if user type is unknown
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GetStartedScreen()),
            );
          }
        } else {
          // User document does not exist or is invalid
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GetStartedScreen()),
          );
        }
      } catch (e) {
        print('Error fetching user document: $e');
        // Handle the error appropriately, such as showing an error message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GetStartedScreen()),
        );
      }
    } else {
      // User is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Lottie.asset('assets/animation_sp/Animation - 1718036683861.json'),
      ),
      backgroundColor: Colors.white,
    );
  }
}
