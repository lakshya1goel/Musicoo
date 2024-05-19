import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicoo/OAuth/google.dart';
import 'package:musicoo/constants/constants.dart';
import 'package:musicoo/desgins.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/Bg.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset('assets/M.svg'),
                Padding(
                  padding: getPadding(top: 144),
                  child: Column(
                    children: [
                      CText(
                        t: 'Millions of Songs.',
                        size: getSize(28),
                      ),
                      CText(
                        t: 'Free on Musicoo.',
                        size: getSize(28),
                      ),
                      Padding(
                        padding: getPadding(top: 51),
                        child: ElevatedButton(
                            onPressed: () {
                              context.go('/Auth/register');
                            },
                            child: SizedBox(
                              height: getSize(48),
                              width: getSize(312),
                              child: Center(
                                child: Text(
                                  'Sign up free',
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: getPadding(top: 16),
                        child: TextButton(
                            onPressed: () async {
                              String s = await signInWithGoogle();
                              if (s == "Success") {
                                context.go('/home');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: getSize(48),
                              width: getSize(345),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(left: 16),
                                      child: Image.network(
                                          'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                                    ),
                                    Padding(
                                      padding: getPadding(left: 30),
                                      child: Text(
                                        'Continue with Google',
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: getPadding(top: 16),
                        child: TextButton(
                            onPressed: () {
                              context.go('/Auth/login');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: getSize(48),
                              width: getSize(345),
                              child: Center(
                                  child: Text(
                                'Login',
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              )),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
