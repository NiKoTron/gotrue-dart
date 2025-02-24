import 'dart:convert';

import 'package:gotrue/src/user.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Session {
  final String? providerToken;
  final String accessToken;

  /// The number of seconds until the token expires (since it was issued).
  /// Returned when a login is confirmed.
  final int? expiresIn;

  final String? refreshToken;
  final String tokenType;
  final User? user;

  const Session({
    required this.accessToken,
    this.expiresIn,
    this.refreshToken,
    required this.tokenType,
    this.providerToken,
    this.user,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: json['access_token'] as String,
        expiresIn: json['expires_in'] as int?,
        refreshToken: json['refresh_token'] as String?,
        tokenType: json['token_type'] as String,
        providerToken: json['provider_token'] as String?,
        user: json['user'] != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'expires_in': expiresIn,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'provider_token': providerToken,
      'user': user?.toJson(),
    };
  }

  /// A timestamp of when the token will expire. Returned when a login is
  /// confirmed.
  int? get expiresAt {
    try {
      final payload = Jwt.parseJwt(accessToken);
      return payload['exp'] as int;
    } catch (_) {
      return null;
    }
  }

  String get persistSessionString {
    final data = {'currentSession': toJson(), 'expiresAt': expiresAt};
    return json.encode(data);
  }

  Session copyWith({
    String? accessToken,
    int? expiresIn,
    String? refreshToken,
    String? tokenType,
    String? providerToken,
    User? user,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      providerToken: providerToken ?? this.providerToken,
      user: user ?? this.user,
    );
  }
}
