import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> signInWithGoogle() async {
  final pref = await SharedPreferences.getInstance();
  final GoogleSignInAccount? googleUser =
      await GoogleSignIn(scopes: <String>["email"]).signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  String endpoint =
      "http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/oauth/google/login";
  Dio dio = Dio();
  Response res = await dio.post(endpoint,
      data: {"refreshToken": googleAuth.idToken},
      options: Options(
        validateStatus: (status) => true,
      ));
  if (res.data['accessToken'] != null) {
    await pref.setString('access', res.data['accessToken']);
    await pref.setString('refresh', res.data['refreshToken']);
    return 'Success';
  } else {
    return 'Failed';
  }
}
