import 'dart:convert';
import 'package:bubble_salmon/global/navigator_observer.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpInterceptor extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await Global.getToken();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseBody);

      if (data["message"] ==
          "The token data is not compatible : Expired token") {
        await Global.clearToken();

        if (AppNavigatorObserver.currentContext != null) {
          ScaffoldMessenger.of(AppNavigatorObserver.currentContext!)
              .showSnackBar(
            SnackBar(
              content: const Text(
                  "Votre session a expirée, veuillez vous reconnecter."),
              backgroundColor: Theme.of(AppNavigatorObserver.currentContext!)
                  .colorScheme
                  .primary,
              duration: Duration(seconds: 3),
            ),
          );

          Navigator.pushNamedAndRemoveUntil(
            AppNavigatorObserver.currentContext!,
            '/login',
            (route) => false,
          );
        }
      }
    }

    return response;
  }
}
