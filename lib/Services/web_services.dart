import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart';

class WebServices {
  static const String publicApiKey = "c9250343fb2d3eeac3d2754813289a2c";
  static const String privateApiKey =
      "b932c52ca08f2f1da11614e4f3861eeafb6d221c";
  static const String apiUrl = "http://gateway.marvel.com/v1/public/";
  static String? hash;

  static String getURL(String path, {String extraParams = ""}) {
    DateTime timeStamp = DateTime.now();
    getHash(timeStamp);
    return "$apiUrl$path?apikey=$publicApiKey&hash=$hash&ts=${timeStamp.toIso8601String()}$extraParams";
  }

  static getHash(timeStamp) {
    hash = md5
        .convert(utf8
            .encode(timeStamp.toIso8601String() + privateApiKey + publicApiKey))
        .toString();
  }

  static Future fetchData(Client http, String path, {String extraParams = ""}) async {
    try {
      String url = getURL(path, extraParams: extraParams);
      Response res = await http.get(
        Uri.parse(url),
      );
      log("data fetch completed");
      var json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (json["data"] != null) {
          return json;
        } else {
          return "Data from Api is empty";
        }
      } else if (res.statusCode == 401) {
        return json["message"];
      } else if (res.statusCode == 409) {
        return json["status"];
      } else {
        return res.body;
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}
