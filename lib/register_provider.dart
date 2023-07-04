import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider_post_data/app_urls.dart';

import 'package:http/http.dart';

import 'register_response.dart';

class RegisterProvider with ChangeNotifier {
  RegisterResponse loginResponse = RegisterResponse();
  int _statusCode = 0;
  bool isLoading = false;

  int get statusCode => _statusCode;

  set loggedInStatus(int value) {
    _statusCode = value;
  }

  loginUser(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> loginData = {
      "email": email.trim(),
      "password": password.trim(),
    };
    return await post(Uri.parse(AppUrls.loginUrl),
        body: jsonEncode(loginData),
        headers: {
          'Content-Type': 'application/json',
        }).then(onValue).catchError(onError);
  }

  Future<FutureOr> onValue(Response response) async {
    String? result;

    final Map<String, dynamic> responseData = json.decode(response.body);
    loginResponse = RegisterResponse.fromJson(responseData);

    _statusCode = response.statusCode;
    if (response.statusCode == 200) {
      result = loginResponse.token;
      isLoading = false;
    } else {
      result = loginResponse.error;
      isLoading = false;
    }

    notifyListeners();
    return result;
  }

  onError(error) async {
    return error;
  }
}
