import 'package:ayurvedic_centre_app/core/util/common_widgets.dart';
import 'package:ayurvedic_centre_app/core/util/sized_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset('assets/images/loginBg.png', width: double.infinity, height: 250, fit: BoxFit.cover),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/logoPng.png', height: 84, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeBoxH(30),
                        text(
                          text: 'Login or register to book \nyour appointments',
                          size: 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                        ),
                        SizeBoxH(30),
                        text(text: 'Email', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
                        SizeBoxH(6),
                        buildCommonTextFormField(
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: TextEditingController(),
                          context: context,
                        ),
                        SizeBoxH(25),
                        text(text: 'Password', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
                        SizeBoxH(6),
                        buildCommonTextFormField(
                          hintText: 'Enter password',
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          controller: TextEditingController(),
                          context: context,
                        ),
                        SizeBoxH(84),
                        button(name: 'Login', height: 50),
                        SizeBoxH(40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    children: [
                      const TextSpan(text: 'By creating or logging into an account you are agreeing with our '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Color(0XFF0028FC),
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text('Terms and Conditions tapped')));
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0XFF0028FC),
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text('Privacy Policy tapped')));
                          },
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
