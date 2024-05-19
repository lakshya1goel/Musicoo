import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddArtistapi{
  Dio dio = Dio();
  getArtists() async{
    String endpoint ="http://musicoo-env.eba-2fizuegb.us-east-1.elasticbeanstalk.com/api/genres";
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('access');
    dio.options.headers["Authorization"] = "Bearer ${token}";
    Response res = await dio.get(endpoint,options: Options(validateStatus: (status) => true,));
    if(res.statusCode==200){
      return res.data;
    }
  }
}

final addArtist = Provider<AddArtistapi>((ref) => AddArtistapi(),);