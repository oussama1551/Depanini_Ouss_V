import 'package:DiPANINI/resource/app_colors.dart';
import 'package:DiPANINI/widgets/buttongetstarted.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resource/images.dart';
import '../widgets/customtesxtfield.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class Sign_upScreen extends StatefulWidget {
  const Sign_upScreen({super.key});

  @override
  State<Sign_upScreen> createState() => _Sign_upScreenState();
}

class _Sign_upScreenState extends State<Sign_upScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isClient = true;

  void _signUp() async {
    final fullName = _fullNameController.text;
    final phoneNumber = _phoneController.text;

    if (fullName.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // Create a new user in Firestore
      await _firestore.collection('users').add({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'user_type': _isClient ? 'Client' : 'Driver Help Truck',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User info saved to Firestore. Sending OTP...")),
      );

      // Send OTP and navigate to OTP verification screen
      _sendCodeToPhoneNumber(phoneNumber);
    } catch (e) {
      print("Failed to sign up: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign up. Please try again.")),
      );
    }
  }

  void _sendCodeToPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primBackg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Image.asset(ic0, width: 320),
            ),
            const Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.textGGColor,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
              child: CustomTextField(
                controller: _fullNameController, // Ensure controller is linked
                hintText: 'Full Name', keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
              child: CustomTextField(
                controller: _phoneController, // Ensure controller is linked
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Client",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.textGGColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Radio(
                    value: true,
                    groupValue: _isClient,
                    onChanged: (value) {
                      setState(() {
                        _isClient = value as bool;
                      });
                    },
                  ),
                  Text(
                    "Driver Help Truck",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGGColor,
                      fontSize: 14,
                    ),
                  ),
                  Radio(
                    value: false,
                    groupValue: _isClient,
                    onChanged: (value) {
                      setState(() {
                        _isClient = value as bool;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            buttonGetstarted(
              text: "Sign Up",
              color: AppColors.primColor,
              textColor: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              borderRs: 24,
              sizeW: 360,
              sizeH: 47,
              onPressed: _signUp,
            ),
            const SizedBox(height: 120),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.textGGColor,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login_Screen()),
                      );
                    },
                    child: Text(
                      " Sign In",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.primColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
