import 'package:DiPANINI/resource/consts.dart';
import 'package:DiPANINI/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/buttongetstarted.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final List<Widget> cardList = [
      cardContent1(mediaQuery),
      cardContent2(mediaQuery),
      cardContent3(mediaQuery)
    ]; // Add more cards if needed

    return Scaffold(
      backgroundColor: AppColors.primBackg,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.size.height * 0.07,
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.67,
                child: PageView.builder(
                  itemCount: cardList.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.size.height * 0.015,
                        left: mediaQuery.size.width * 0.02,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: cardList[index],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.06,
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: cardList.length,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  type: WormType.thin,
                  activeDotColor: AppColors.primColor,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.05,
              ),
              buttonGetstarted(
                text: "Get Started",
                color: AppColors.primColor,
                textColor: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                borderRs: 24,
                sizeW: mediaQuery.size.width * 0.7,
                sizeH: mediaQuery.size.height * 0.06,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login_Screen()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget cardContent1(MediaQueryData mediaQuery) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.06,
        ),
        Center(
          child: Text(
            "With DEPANINI ",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.06),
          ),
        ),
        Center(
          child: Text(
            "Problem is Easy",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.06),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        Center(
          child: Text(
            "Dipanini: Because your time is valuable",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontSize: mediaQuery.size.width * 0.035),
          ),
        ),
        Center(
          child: Text(
            "our solution is fast!",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontSize: mediaQuery.size.width * 0.035),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.03,
        ),
        Stack(
          children: [
            Center(
              child: Image.asset(
                ic1,
                width: mediaQuery.size.width * 0.8,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQuery.size.height * 0.32),
              child: Divider(
                color: AppColors.primColor,
                endIndent: mediaQuery.size.width * 0.1,
                indent: mediaQuery.size.width * 0.1,
                thickness: 2.5,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget cardContent2(MediaQueryData mediaQuery) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.05,
        ),
        Center(
          child: Text(
            "Need a Convenience Store",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.05),
          ),
        ),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            "We are getting closer to you",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.05),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.02),
            child: Text(
              "Need a vehicle transportation service? We're here to get you closer to a solution in no time , Get started now!",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.textGGColor,
                  fontSize: mediaQuery.size.width * 0.035),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        Stack(
          children: [
            Center(
              child: Image.asset(
                ic2,
                width: mediaQuery.size.width * 0.7,
                height: mediaQuery.size.height * 0.3,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget cardContent3(MediaQueryData mediaQuery) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.045,
        ),
        Center(
          child: Text(
            "Job opportunities will be",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.045),
          ),
        ),
        Center(
          child: Text(
            "No Payment Problems",
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.textGGColor,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.045),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.02),
            child: Text(
              "Business opportunities are available for everyone - no need to worry about payment! Start now and take advantage of these golden opportunities.",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.textGGColor,
                  fontSize: mediaQuery.size.width * 0.035),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Stack(
          children: [
            Center(
              child: Image.asset(
                ic3,
                width: mediaQuery.size.width * 0.75,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
