import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicoo/Sevices/token_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddArtist2api {
  Dio dio = Dio();
  getArtists() async {
    String endpoint =
        "http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/artists";
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('access');
    dio.options.headers["Authorization"] = "Bearer ${token}";
    Response res = await dio.get(endpoint,
        options: Options(
          validateStatus: (status) => true,
        ));
    log(res.data.toString());
    if (res.statusCode == 200) {
      return res.data;
    }
  }

  submitchoices(List<dynamic> artist, List<dynamic> genre) async {
    API api = API();
    await api.get_token();
    String endpoint =
        "http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/profile/choices";

    final pref = await SharedPreferences.getInstance();

    String? token = pref.getString('access');
    dio.options.headers["Authorization"] = "Bearer ${token}";
    log("token => $token");
    log({
      "genreCount": genre.length,
      "artistCount": artist.length,
      "genres": genre.toString(),
      "artists": artist.toString()
    }.toString());
    Response res = await dio.put(endpoint,
        data: {
          "genreCount": genre.length,
          "artistCount": artist.length,
          "genres": genre,
          "artists": artist
        },
        options: Options(
          validateStatus: (status) => true,
        ));
    // if (res.statusCode == 401) {
    //   log(res.statusCode.toString() + " here");
    //   API api = API();
    //   await api.get_token();
    //   return "recall";
    // }
    log(res.statusCode.toString());
  }
}

final addArtist2 = Provider<AddArtist2api>(
  (ref) => AddArtist2api(),
);
