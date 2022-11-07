import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final String baseUrl = 'http://a77e-35-204-31-203.ngrok.io';
  static const String rtmpUrl = 'rtmp://43.201.22.53';

  String accessToken = '';

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  Future<Map<String, dynamic>> getRequest(String url) async {
    http.Response response;
    response = await http.get(Uri.parse(baseUrl + url));
    _printResponseToApiRequest(response, url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body, {bool tokenYn = false}) async {

    http.Response response;
    Map<String, String> headers;

    if (tokenYn) {
      headers = {
        'Content-Type': 'application/json',
        'ACCESS_TOKEN': accessToken
      };
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.post(Uri.parse(baseUrl + url), body: jsonEncode(body), headers: headers);

    _printResponseToApiRequest(response, url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> putRequest(String url, Map<String, dynamic> body,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;
    if (tokenYn) {
      headers = {
        'Content-Type': 'application/json',
        'ACCESS_TOKEN': accessToken
      };
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.put(Uri.parse(baseUrl + url), headers: headers, body: jsonEncode(body));

    _printResponseToApiRequest(response, url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> deleteRequest(String url,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;
    if (tokenYn) {
      headers = {
        'Content-Type': 'application/json',
        'ACCESS_TOKEN': accessToken
      };
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.delete(Uri.parse(baseUrl + url), headers: headers);

    _printResponseToApiRequest(response, url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> patchRequest(
      String url, Map<String, dynamic> body,
      {bool tokenYn = false}) async {
    http.Response response;
    Map<String, String> headers;
    if (tokenYn) {
      headers = {
        'Content-Type': 'application/json',
        'ACCESS_TOKEN': accessToken
      };
    } else {
      headers = {'Content-Type': 'application/json'};
    }
    response = await http.patch(Uri.parse(baseUrl + url), headers: headers, body: jsonEncode(body));

    _printResponseToApiRequest(response, url);

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _printResponseToApiRequest(http.Response response, String url) {
    debugPrint('url : ${baseUrl + url}');
    debugPrint('statusCode : ${response.statusCode}');
    debugPrint('response body : ${utf8.decode(response.bodyBytes)}');
  }
}
