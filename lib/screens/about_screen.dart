import 'package:DiPANINI/resource/consts.dart';
import 'package:flutter/material.dart';

import '../resource/app_colors.dart';
import '../widgets/buttongetstarted.dart';
import 'login_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primBackg,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(27, 105, 105, 105),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(34.0),
                  child: const Text(
                    'The dipanini app is an app that works in all regions of Algeria and is the easiest and fastest process to transport cars to and from anywhere in case of technical breakdowns or traffic accidents, through this app you can determine your location by GPS and show nearby tow trucks by showing nearby truck drivers and choosing the nearest truck driver and dealing with him.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          buttonGetstarted(
            text: "Edit Account",
            color: AppColors.whiteColor,
            textColor: AppColors.primColor,
            fontWeight: FontWeight.w600,
            borderRs: 24,
            sizeW: 360,
            sizeH: 47,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login_Screen()),
            ),
          ),
        ]))));
  }
}
