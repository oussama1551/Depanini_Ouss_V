import 'package:DiPANINI/resource/consts.dart';
import 'package:flutter/material.dart';

import '../resource/app_colors.dart';
import '../widgets/buttongetstarted.dart';

import 'login_screen.dart';

class ProfileScreenClient extends StatefulWidget {
  const ProfileScreenClient({super.key});

  @override
  State<ProfileScreenClient> createState() => _ProfileScreenClientState();
}

class _ProfileScreenClientState extends State<ProfileScreenClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primBackg,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
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
              height: MediaQuery.of(context).size.height * 0.12,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(imP),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Hatem Zeghoud",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "+213676375542",
                              style: TextStyle(
                                color: Color.fromARGB(255, 144, 140, 140),
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        const Icon(
                          Icons.design_services,
                          color: AppColors.primColor,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  "QUICK LINKS",
                  style: TextStyle(
                    color: Color.fromARGB(255, 144, 140, 140),
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: AppColors.primColor,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'History',
                        style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                      ),
                      const Icon(
                        Icons.navigate_next_rounded,
                        color: AppColors.primColor,
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
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
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                child: ListTile(
                  leading: const Icon(
                    Icons.wallet,
                    color: AppColors.primColor,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallet',
                        style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                      ),
                      const Icon(
                        Icons.navigate_next_rounded,
                        color: AppColors.primColor,
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              "Delete Account",
              style: TextStyle(
                color: AppColors.redColor,
                fontFamily: 'Poppins',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buttonGetstarted(
            text: "Logout",
            color: AppColors.primColor,
            textColor: AppColors.whiteColor,
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
