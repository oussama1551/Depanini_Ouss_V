import 'package:DiPANINI/resource/app_colors.dart';
import 'package:DiPANINI/screens/signup_screen.dart';
import 'package:DiPANINI/widgets/buttongetstarted.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resource/images.dart';
import '../widgets/customtesxtfield.dart';
import 'otp_screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _phoneError = false;
  String _errorMessage = '';

  void _login() async {
    final phoneNumber = _phoneController.text;

    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneError = true;
        _errorMessage = 'Phone number cannot be empty';
      });
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone_number', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number exists in the database, send OTP
        _sendCodeToPhoneNumber(phoneNumber);
      } else {
        setState(() {
          _phoneError = true;
          _errorMessage = 'Phone number incorrect or not signed up yet';
        });
      }
    } catch (e) {
      setState(() {
        _phoneError = true;
        _errorMessage = 'An error occurred. Please try again.';
      });
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
        setState(() {
          _phoneError = true;
          _errorMessage = e.message!;
        });
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  ic0,
                  width: 320,
                ),
              ),
              const Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textGGColor,
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Login with your phone number",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textGGColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        "Tap Phone Number With Country Code like +213",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color.fromARGB(197, 82, 82, 82),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (_phoneError)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              buttonGetstarted(
                text: "Login",
                color: AppColors.primColor,
                textColor: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                borderRs: 24,
                sizeW: 360,
                sizeH: 47,
                onPressed: _login,
              ),
              const SizedBox(height: 200),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?",
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
                          MaterialPageRoute(
                              builder: (context) => Sign_upScreen()),
                        );
                      },
                      child: Text(
                        " Sign Up",
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
      ),
    );
  }
}
