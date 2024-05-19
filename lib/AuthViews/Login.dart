import 'dart:async';
import 'dart:developer';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicoo/OAuth/google.dart';
import 'package:musicoo/desgins.dart';
import 'package:musicoo/providers.dart';

class LoginView extends ConsumerWidget {
  LoginView({super.key});
  String emails = "";
  String passwords = "";
  bool passok = true;
  Timer? debounce;
  late TextEditingController emailec;
  late TextEditingController pass;

  bool emailok = true;

  void init(ref) {
    emailec = TextEditingController();
    pass = TextEditingController();
    // log('here');
  }

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(login, (previous, next) {
      log(previous?.value.toString() ?? "");
      log(next.value.toString());
      if (next.value == "Success") {
        context.go('/home');
      } else {
        ref.watch(error.notifier).state = next.value ?? "";
      }
    });
    // log('here');
    init(ref);
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/Bg.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      child: Row(children: [
                        IconButton(
                            onPressed: (() {
                              context.go('/Auth');
                            }),
                            icon: Icon(Icons.arrow_back))
                      ]),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SvgPicture.asset('assets/M.svg')),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                    child: Text(
                      'Please enter your email address and\n password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: CTextField(
                          controller: emailec,
                          onChanged: (v) {
                            // submitSearch(ref);
                            emails = v ?? "";
                          },
                          validator: (value) {
                            bool emailerror = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);

                            if (!emailerror) {
                              emailok = false;
                              return 'Invalid Email';
                            } else {
                              emailok = true;
                            }
                            return null;
                          },
                          hinttext: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: CTextField(
                          onChanged: ((v) {
                            log(v!);
                            passwords = v;
                          }),
                          controller: pass,
                          validator: (value) {
                            bool passValid = RegExp(
                                    r"^(?=(.*[a-z]){1,})(?=(.*[A-Z]){1,})(?=(.*[0-9]){1,})(?=(.*[!@#$%^&*()\-__+.]){1,}).{8,}$")
                                .hasMatch(value!);
                            if (!passValid) {
                              passok = false;
                              return 'Password needs to be more than 8 characters, \ncontains at least 1 uppercase , 1 lowercase, 1 number and \n1 special character';
                            } else {
                              passok = true;
                              return null;
                            }
                          },
                          hinttext: 'Password',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: SizedBox(
                            // width: 312,
                            // height: 17,
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  context.go('/Auth/login/forgot');
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 14),
                                ))
                          ],
                        )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    log(passok.toString());
                                    if (!emailok) {
                                      return;
                                    }
                                    if (!passok) {
                                      return;
                                    }
                                    ref.watch(email.notifier).state =
                                        emails.trim().toLowerCase();
                                    ref.watch(password.notifier).state =
                                        passwords;
                                    final loginstate = ref.refresh(login);
                                  },
                                  child: SizedBox(
                                    height: 48,
                                    width: 280,
                                    child: Center(
                                        child: Text(
                                      'Login',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )),
                              Container(
                                padding: EdgeInsets.all(8),
                                width: 312,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ref.watch(error),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go('/Auth/register');
                                },
                                child: Text(
                                  'Sign up',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 2,
                                width: 96,
                                color: Colors.white,
                              ),
                            ),
                            Text('Or'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 2,
                                width: 96,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextButton(
                            onPressed: () async {
                              String s = await signInWithGoogle();
                              if (s == 'Success') {
                                context.go('/home');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 48,
                              width: 345,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Image.network(
                                          'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
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
                    ],
                  ),
                ]),
          ),
        ],
      ),
    ));
  }
}
