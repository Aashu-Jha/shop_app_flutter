import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCXJlP4zC_lrLfOe4XG8s7YrWicaoQgwqM';

    try {
      final response = await http.post(
              url,
              body: json.encode({
                'email' : email,
                'password' : password,
                'returnSecureToken' : true,
              })
          );

      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }
}