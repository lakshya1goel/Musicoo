import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicoo/Sevices/token_services.dart';
import 'package:go_router/go_router.dart';
import 'package:musicoo/main.dart';
import 'package:pinput/pinput.dart';
import 'desgins.dart';
final emailstate = StateProvider((ref) => "",);
final passwordstate = StateProvider((ref) => "",);
final loader = StateProvider.autoDispose<bool>(((ref) => false));
final eventsuccess = StateProvider.autoDispose<bool>((ref) => false);
final token_provider = FutureProvider<String>(((ref) async {
  return ref.watch(api).get_token();
}));
final login = FutureProvider.autoDispose<String>(((ref) async {
  final String mail = ref.watch(email);
  final String pass = ref.watch(password);
  return ref.watch(api).login(mail, pass);
}));
final verified = StateProvider(
  (ref) => false,
);
final email = StateProvider.autoDispose(((ref) => ""));
final error = StateProvider.autoDispose(
  (ref) => "",
);
final password = StateProvider.autoDispose(((ref) => ""));
final first = StateProvider.autoDispose(((ref) => ""));
final otppr = StateProvider.autoDispose((ref) => "");
final last = StateProvider.autoDispose(((ref) => ""));

final register = FutureProvider.autoDispose<String>(((ref) async {
  final String mail = ref.watch(email);
  final String pass = ref.watch(password);
  final String firstn = ref.watch(first);
  final String lastn = ref.watch(last);
 
  final String result =
      await ref.watch(api).register(firstn, lastn, mail, pass);

  return result;
}));

final forgotemail = FutureProvider.autoDispose<String>(
  (ref) {
    final String mail = ref.watch(email);
    return ref.watch(api).forgotpass(mail);
  },
);

final forgototp = FutureProvider.autoDispose<dynamic>(
  (ref) {
    final String mail = ref.watch(email);
    final String otpp = ref.watch(otppr);
    return ref.watch(api).forgotpassotp(mail, otpp);
  },
);

final forgotpass = FutureProvider.autoDispose<dynamic>(
  (ref) {
    final String mail = ref.watch(email);
    final String otpp = ref.watch(otppr);
    final String pass = ref.watch(password);
    return ref.watch(api).forgotpasschange(mail, otpp, pass);
  },
);

final forgotindex = StateProvider.autoDispose<int>(((ref) {
  return 0;
}));

final forgot = StateProvider.autoDispose<Widget>(((ref) {
  final int index = ref.watch(forgotindex);
  final _forgotemail = ref.watch(forgotemail);
  final _forgototp = ref.watch(forgototp);
  String emails = "";
  String otp = "";
  bool emailok = false;

  String pass = "";
  String cpass = "";
  bool passok = false;
  switch (index) {
    case 0:
      return Container(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 29.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       IconButton(
            //           onPressed: (() {
            //             ref.watch(forgotindex.notifier).state--;
            //           }),
            //           icon: Icon(Icons.arrow_back))
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(29.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 29.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 290,
                    child: Text(
                        "Dont't worry it happens. Please enter the email address associated with your account to reset the password"),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: CTextField(
                    width: 345,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 29),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!emailok) {
                          return;
                        }
                        ref.watch(email.notifier).state =
                            emails.trim().toLowerCase();
                        final res = ref.refresh(forgotemail);
                      },
                      child: SizedBox(
                        height: 48,
                        width: 290,
                        child: Center(
                            child: Text(
                          'Send OTP',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        )),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: _forgotemail.when(
                  data: (data) {
                    return TextButton(
                        onPressed: () {
                          ref.watch(forgotindex.notifier).state++;
                        },
                        child: SizedBox(
                          height: 48,
                          width: 290,
                          child: Center(
                              child: Text(
                            'Next',
                            style: GoogleFonts.montserrat(
                                color: mainColor, fontWeight: FontWeight.w600),
                          )),
                        ));
                  },
                  error: (error, stackTrace) {
                    if (error.toString().trim() == "Exception") {
                      return Text('');
                    }
                    return Text(
                      error.toString().split(':')[1],
                      style: TextStyle(color: Colors.red),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ));
    case 1:
      return Container(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 2,
                      width: 100,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 29.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: (() {
                        ref.watch(forgotindex.notifier).state--;
                      }),
                      icon: Icon(Icons.arrow_back))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(29.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter Verification Code',
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 29.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(
                    width: 290,
                    child: Text(
                        "A six digit code has been sent to your email address, please enter the code below"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 29.0, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 345,
                    child: Pinput(
                      length: 6,
                      onChanged: (value) {
                        otp = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 29),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (otp.length < 6) {
                          return;
                        }
                        ref.watch(otppr.notifier).state = otp;

                        final res = await ref.refresh(forgototp);
                      },
                      child: SizedBox(
                        height: 48,
                        width: 290,
                        child: Center(
                            child: Text(
                          'Continue',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        )),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: _forgototp.when(
                  data: (data) {
                    return TextButton(
                        onPressed: () {
                          ref.watch(forgotindex.notifier).state++;
                        },
                        child: SizedBox(
                          height: 48,
                          width: 290,
                          child: Center(
                              child: Text(
                            'Next',
                            style: GoogleFonts.montserrat(
                                color: mainColor, fontWeight: FontWeight.w600),
                          )),
                        ));
                  },
                  error: (error, stackTrace) {
                    log(error.toString());
                    if (error.toString().trim() == "Token Expired") {
                      return Text('');
                    }
                    return Text(
                      error.toString().split(':')[1],
                      style: TextStyle(color: Colors.red),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ));
    case 2:
      return Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 2,
                    width: 100,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 2,
                    width: 100,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 2,
                    width: 100,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: (() {
                      ref.watch(forgotindex.notifier).state--;
                    }),
                    icon: Icon(Icons.arrow_back))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(29.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 290,
                  child: Text("Create a new password to reset"),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 29),
                child: CTextField(
                  onChanged: ((v) {
                    log(v!);
                    pass = v;
                  }),
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
                  hinttext: 'New Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 29),
                child: CTextField(
                  onChanged: ((v) {
                    log(v!);
                    cpass = v;
                  }),
                  controller: pass,
                  validator: (value) {
                    if (pass != cpass) {
                      passok = false;
                      return 'Password do not match';
                    } else {
                      passok = true;
                      return null;
                    }
                  },
                  hinttext: 'Confirm New Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 29),
                child: ElevatedButton(
                    onPressed: () async {
                      if (pass != cpass || !passok) {
                        return;
                      }
                      ref.watch(password.notifier).state = pass;
                      final res = await ref.refresh(forgotpass);
                      if (res.hasError) {
                        log(res.error.toString());
                        return;
                      }
                      // ref.watch(forgotindex.notifier).state++;
                    },
                    child: SizedBox(
                      height: 48,
                      width: 290,
                      child: Center(
                          child: Text(
                        'Continue',
                        style: GoogleFonts.montserrat(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
                    )),
              ),
            ],
          ),
        ],
      ));
    default:
      return Container(
        child: TextButton(
          child: Text('1'),
          onPressed: () {
            ref.watch(forgotindex.notifier).state--;
          },
        ),
      );
  }
}));
