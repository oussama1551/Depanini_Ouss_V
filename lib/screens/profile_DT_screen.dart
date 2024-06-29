import 'package:DiPANINI/resource/consts.dart';
import 'package:DiPANINI/screens/home_map_screen_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resource/app_colors.dart';
import '../widgets/buttongetstarted.dart';
import 'login_screen.dart';

class ProfileScreenDT extends StatefulWidget {
  const ProfileScreenDT({super.key});

  @override
  State<ProfileScreenDT> createState() => _ProfileScreenDTState();
}

class _ProfileScreenDTState extends State<ProfileScreenDT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primBackg,
        appBar: AppBar(
          title: Center(
            child: Text(
              "My Account",
              style:
                  TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.home,
                        color: AppColors.primColor,
                      ),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeMapScreen_Client()),
                        );
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: AppColors.primColor,
                      ),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Account',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreenDT()),
                        );
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: AppColors.primColor,
                      ),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'history',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.feedback,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Feedback',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person_add_alt_1,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Invite',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.list,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Privacy Policy',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Langue',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.primColor,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Logout',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.navigate_next_rounded)
                        ],
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_Screen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                                  "Houcine beka",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "+213656949449",
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
                    Icons.track_changes,
                    color: AppColors.primColor,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Truck Information',
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
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
