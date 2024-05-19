import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  Dio dio = Dio();

  String refreshTokenEndpoint =
      'http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/auth/refresh-token';
  String loginEndPoint =
      'http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/auth/login';
  String registerEndPoint =
      'http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/auth/signup';
  String forgotEmailEndpoint =
      "http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/auth/forgot-password";
  String forgotOtpEndpoint =
      "http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/auth/confirm-otp";

  String forgotpassEndpoint =
      "https://musicooapis-production.up.railway.app/api/auth/change-password";
  Future<String> get_token() async {
    final pref = await SharedPreferences.getInstance();
    String? rtoken = pref.getString("refresh");
    if (rtoken == null) {
      throw Exception('Refresh Token not Present');
    }
    Response res = await dio
        .post(refreshTokenEndpoint, data: {"refreshToken": rtoken},
            options: Options(validateStatus: ((status) {
      log(status.toString());

      if (status == 401) {
        throw Exception('Refresh Token expired');
      }
      return true;
    })));
    log(res.statusCode.toString());
    log(res.data.toString());
    pref.setString('access', res.data['accessToken']);
    pref.setString('refresh', res.data['refreshToken']);
    return res.data['accessToken'];
  }

  //Login------------------------------------------------------------------------------------------------------------------------------
  Future<String> login(String email, String password) async {
    final pref = await SharedPreferences.getInstance();
    if (email.isEmpty || password.isEmpty) {
      return '';
    }
    log('hit');
    Response res = await dio.post(loginEndPoint,
        data: {'email': email, 'password': password},
        options: Options(
          validateStatus: (status) => true,
        ));
    log(res.statusCode.toString());

    log(res.data.toString());
    if (res.statusCode == 200) {
      await pref.setString('access', res.data['accessToken']);
      await pref.setString('refresh', res.data['refreshToken']);
      return 'Success';
    } else {
      return res.data;
    }
  }

// register---------------------------------------------------------------------------------------------------------------
  Future<String> register(
      String first, String last, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return '';
    }
    final pref = await SharedPreferences.getInstance();
    log('hit');
    Response res = await dio.post(registerEndPoint,
        data: {
          "firstName": first,
          "lastName": last,
          "email": email,
          "password": password
        },
        options: Options(
          validateStatus: (status) => true,
        ));
    log(res.statusCode.toString());
    log('here');
    log(res.data.toString());
    if (res.statusCode == 200) {
      return "Success";
    } else {
      return res.data;
    }
  }

  //forgot pass --------------------------------------------------------------------------------------------------------------
  Future<String> forgotpass(String email) async {
    if (email == "") {
      throw Exception("");
    }
    Response res = await dio.post(forgotEmailEndpoint,
        data: {
          "email": email,
        },
        options: Options(
          validateStatus: (status) => true,
        ));
    log(res.toString());
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      return 'success';
    } else {
      throw Exception(res.data);
    }
  }

  Future<dynamic> forgotpassotp(String email, String otp) async {
    if (otp == "") {
      throw Exception("");
    }
    Response res = await dio.post(forgotOtpEndpoint,
        data: {"email": email, "otp": otp},
        options: Options(
          validateStatus: (status) => true,
        ));
    if (res.statusCode == 200) {
      log('success');
    } else {
      throw Exception(res.data);
    }
  }

  Future<dynamic> forgotpasschange(
      String email, String otp, String pass) async {
    log(otp);
    if (pass == "") {
      throw Exception();
    }
    Response res = await dio.post(forgotpassEndpoint,
        data: {"email": email, "otp": otp, "password": pass},
        options: Options(
          validateStatus: (status) => true,
        ));
    if (res.statusCode == 200) {
      log('success');
    } else {
      throw Exception(res.data);
    }
  }
}

final api = Provider<API>(((ref) => API()));
